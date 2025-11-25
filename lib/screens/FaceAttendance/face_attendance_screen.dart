import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import 'blink_eyes.dart';
import 'face_attendance_store.dart';

/// A naive storage for “enrolled” face data
class LocalFaceData {
  // Path of captured face image
  String? imagePath;
  // Landmarks for naive matching
  Map<FaceLandmarkType, Point<int>>? landmarks;

  LocalFaceData({this.imagePath, this.landmarks});
}

class FaceAttendanceScreen extends StatefulWidget {
  const FaceAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<FaceAttendanceScreen> createState() => _FaceAttendanceScreenState();
}

class _FaceAttendanceScreenState extends State<FaceAttendanceScreen> {
  // Camera
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  // ML Kit FaceDetector
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification:
          true, // needed for eyeOpenProbability, smilingProbability
      enableLandmarks: true,
      enableTracking: true,
      enableContours: false,
    ),
  );

  // Data for “enrolled” face
  LocalFaceData? _enrolledFace;

  // Are we in “enroll” mode or “verify” mode?
  bool _enrollMode = true;

  // Status message
  String _infoText = "Press 'Capture Face' to enroll.";

  // For a naive “liveness” check
  bool _livenessPassed = false;

  bool _isEnrolled = true;

  // Instance of our enrollment store (dummy implementation)
  final FaceEnrollmentStore _store = FaceEnrollmentStore();

  @override
  void initState() {
    super.initState();
    // Lock device orientation to portrait.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initializeCamera();
    _loadEnrollOption();
    // Try to load enrollment from server (if already enrolled)
    _loadEnrollmentFromServer();
  }

  _loadEnrollOption() async {
    _isEnrolled = await _store.isEnrolled();
    setState(() {});
  }

  void _loadEnrollmentFromServer() async {
    final data = await _store.getEnrollment();
    if (data != null) {
      setState(() {
        _enrolledFace = data;
        _infoText = "Face enrolled. Press 'Verify Face' to verify.";
      });
    }
  }

  @override
  void dispose() {
    // Restore orientations if you like:
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // Camera Initialization
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      setState(() {
        _infoText = "No camera found on this device.";
      });
      return;
    }

    // Use the front camera for face detection
    final frontCam = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    _cameraController = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
        _infoText = "Camera ready. Capture your face to enroll.";
      });
    } catch (e) {
      setState(() {
        _infoText = "Error initializing camera: $e";
      });
    }
  }

  /// Capture Face (Enroll)
  Future<void> _captureFace() async {
    if (!_isCameraInitialized) return;
    try {
      final XFile file = await _cameraController!.takePicture();

      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _infoText = "No face detected. Try again.";
        });
        return;
      }

      // Use the first face
      final face = faces.first;

      // Check naive liveness: eyes open?
      final bool isLive = _checkLiveness(face);
      _livenessPassed = isLive;

      if (!isLive) {
        setState(() {
          _infoText = "Liveness check failed! Eyes might be closed. Try again.";
        });
        return;
      }

      // Save image to a permanent location
      final savedPath = await _saveImageLocally(File(file.path));

      // Gather naive landmarks
      final landmarkMap = <FaceLandmarkType, Point<int>>{};
      for (final type in FaceLandmarkType.values) {
        final lm = face.landmarks[type];
        if (lm != null) {
          landmarkMap[type] = lm.position;
        }
      }

      // Store in local face data
      _enrolledFace = LocalFaceData(
        imagePath: savedPath,
        landmarks: landmarkMap,
      );

      // Send the enrolled data to server so that enrollment happens only once.
      final sent = await _store.sendEnrollment(_enrolledFace!);
      if (sent) {
        setState(() {
          _isEnrolled = true;
          _enrollMode = false;
          _infoText = "Face enrolled & liveness OK. Now press 'Verify Face'.";
        });
      } else {
        setState(() {
          _infoText = "Enrollment upload failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _infoText = "Capture error: $e";
      });
    }
  }

  /// Verify Face
  Future<void> _verifyFace() async {
    if (!_isCameraInitialized) return;
    if (_enrolledFace == null) {
      setState(() {
        _infoText = "No enrolled face. Please capture first!";
      });
      return;
    }

    try {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _infoText = "No face detected for verification. Try again.";
        });
        return;
      }

      final face = faces.first;

      // Check naive liveness again
      final bool isLive = _checkLiveness(face);
      if (!isLive) {
        setState(() {
          _infoText = "Verification failed, face not 'live' (eyes closed?).";
        });
        return;
      }

      // Landmarks for the new face
      final newLandmarks = <FaceLandmarkType, Point<int>>{};
      for (final type in FaceLandmarkType.values) {
        final lm = face.landmarks[type];
        if (lm != null) {
          newLandmarks[type] = lm.position;
        }
      }

      // Compare with enrolled face data (naively comparing the distance between eyes)
      final isMatch =
          _naiveCompareFaces(_enrolledFace!.landmarks!, newLandmarks);
      setState(() {
        if (isMatch) {
          _infoText = "Face MATCHED & Liveness OK! Attendance success!";
          toast('Face verified successfully');
          finish(context, true);
        } else {
          _infoText = "Face did NOT match!";
        }
      });
    } catch (e) {
      setState(() {
        _infoText = "Verification error: $e";
      });
    }
  }

  /// Save image to local document directory
  Future<String> _saveImageLocally(File file) async {
    final docDir = await getApplicationDocumentsDirectory();
    final newPath =
        '${docDir.path}/face_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newFile = await file.copy(newPath);
    return newFile.path;
  }

  /// Very naive method: if leftEyeOpen & rightEyeOpen > 0.5 => “live”
  bool _checkLiveness(Face face) {
    final leftProb = face.leftEyeOpenProbability ?? -1.0;
    final rightProb = face.rightEyeOpenProbability ?? -1.0;
    return (leftProb > 0.5 && rightProb > 0.5);
  }

  /// Naive face matching by comparing the distance between left & right eyes.
  bool _naiveCompareFaces(Map<FaceLandmarkType, Point<int>> enrolled,
      Map<FaceLandmarkType, Point<int>> current) {
    if (!enrolled.containsKey(FaceLandmarkType.leftEye) ||
        !enrolled.containsKey(FaceLandmarkType.rightEye) ||
        !current.containsKey(FaceLandmarkType.leftEye) ||
        !current.containsKey(FaceLandmarkType.rightEye)) {
      return false;
    }

    final leftEyeE = enrolled[FaceLandmarkType.leftEye]!;
    final rightEyeE = enrolled[FaceLandmarkType.rightEye]!;
    final distE = _distance(leftEyeE, rightEyeE);

    final leftEyeC = current[FaceLandmarkType.leftEye]!;
    final rightEyeC = current[FaceLandmarkType.rightEye]!;
    final distC = _distance(leftEyeC, rightEyeC);

    final ratio = distC / distE;
    return ratio > 0.9 && ratio < 1.1;
  }

  double _distance(Point<int> p1, Point<int> p2) {
    final dx = (p1.x - p2.x).toDouble();
    final dy = (p1.y - p2.y).toDouble();
    return sqrt(dx * dx + dy * dy);
  }

  // Build the camera preview with aspect ratio.
  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Center(
        child: Text(
          _infoText,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
    final ratio = _cameraController!.value.aspectRatio;
    return RotatedBox(
      quarterTurns: 3,
      child: AspectRatio(
        aspectRatio: ratio,
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  // The face outline overlay (oval).
  Widget _buildFaceOutline() {
    return Center(
      child: Container(
        width: 220,
        height: 270,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: appStore.appColorPrimary, width: 3),
          borderRadius: BorderRadius.circular(150),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom AppBar row.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top AppBar row.
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Face Attendance',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Reset enrollment locally
                        setState(() {
                          _enrollMode = true;
                          _infoText = "Press 'Capture Face' to enroll again.";
                          _enrolledFace = null;
                          _livenessPassed = false;
                        });
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Camera Preview area inside a rounded container.
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildCameraPreview(),
                      _buildFaceOutline(),
                      if (!_livenessPassed) BlinkingEyes(),
                    ],
                  ),
                ),
              ),
              // Information text container.
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _infoText,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Buttons row.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (!_isEnrolled)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _captureFace,
                          icon: Icon(
                            Icons.camera_alt,
                            color: white,
                          ),
                          label: Text(
                            "Capture Face",
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                    if (_isEnrolled)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _verifyFace,
                          icon: Icon(
                            Icons.verified_user,
                            color: white,
                          ),
                          label: Text(
                            "Verify Face",
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
