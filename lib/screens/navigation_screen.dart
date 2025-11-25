import 'dart:async';

import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Calendar/calendar_screen.dart';
import 'package:open_core_hr/screens/Chat/chat_store.dart';
import 'package:open_core_hr/screens/ChatList/chat_list_screen.dart';
import 'package:open_core_hr/screens/Home/home_screen.dart';
import 'package:open_core_hr/screens/NoticeBoard/notice_board_screen.dart';
import 'package:open_core_hr/screens/Permission/permissions_screen.dart';
import 'package:open_core_hr/screens/Task/task_screen.dart';
import 'package:open_core_hr/service/offline_tracking_sync_service.dart';
import 'package:open_core_hr/utils/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Utils/app_widgets.dart';
import '../main.dart';
import '../models/Chat/chat_list_model.dart';
import 'Chat/chat_screen.dart';

class NavigationScreen extends StatefulWidget {
  static String tag = '/NavigationScreen';
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isCalendarEnabled = moduleService.isCalendarModuleEnabled();
  final chatStore = ChatStore();
  var _currentIndex = 0;
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void init() async {
    setDarkStatusBar();
    await appStore.refreshAttendanceStatus();
    if (globalAttendanceStore.isKillDevice) {
      trackingService.stopTrackingService();
      toast(language.lblYourDeviceIsRestrictedToUseThisAppPleaseContactAdmin);
      if (!mounted) return;
      sharedHelper.logout(context);
    }
    checkAllPermissions();
    handleTrackingService();
    checkBatteryOptimisation();
    setupFirebase();
    setupIncomingShare();
    validateDevice();
    setupOfflineSync();
  }

  void setupOfflineSync() {
    OfflineTrackingSyncService.periodicSync();
  }

  validateDevice() async {
    var result = await sharedHelper.validateDevice();
    if (!result) {
      if (!mounted) return;
      sharedHelper.logout(context);
    }
  }

  void _showShareSheet() async {
    final selectedChat = await showModalBottomSheet<Chat?>(
      context: context,
      builder: (context) => Column(
        children: [
          20.height,
          Text(language.lblSelectChatToForwardTo, style: primaryTextStyle()),
          5.height,
          Expanded(
            child: _selectChatForForwarding(),
          ),
        ],
      ),
    );

    if (selectedChat != null && list != null && list!.isNotEmpty) {
      if (list!.first.type == SharedMediaType.FILE ||
          list!.first.type == SharedMediaType.IMAGE ||
          list!.first.type == SharedMediaType.VIDEO ||
          list!.first.type == SharedMediaType.OTHER) {
        if (!mounted) return;
        log('Selected Chat is: ${selectedChat.id.toString()}');
        XFile? file = XFile(list!.first.value!);
        var result = await chatStore.sendAttachment(
            selectedChat.id, list!.first.value!, file.path.split('.').last);
        if (result) {
          setState(() {
            _currentIndex = 2;
          });
          ChatScreen(chat: selectedChat).launch(context);
          toast(language.lblFileForwardedSuccessfully);
        }
      } else {
        if (!mounted) return;
        log('Selected Chat is: ${selectedChat.id.toString()}');
        await chatStore.sendMessage(selectedChat.id, list!.first.value!);
        setState(() {
          _currentIndex = 2;
        });
        ChatScreen(chat: selectedChat).launch(context);
        toast(language.lblMessageForwardedSuccessfully);
      }
    }
  }

