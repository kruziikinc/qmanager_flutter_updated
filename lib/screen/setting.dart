import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/screen/LoginScreen.dart';
import 'package:qmanager_flutter_updated/screen/Profile.dart';
import 'package:qmanager_flutter_updated/screen/changePassword.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with WidgetsBindingObserver {
  Color bgColor = Color(int.parse("0xFFF3F4F5"));
  Color grayColor = Color(int.parse("0xFF595856"));

  //button widget
  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(text,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.normal)),
      onPressed: () {
        Navigator.of(context).pushNamed(Profile.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // resizeToAvoidBottomPadding: false,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  new Container(
                    //color: Theme.of(context).primaryColor,
                    //color: Colors.red,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image:
                                new AssetImage("assets/images/bg_top_home.png"),
                            fit: BoxFit.fill)),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 20),
                            child: Row(
                              children: <Widget>[
                                new Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: new AssetImage(
                                                "assets/images/ic_logo_sign.png"),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                                Spacer(),
                                Text("Settings",
                                    style: new TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.notifications),
                                  color: Colors.white,
                                  iconSize: 0,
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              width: 100,
                              height: 100,
//                            decoration: BoxDecoration(
//                                shape: BoxShape.rectangle,
//                                image: DecorationImage(
//                                    image: new AssetImage("assets/images/ic_logo_sign.png"),
//                                    fit: BoxFit.fill
//                                )
//                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          width: 160,
                          height: 130,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: new AssetImage(
                                      "assets/images/img_pass.png"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              new Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 0),
                    child: Center(
                      child: Text(
                        Utility().currentUser.firstName +
                            " " +
                            Utility().currentUser.lastName,
                        style: TextStyle(
                            color: grayColor,
                            fontSize: 22,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: _button("My Profile", Colors.red, Colors.red,
                          Colors.red, Colors.white, _btnMyProfileClicked),
                      height: 40,
                      width: 150,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  new Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.lock),
                            title: Text(
                              'Change Password',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ChangePassword.routeName);
                            },
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              'App Version ' +
                                  Utility().currentAppVersionAsPerPlatform,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            onTap: () {
                              // Navigator.pop(context);
                              // Navigator.of(context).pushNamed(profile.routeName);
                            },
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_back),
                            title: Text(
                              'Logout',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            onTap: () {
                              showAlertDialog(context);
                            },
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _btnMyProfileClicked() {}

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        performLogout();
      },
    );

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        okButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void performLogout() {
    SessionManager().getDeviceToken((resultString) {
      if (resultString != null) {
        logoutAPI(resultString);
      }
    });
  }

  void logoutAPI(String fcmToken) {
    Map<String, dynamic> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "token": fcmToken
    };

    Utility.showLoader(context);
    new APIManger().apiRequest(AppConstant.API_LOGOUT, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
      FirebaseMessaging().unsubscribeFromTopic(
          AppConstant.TOPIC + Utility().currentUser.id.toString());
      SessionManager().clearSession();
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    if (state == AppLifecycleState.resumed) {
//      //do your stuff
//      _
//    }
//  }
}
