import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = 'change_Pass';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scafolledKey = new GlobalKey<ScaffoldState>();
  TextEditingController _old_password = new TextEditingController();
  TextEditingController _new_password = new TextEditingController();
  TextEditingController _confirm_password = new TextEditingController();
  bool _visible = true;

  void _togglePasswordVisibility() {
    setState(() => _visible = !_visible);
  }

  @override
  Widget build(BuildContext context) {
    Color grayColor = Color(int.parse("0xFF595856"));
    //input widget
    Widget _input(String hint, TextEditingController controller, bool obsecure,
        TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          keyboardType: type,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) =>
              FocusScope.of(context).nextFocus(), // move focus to next
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
        bool obsecure, TextInputType type, bool isDone) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          obscureText: _visible,
          keyboardType: type,
          textInputAction: isDone ? TextInputAction.done : TextInputAction.next,
          onSubmitted: (_) =>
              FocusScope.of(context).nextFocus(), // move focus to next
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

    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomPadding: false,
      key: _scafolledKey,
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
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                  ),
                                  iconSize: 30,
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
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
              Expanded(
                child: SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, top: 20),
                        child: Center(
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                                color: grayColor,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 0, top: 10),
                        child: _inputPass("Old Password", _old_password, true,
                            TextInputType.text, false),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 0, top: 10),
                        child: _inputPass("New Password", _new_password, true,
                            TextInputType.text, false),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new Padding(
                        padding: EdgeInsets.only(bottom: 0, top: 10),
                        child: _inputPass("Confirm Password", _confirm_password,
                            true, TextInputType.text, true),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 30,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: _button("Submit", Colors.red, Colors.red,
                              Colors.red, Colors.white, _btnSubmitClicked),
                          height: 50,
                          width: 200,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _btnSubmitClicked() {
    FocusScope.of(context).unfocus();
    if (isValid()) {
      changePasswordAPI();
    }
  }

  void changePasswordAPI() {
    Map<String, dynamic> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "password": _new_password.text,
      "connfirm_password": _confirm_password.text,
      "old_password": _old_password.text
    };

    Utility.showLoader(context);
    new APIManger().apiRequest(AppConstant.API_UPDATE_PASS, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
      Navigator.pop(context);
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }

  bool isValid() {
    if (_old_password.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter old password");
      return false;
    }

    if (_new_password.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter new password");
      return false;
    }

    if (_confirm_password.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter confirm password");
      return false;
    }

    if (_confirm_password.text != _new_password.text) {
      Fluttertoast.showToast(
          msg: "New password and confirm password not matched");
      return false;
    }

    return true;
  }
}