  Widget _selectChatForForwarding() {
    return FutureBuilder<List<Chat>>(
      future: apiService.getChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(language.lblNoChatsAvailableToForward));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final chat = snapshot.data![index];
            return _buildChatListItem(chat).onTap(() {
              Navigator.pop(context, chat);
            });
          },
        );
      },
    );
  }

  Widget _buildChatListItem(Chat chat) {
    return ListTile(
      leading:
          userProfileWidget(chat.name, hideStatus: true, imageUrl: chat.avatar),
      title: Text(chat.name, style: primaryTextStyle(size: 16)),
      subtitle: Text(chat.lastMessage ?? language.lblNoMessagesYet,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: secondaryTextStyle(size: 12)),
      trailing: Text(
        chat.updatedAt,
        style: secondaryTextStyle(size: 10),
      ),
    );
  }

  void setupIncomingShare() async {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      setState(() {
        list = value;
      });
      if (list != null && list!.isNotEmpty) {
        _showShareSheet();
      }
      log("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {
      log("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      log("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");

      setState(() {
        list = value;
      });
      if (list != null && list!.isNotEmpty) {
        _showShareSheet();
      }
    });
  }

  void setupFirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("message received");
      log(event.notification!.body);
      if (!mounted) return;
      snackBar(
        context,
        title: event.notification!.title!,
        content: Text(event.notification!.body!),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Message clicked!');
    });
  }

  void checkBatteryOptimisation() async {
    if (isAndroid) {
      await DisableBatteryOptimizationLatest
          .showDisableBatteryOptimizationSettings();
    }
  }

  void handleTrackingService() {
    if (globalAttendanceStore.isCheckedIn) {
      setValue(isTrackingOnPref, true);
      trackingService.startTrackingService();
    } else {
      setValue(isTrackingOnPref, false);
      trackingService.stopTrackingService();
    }
  }

  void checkAllPermissions() async {
    if (isIOS) {
      var hasAllPermissionsGranted = await Permission
              .notification.status.isGranted &&
          await Permission.sensors.status.isGranted &&
          (await Geolocator.checkPermission() == LocationPermission.always ||
              await Geolocator.checkPermission() ==
                  LocationPermission.whileInUse);
      if (!hasAllPermissionsGranted) {
        PermissionScreen().launch(context, isNewTask: true);
      }
    } else {
      var hasAllPermissionsGranted =
          await Permission.notification.status.isGranted &&
              await Permission.location.status.isGranted &&
              await Permission.activityRecognition.status.isGranted &&
              await Permission.locationAlways.status.isGranted;

      if (!hasAllPermissionsGranted) {
        PermissionScreen().launch(context, isNewTask: true);
      }
    }
  }

  void sendSOS() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Map req = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
    var result = await apiService.sendSoS(req);
    if (result) {
      toast(language.lblAdminIsNotified);
    } else {
      toast(language.lblFailedToSendSOS);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = [
      HomeScreen(
        sidebarClick: () {},
      ),
      if (isCalendarEnabled) CalendarScreen(),
      const TaskScreen(),
      const ChatListScreen(),
      const NoticeBoard(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        if (_currentIndex == 0) {
          if (await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(language.lblExitApp),
                    content: Text(language.lblAreYouSureYouWantToExit),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(language.lblNo),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(language.lblYes),
                      ),
                    ],
                  );
                },
              ) ??
              false) {
            SystemNavigator.pop();
          }
        } else {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        appBar: null,
        body: tab[_currentIndex],
        bottomNavigationBar: Observer(
          builder: (_) => BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              _navBarItem(Iconsax.home_1, Iconsax.home5, language.lblHome),
              if (isCalendarEnabled)
                _navBarItem(Iconsax.calendar, Iconsax.calendar5, 'Calendar'),
              _navBarItem(
                  Iconsax.activity, Iconsax.activity5, language.lblTasks),
              _navBarItem(Iconsax.message, Iconsax.message5, language.lblChats),
              _navBarItem(Iconsax.task_square, Iconsax.task_square5,
                  language.lblNoticeBoard),
            ],
          ),
        ),
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: () => _showSOSPopup(),
                backgroundColor: Colors.redAccent,
                label: Text(language.lblSOS,
                    style: TextStyle(color: Colors.white)),
                icon: const Icon(Iconsax.warning_2, color: Colors.white),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  BottomNavigationBarItem _navBarItem(
      IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: appStore.iconColor),
      activeIcon: Icon(activeIcon, color: appStore.appColorPrimary),
      label: label,
    );
  }

  void _showSOSPopup() {
    int countdown = sosTimer; // Countdown duration
    Timer? timer;
    late AnimationController _controller;
    late Animation<double> _animation;

    // Initialize the AnimationController before the dialog
    _controller = AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(seconds: countdown),
    )..forward();

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // Start the timer only once
          timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
            setState(() {
              countdown--;
            });
            sharedHelper.vibrate();

            if (countdown <= 0) {
              t.cancel();
              _controller.dispose();
              Navigator.of(context).pop();
              sendSOS();
            }
          });

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Center(
              child: Text(
                language.lblSOSAlert,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${language.lblEmergencyNotificationWillBeSentIn}:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                16.height,
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SizedBox(
                      height: 120,
                      width: 120,
                      child: CustomPaint(
                        painter: _CircularProgressPainter(
                          progress: _animation.value,
                          strokeWidth: 8,
                          color: Colors.redAccent,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Text(
                            '$countdown',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _controller.dispose();
                  timer?.cancel();
                  Navigator.of(context).pop();
                },
                child: Text(
                  language.lblCancel,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          );
        });
      },
    ).then((_) {
      if (_controller.isAnimating) {
        _controller.dispose();
      }
      if (timer != null || timer!.isActive) {
        timer?.cancel();
      }
    });
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress; // From 1.0 to 0.0
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size; // Size of the canvas

    // Background Paint
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Progress Paint with Rounded Corners
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw Background Circle
    canvas.drawArc(
      rect.deflate(strokeWidth / 2), // Adjust for stroke width
      -90 * (3.1415927 / 180), // Start at the top
      360 * (3.1415927 / 180), // Full circle
      false,
      backgroundPaint,
    );

    // Draw Progress Arc
    canvas.drawArc(
      rect.deflate(strokeWidth / 2), // Adjust for stroke width
      -90 * (3.1415927 / 180), // Start at the top
      360 * progress * (3.1415927 / 180), // Progress value
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
