import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/Document/document_type_model.dart';
import 'package:open_core_hr/models/Expense/expense_type_model.dart';
import 'package:open_core_hr/models/leave_type_model.dart';
import 'package:open_core_hr/models/notice_model.dart';
import 'package:open_core_hr/routes.dart';
import 'package:open_core_hr/service/TrackingService.dart';
import 'package:open_core_hr/service/map_helper.dart';
import 'package:open_core_hr/service/module_service.dart';
import 'package:open_core_hr/service/offline_tracking_sync_service.dart';
import 'package:open_core_hr/service/permission_service.dart';
import 'package:open_core_hr/store/global_attendance_store.dart';
import 'package:open_core_hr/utils/app_constants.dart';
import 'package:open_core_hr/utils/app_theme.dart';

import 'api/api_service.dart';
import 'firebase_options.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'models/Chat/chat_list_model.dart';
import 'screens/splash_screen.dart';
import 'service/SharedHelper.dart';
import 'store/AppStore.dart';
import 'utils/app_data_provider.dart';

AppStore appStore = AppStore();
GlobalAttendanceStore globalAttendanceStore = GlobalAttendanceStore();
ApiService apiService = ApiService();
SharedHelper sharedHelper = SharedHelper();
MapHelper mapHelper = MapHelper();
PermissionService permissionService = PermissionService();
ModuleService moduleService = ModuleService();
late BaseLanguage language;
OfflineTrackingSyncService offlineTrackingSyncService =
    OfflineTrackingSyncService();
//Tracking & Activity
TrackingService trackingService = TrackingService();
final _activityStreamController = StreamController<Activity>();
StreamSubscription<Activity>? _activityStreamSubscription;
StreamSubscription<Position>? _locationStreamSubscription;

final DateFormat formatter = DateFormat('dd-MM-yyyy');

final DateFormat dateTimeFormatter = DateFormat('dd-MM-yyyy hh:mm a');

final DateFormat formDateFormatter = DateFormat('yyyy-MM-dd');

final timeFormat = DateFormat('hh:mm a');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  log('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !isWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //Box 0
  Hive.registerAdapter(ChatAdapter());
  await Hive.openBox<Chat>('chatBox');

  //Box 1
  Hive.registerAdapter(NoticeModelAdapter());
  await Hive.openBox<NoticeModel>('noticeBoardBox');

  //Box 2
  Hive.registerAdapter(LeaveTypeModelAdapter());
  await Hive.openBox<LeaveTypeModel>('leaveTypeBox');

  //Box 3
  Hive.registerAdapter(ExpenseTypeModelAdapter());
  await Hive.openBox<ExpenseTypeModel>('expenseTypeBox');

  //Box 4
  Hive.registerAdapter(DocumentTypeModelAdapter());
  await Hive.openBox<DocumentTypeModel>('documentTypeBox');

  OfflineTrackingSyncService.initializeHive();

  await initialize(aLocaleLanguageList: languageList());

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));
  appStore.toggleColorTheme();
  await appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));

  defaultRadius = 10;
  defaultToastGravityGlobal = ToastGravity.BOTTOM;

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }

  if (!isWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupFlutterNotifications();
  }
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
        home: const SplashScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        routes: routes(),
        navigatorKey: navigatorKey,
        scrollBehavior: SBehavior(),
        supportedLocales: LanguageDataModel.languageLocales(),
        localizationsDelegates: const [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
      ),
    );
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStartOnBoot: true,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: '$mainAppName Background Service',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

