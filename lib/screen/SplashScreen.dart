import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';
import 'package:qmanager_flutter_updated/screen/CustomerHomeScreen.dart';
import 'package:qmanager_flutter_updated/screen/LoginScreen.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';
import 'package:store_redirect/store_redirect.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen_State createState() => _SplashScreen_State();
}

class _SplashScreen_State extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/signIn');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firebaseCloudMessaging_Listeners();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    //  var initializationSettings = new InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Timer(Duration(seconds: 3),()=>checkForSession());
    if (Utility().currentUser != null) {
      if (Utility().currentUser.id.toString() != null &&
          Utility().currentUser.id.toString() != "") {
        FirebaseMessaging().subscribeToTopic(
            AppConstant.TOPIC + Utility().currentUser.id.toString());
      }
    }

    if (Platform.isAndroid) {
      Utility().currentAppVersionAsPerPlatform =
          AppConstant.CURRENT_ANDROID_VERSION;
    } else if (Platform.isIOS) {
      // iOS-specific code
      Utility().currentAppVersionAsPerPlatform =
          AppConstant.CURRENT_IOS_VERSION;
    }
    checkAppVersion();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("Token: " + token);
      SessionManager().saveDeviceToken(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void showNotification(Map<String, dynamic> message) async {
    //  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    //    'your channel id', 'your channel name', 'your channel description',
    //     playSound: false, importance: Importance.max, priority: Priority.high);
    // var iOSPlatformChannelSpecifics =
    // new IOSNotificationDetails(presentSound: false);
    // var platformChannelSpecifics = new NotificationDetails(
    //   androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android, iOS);
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }

  void checkAppVersion() {
    String platform = "";
    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      // iOS-specific code
      platform = "iOS";
    }
    Map<String, String> bodyParams = {"platform": platform};
    APIManger().apiRequest(AppConstant.API_APP_VERSION, bodyParams,
        (json, message) {
      Map<String, dynamic> obj = json;
      compareAppVersion(obj["current_version"], obj['message']);
    }, (message) {
      Utility.showToastMessage(message);
      checkForSession();
    });
  }

  void compareAppVersion(String newVersion, String message) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    currentVersion = currentVersion.split(".").join("");
    newVersion = newVersion.split(".").join("");
    if (int.parse(currentVersion) < int.parse(newVersion)) {
      showAlertDialog(context, message);
    } else {
      checkForSession();
    }
  }

  /* Timer(
  Duration(seconds: 3),
  () =>
  Navigator.of(context).pushNamed(signIn.routeName));*/

  void checkForSession() {
    SessionManager sessionManager = new SessionManager();

    new SessionManager().getUserModel((userModel) {
      if (userModel == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            ModalRoute.withName("/Login"));
      } else {
        Utility().currentUser = userModel;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CustomerHomeScreen()),
            ModalRoute.withName("/Home"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/img_splash.png"),
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String serverMessage) {
    // set up the button
    serverMessage = serverMessage ??
        "A new app version is available. Please update your app.";

    Widget okButton = FlatButton(
      child: Text(
        "Update",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        //performLogout();
        pushToAppPlayStore();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Available"),
      content: Text(
        serverMessage,
        style: TextStyle(fontSize: 20.0),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void pushToAppPlayStore() {
    StoreRedirect.redirect(
        androidAppId: "com.tobeu.qmanager", iOSAppId: AppConstant.APPSTORE_ID);
  }
}
