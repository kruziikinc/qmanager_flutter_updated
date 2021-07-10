import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = 'forgot_password';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<ScaffoldState> _scafolledKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = new TextEditingController();

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
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
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
              new Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 20),
                    child: Center(
                      child: Text(
                        "Forgot Password",
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
                    padding: EdgeInsets.only(bottom: 0, top: 20),
                    child: _input("Enter email", _email, false,
                        TextInputType.emailAddress),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10,
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
            ],
          )
        ],
      ),
    );
  }

  void _btnSubmitClicked() {
    if (isValid()) {
      forgotPasswordAPI();
    }
  }

  bool isValid() {
    if (_email.text.isEmpty) {
      Utility.showToastMessage("Please enter email");
      return false;
    }
    if (!Utility().isValidEmail(_email.text)) {
      Utility.showToastMessage("Please enter valid email");
      return false;
    }
    return true;
  }

  void forgotPasswordAPI() {
    Map<String, dynamic> bodyParams = {"email": _email.text};

    Utility.showLoader(context);
    new APIManger().apiRequest(AppConstant.API_FORGOT_PASS, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }
}