//TODO: Stop on day end.
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    log('$mainAppName 🔥BG Service: onStart Called');
    DartPluginRegistrant.ensureInitialized();
    await initialize();
    await Hive.initFlutter();
    OfflineTrackingSyncService.initializeHive();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    var canTrack = preferences.getBool(isTrackingOnPref) ?? false;
    var isLoggedIn = preferences.getBool(isLoggedInPref) ?? false;
    bool isTrackingEnabled = isLoggedIn && canTrack;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    log('$mainAppName 🔥BG Service: Init done');

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        log('$mainAppName 🔥BG Service: Set As Foreground');
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        log('$mainAppName 🔥BG Service: Set As Background');
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    service.on('startService').listen((event) {
      log('$mainAppName 🔥BG Service: startService invoked');
    });

    log('$mainAppName 🔥BG Service: Started');
    String message = 'error';
    try {
      if (!isTrackingEnabled) {
        log('$mainAppName 🔥BG Service: Tracking Disabled');
        stopAllStreams();
        service.stopSelf();
      } else {
        log('$mainAppName 🔥BG Service: Tracking Enabled');
        startAllStreams();
      }
      message = 'Service Running';

      if (kDebugMode) {
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          log('$mainAppName 🔥BG Service: Debug Timer Start');
          await debugBgNotificationLog();
          log('$mainAppName 🔥BG Service: Debug Timer End');
        });
      }
    } catch (e) {
      log('$mainAppName 🔥BG Service: Main Exception $e');
      message = e.toString();
    }

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          888,
          'Background Service is running to track your location',
          message,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'foreground_service',
              'ATTENDANCE FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
              enableVibration: false,
              playSound: false,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: false,
              presentBadge: false,
              presentSound: false,
            ),
          ),
        );
      }
    }
  } catch (e) {
    log("$mainAppName 🔥BG Service: Main Exception $e");
  }
}

void _onActivityReceive(Activity activity) {
  log('$mainAppName 🔥BG Service: Activity Received >> ${activity.type} Confidence ${activity.confidence}');
  trackingService.updateAttendanceStatus(activity);
  _activityStreamController.sink.add(activity);
}

void _handleActivityError(dynamic error) {
  log('$mainAppName 🔥BG Service: Activity Error >> $error');
}

Future debugBgNotificationLog() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.reload();
  var now = DateTime.now();
  final DateFormat formatter = DateFormat('jms');
  final String formattedTime = formatter.format(now);
  var locCount = preferences.getInt(locationCountPref);
  var actCount = preferences.getInt(activityCountPref);
  var message =
      'LC: ${locCount ?? 'N/A'} AC: ${actCount ?? 'N/A'}, $formattedTime';
  log('$mainAppName 🔥BG Service: Message >> $message');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    888,
    'Background Service Debug is running',
    message,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'foreground_service_debug',
        'ATTENDANCE DEBUG FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        ongoing: true,
        enableVibration: false,
        playSound: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
        presentBanner: false,
        presentList: false,
      ),
    ),
  );
}

void startAllStreams() {
  try {
    log('$mainAppName 🔥BG Service: Starting All Streams');
    //Activity Tracker
    var activityRecognition = FlutterActivityRecognition.instance;
    _activityStreamSubscription = activityRecognition.activityStream
        .handleError(_handleActivityError)
        .listen(_onActivityReceive);

    log('$mainAppName 🔥BG Service: Activity Stream Started');

    //TODO: Need to take distance filter from settings
    final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: sharedHelper.getDistanceFilter());

    //Location Tracker
    _locationStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      var pos = position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}';
      log('$mainAppName 🔥BG Service: Location Updated >> $pos');

      if (position != null) {
        trackingService.updateDeviceStatusV2(position);
      }
    });

    log('$mainAppName 🔥BG Service: Location Stream Started');
  } catch (e) {
    log('$mainAppName 🔥BG Service: Error Starting Streams $e');
  }
}

void stopAllStreams() {
  log('$mainAppName 🔥BG Service: Stopping All Streams');
  if (_activityStreamSubscription != null) {
    _activityStreamSubscription?.cancel();
  }

  log('$mainAppName 🔥BG Service: Activity Stream Stopped');

  if (_locationStreamSubscription != null) {
    _locationStreamSubscription?.cancel();
  }

  log('$mainAppName 🔥BG Service: Location Stream Stopped');
}
