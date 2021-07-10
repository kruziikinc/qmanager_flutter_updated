import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qmanager_flutter_updated/model/UserModel.dart';
import 'package:qmanager_flutter_updated/screen/CustomerHomeScreen.dart';
import 'package:qmanager_flutter_updated/screen/ForgotPasswordScreen.dart';
import 'package:qmanager_flutter_updated/screen/SignUpScreen.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/AppLocalizations.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'signIn-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _agreedToTOS = true;
  bool _visible = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // int _radioValue = 1;

  @override
  Widget build(BuildContext context) {
    Color grayColor = Color(int.parse("0xFF595856"));

    void _togglePasswordVisibility() {
      setState(() => _visible = !_visible);
    }

    /*void _handleRadioValueChange(int value) {
      setState(() {
        _radioValue = value;
        switch (_radioValue) {
          case 1:
            Utility.showToastMessage("Ash Customer");
            break;
          case 2:
            Utility.showToastMessage("Ash Vendor");
            break;
        }
      });
    }*/

    //input widget
    Widget _input(String hint, TextEditingController controller, bool obsecure,
        TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) =>
              FocusScope.of(context).nextFocus(), // move focus to next
          obscureText: obsecure,
          keyboardType: type,
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: grayColor,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(
                color: grayColor,
                width: 1,
              ),
            ),
          ),
        ),
      );
    }

    Widget _inputPass(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          obscureText: _visible,
          keyboardType: type,
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: grayColor),
              labelText: hint,
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: grayColor,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                  color: grayColor,
                  width: 1,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: _togglePasswordVisibility,
                child: Icon(_visible ? Icons.visibility : Icons.visibility_off),
              )),
        ),
      );
    }

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
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(text,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: () {
          function();
        },
      );
    }

    Widget _outlineButton(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, void function()) {
      return OutlineButton(
//        highlightedBorderColor: Colors.black54,
//        highlightElevation: 0.5,
//        splashColor: splashColor,
        //highlightColor: highlightColor,
        borderSide: BorderSide(color: Colors.black54),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(text,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.normal)),
        onPressed: () {
          function();
        },
      );
    }

    Future<bool> _onWillPop() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Confirm Exit?',
                  style: new TextStyle(color: Colors.black, fontSize: 18.0)),
              content: new Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    // this line exits the app.
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: new Text('Yes', style: new TextStyle(fontSize: 16.0)),
                ),
                new FlatButton(
                  onPressed: () =>
                      Navigator.pop(context), // this line dismisses the dialog
                  child: new Text('No', style: new TextStyle(fontSize: 16.0)),
                )
              ],
            ),
          ) ??
          false;
    }

    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        body: Container(
          child: new Stack(
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
                                image: new AssetImage(
                                    "assets/images/bg_top_home.png"),
                                fit: BoxFit.fill)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
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
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: new AssetImage(
                                          "assets/images/img_logo_login.png"),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0, top: 0),
                          child: Center(
                            child: Text(
                              "By To Be U",
                              style: TextStyle(
                                  color: AppColors.colorRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0, top: 10, left: 20),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
//                                    new Radio(
//                                      value: 1,
//                                      groupValue: _radioValue,
//                                      onChanged: _handleRadioValueChange,
//                                      activeColor: AppColors.colorRed,
//                                    ),
//                                    new Text(
//                                      AppLocalizations.of(context).translate('customer'),
//                                      style: new TextStyle(fontSize: 16.0, color: AppColors.textColor),
//                                    ),
//                          new Radio(
//                            value: 2,
//                            groupValue: _radioValue,
//                            onChanged: _handleRadioValueChange,
//                            activeColor: AppColors.colorRed,
//                          ),
//                          new Text(
//                            AppLocalizations.of(context).translate('vendor'),
//                            style: new TextStyle(fontSize: 16.0, color: AppColors.textColor),
//                          ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 20),
                                  child: _input("Email", _email, false,
                                      TextInputType.emailAddress),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(bottom: 0, top: 0),
                                  child: _inputPass("Password", _password, true,
                                      TextInputType.text),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Visibility(
                                          visible: false,
                                          child: GestureDetector(
                                            child: Row(
                                              children: <Widget>[
                                                Checkbox(
                                                  // checkColor: Colors.white,
                                                  //  activeColor: Colors.red,
                                                  value: _agreedToTOS,
                                                  onChanged: _setAgreedToTOS,
                                                ),
                                                GestureDetector(
                                                  onTap: () => _setAgreedToTOS(
                                                      !_agreedToTOS),
                                                  child: new Text(
                                                    'Keep me Logged in',
                                                    style: TextStyle(
                                                        color: grayColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              // Navigator.of(context).pushNamed(SignUp.routeName);
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                            child: new Container(
                                              child: Text(
                                                "Forgot Password?",
                                                style: TextStyle(
                                                    color: grayColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  ForgotPasswordScreen
                                                      .routeName);
                                            }),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    //bottom: MediaQuery.of(context).viewInsets.bottom
                                  ),
                                  child: Container(
                                    child: _button(
                                        AppLocalizations.of(context)
                                            .translate('str_login'),
                                        Colors.red,
                                        Colors.red,
                                        Colors.red,
                                        Colors.white,
                                        _btnLoginClicked),
                                    height: 50,
                                    width: 200,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Container(
                                    child: _outlineButton(
                                        AppLocalizations.of(context)
                                            .translate('sign_up'),
                                        Colors.red,
                                        Colors.red,
                                        Colors.white,
                                        grayColor,
                                        _btnSignUpClicked),
                                    height: 40,
                                    width: 150,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isValid() {
    if (_email.text.isEmpty) {
      Utility.showToastMessage("Please enter email");
      return false;
    } else if (_password.text.isEmpty) {
      Utility.showToastMessage("Please enter password");
      return false;
    }
    return true;
  }

  void _btnLoginClicked() {
    FocusScope.of(context).unfocus();
    if (isValid()) {
      loginAPI();
    }
  }

  void loginAPI() {
    Map<String, dynamic> bodyParams = {
      "email": _email.text,
      "password": _password.text
    };

    Utility.showLoader(context);
    new APIManger().apiRequest(AppConstant.API_LOGIN, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      UserModel model = UserModel.fromJson(json);
      Utility().currentUser = model;
      SessionManager().setUserModel(model);
      Utility.showToastMessage(message);
      _firebaseMessaging
          .subscribeToTopic(AppConstant.TOPIC + model.id.toString());
      Navigator.of(context).pushNamed(CustomerHomeScreen.routeName);
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }

  void _btnSignUpClicked() {
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  /*bool _submittable() {
    return _agreedToTOS;
  }*/

  Widget loadingView(bool isShow) => Center(
        child: Visibility(
          visible: isShow,
          child: CircularProgressIndicator(
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      );

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}
