import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:open_core_hr/main.dart';
import 'package:path_provider/path_provider.dart';

import 'face_attendance_screen.dart'; // To access LocalFaceData

class FaceEnrollmentStore {
  Future<bool> isEnrolled() async {
    try {
      // Dummy API call. Replace with your actual API call.
      var result = await apiService.isFaceDataAdded();
      return result;
    } catch (e) {
      print("Error fetching enrollment: $e");
      return false;
    }
  }

  /// Sends the enrollment data (face image and landmarks) to the server.
  Future<bool> sendEnrollment(LocalFaceData data) async {
    try {
      // Convert landmarks to a JSON string.
      final landmarksMap = data.landmarks?.map((key, value) =>
          MapEntry(key.toString(), {'x': value.x, 'y': value.y}));

      var result = await apiService.enrollFace(
          data.imagePath!, jsonEncode(landmarksMap));

      return result;
    } catch (e) {
      print("Error sending enrollment: $e");
      return false;
    }
  }

  /// Gets the enrollment data from the server.
  Future<LocalFaceData?> getEnrollment() async {
    try {
      // Dummy API call. Replace with your actual API call.
      var jsonResponse = await apiService.getFaceData();
      // Expecting jsonResponse to contain an image URL.
      String imageUrl = jsonResponse['imageUrl'];

      // Download the image and fix its orientation.
      final imagePath = await _downloadImage(imageUrl);

      // Re-run face detection on the fixed image to get updated landmarks.
      final inputImage = InputImage.fromFilePath(imagePath);
      final faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          enableLandmarks: true,
          enableTracking: true,
          enableContours: false,
        ),
      );
      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      if (faces.isNotEmpty) {
        final face = faces.first;
        final landmarkMap = <FaceLandmarkType, Point<int>>{};
        for (final type in FaceLandmarkType.values) {
          final lm = face.landmarks[type];
          if (lm != null) {
            landmarkMap[type] = lm.position;
          }
        }
        return LocalFaceData(imagePath: imagePath, landmarks: landmarkMap);
      }
      return null;
    } catch (e) {
      print("Error fetching enrollment: $e");
      return null;
    }
  }

  /// Helper: Download image from a URL and save it locally.
  Future<String> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/downloaded_enrollment.jpg';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    // Rotate the image correctly using flutter_exif_rotation.
    final fixedFile = await FlutterExifRotation.rotateImage(path: file.path);

    return fixedFile.path;
  }

  /// Helper: Parse a string to FaceLandmarkType.
  FaceLandmarkType _parseFaceLandmarkType(String key) {
    // Assuming the key comes as 'leftEye', 'rightEye', etc.
    switch (key) {
      case 'leftEye':
        return FaceLandmarkType.leftEye;
      case 'rightEye':
        return FaceLandmarkType.rightEye;
      case 'noseBase':
        return FaceLandmarkType.noseBase;
      // Add additional cases as needed.
      default:
        return FaceLandmarkType.leftEye;
    }
  }
}
