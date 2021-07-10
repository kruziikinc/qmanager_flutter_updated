import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qmanager_flutter_updated/model/StateModel.dart';
import 'package:qmanager_flutter_updated/model/UserModel.dart';
import 'package:qmanager_flutter_updated/screen/CustomerHomeScreen.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/AppLocalizations.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'signUp-screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _gender = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _streetAddress = new TextEditingController();
  TextEditingController _streetAddress2 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _zipcode = new TextEditingController();

  List countryList = new List<StateModel>();
  List stateList = new List<StateModel>();
  List cityList = new List<StateModel>();
  int selCountryId;
  int selStateId;
  int selCityId;
  @override
  void initState() {
    getCountryListAPI();
    super.initState();
  }

  PickedFile _image;
  getImageFile(ImageSource source) async {
    var image = await ImagePicker().getImage(source: source);
    setState(() {
      _image = image;
    });
  }

  actionSheetMethod(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => {Navigator.of(context).pop("Discard")},
              child: Text("Cancel"),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: () {}, child: Text("Camera")),
              CupertinoActionSheetAction(
                  onPressed: () => getImageFile(ImageSource.gallery),
                  child: Text("Gallery")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color grayColor = Color(int.parse("0xFF595856"));

    //input widget
    Widget _inputFullName(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
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

    Widget _inputMobile(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
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

    Widget _inputEmail(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
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

    Widget _inputDob(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: true,
          onTap: () {
            Utility().showDatePicker(
                context, DateTime(1800, 01, 01), DateTime(2100), (value) {
              _dob.text = value;
            });
          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            suffixIcon: Icon(
              Icons.calendar_today,
              size: 20,
            ),
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

    Widget _inputGender(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: true,
          onTap: () async {
            Utility().showBottonSheetMenu(context, ["Male", "Female"], (value) {
              _gender.text = value;
            });
          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
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

    Widget _inputStreetAdd(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
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

    Widget _inputStreetAdd2(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
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

    Widget _inputCity(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: true,
          onTap: () async {
            if (_state.text.length == 0) {
              Utility.showToastMessage("Please select state");
              return;
            }
            if (cityList.length == 0) {
              Utility.showToastMessage("No city found");
              return;
            }
            Utility().showStateCityDropDown(context, cityList, "City List",
                (model) {
              performOnCitySelection(model);
            });
          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
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

    Widget _inputCountry(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: true,
          onTap: () async {
            Utility().showStateCityDropDown(
                context, countryList, "Country List", (model) {
              performOnCountrySelection(model);
            });
          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
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

    Widget _inputState(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          readOnly: true,
          onTap: () async {
            if (_country.text.length == 0) {
              Utility.showToastMessage("Please select country");
              return;
            }
            if (stateList.length == 0) {
              Utility.showToastMessage("No state found");
              return;
            }

            Utility().showStateCityDropDown(context, stateList, "State List",
                (model) {
              performOnStateSelection(model);
            });
          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
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

    Widget _inputZipcode(String hint, TextEditingController controller,
        bool obsecure, TextInputType type) {
      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: TextField(
          controller: controller,
          keyboardType: type,
          maxLength: 10,
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
                            width: 80,
                            height: 80,

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
                    IconButton(
                      padding: const EdgeInsets.only(top: 50, left: 20),
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                    Container(
                      padding: EdgeInsets.only(top: 55),
                      child: Center(
                        child: Text(
                          "Sign up",
                          style: new TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorWhite),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: new ListView(
                    padding: const EdgeInsets.only(bottom: 50),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      new Column(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 20),
                            child: _inputFullName("First Name", _firstName,
                                false, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputFullName("Last Name", _lastName, false,
                                TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputMobile(
                                "Mobile", _mobile, true, TextInputType.number),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputEmail("Email", _email, true,
                                TextInputType.emailAddress),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputDob(
                                "My Birthday", _dob, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputGender(
                                "Gender", _gender, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputPass("Password", _password, true,
                                TextInputType.text),
                          ),
//                          SizedBox(
//                            height: 30,
//                          ),
//                          new Padding(
//                            padding: EdgeInsets.only(bottom: 0, top: 0),
//                            child: _inputStreetAdd("Street Address Line 1",
//                                _streetAddress, true, TextInputType.text),
//                          ),
//                          SizedBox(
//                            height: 15,
//                          ),
//                          new Padding(
//                            padding: EdgeInsets.only(bottom: 0, top: 0),
//                            child: _inputStreetAdd2("Street Address Line 2",
//                                _streetAddress2, true, TextInputType.text),
//                          ),
//                          SizedBox(
//                            height: 15,
//                          ),
//                          new Padding(
//                            padding: EdgeInsets.only(bottom: 0, top: 0),
//                            child: _inputCountry(
//                                "Country", _country, true, TextInputType.text),
//                          ),
//                          SizedBox(
//                            height: 15,
//                          ),
//                          new Padding(
//                            padding: EdgeInsets.only(bottom: 0, top: 0),
//                            child: _inputState(
//                                "State", _state, true, TextInputType.text),
//                          ),
//                          SizedBox(
//                            height: 15,
//                          ),
//                          new Padding(
//                            padding: EdgeInsets.only(bottom: 0, top: 0),
//                            child: _inputCity(
//                                "City", _city, true, TextInputType.text),
//                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputZipcode("Postcode/Zip/Pin", _zipcode,
                                true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                      text:
                                          "By selecting ‘Sign up’ you are agreeing to our "),
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue),
                                    text: "Privacy Policy. ",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        launch(AppConstant.PRIVACY_POLICY_URL);
                                      },
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                    text: " Please send any queries to ",
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue),
                                    text: "helloqmanager@to-be-u.com ",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        launch(
                                            "mailto:helloqmanager@to-be-u.com");
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              child: _button(
                                  AppLocalizations.of(context)
                                      .translate('str_SignUp'),
                                  Colors.red,
                                  Colors.red,
                                  Colors.red,
                                  Colors.white,
                                  _btnSignupClicked),
                              height: 50,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isValid() {
    if (_firstName.text.isEmpty) {
      Utility.showToastMessage("Please enter first name");
      return false;
    }
    if (_lastName.text.isEmpty) {
      Utility.showToastMessage("Please enter last name");
      return false;
    }
    if (_mobile.text.isEmpty) {
      Utility.showToastMessage("Please enter your mobile number");
      return false;
    }
    if (_email.text.isEmpty) {
      Utility.showToastMessage("Please enter your email");
      return false;
    }
    if (!Utility().isValidEmail(_email.text)) {
      Utility.showToastMessage("Please enter valid email");
      return false;
    }

    if (_dob.text.isEmpty) {
      Utility.showToastMessage("Please enter date of birth");
      return false;
    }

    if (_gender.text.isEmpty) {
      Utility.showToastMessage("Please select your gender");
      return false;
    }

    if (_password.text.isEmpty) {
      Utility.showToastMessage("Please enter your password");
      return false;
    }
//    if (_streetAddress.text.isEmpty) {
//      Utility.showToastMessage("Please enter your address");
//      return false;
//    }
//    if (_country.text.isEmpty) {
//      Utility.showToastMessage("Please enter your country");
//      return false;
//    }
//    if (_state.text.isEmpty) {
//      Utility.showToastMessage("Please enter your state");
//      return false;
//    }
//    if (_city.text.isEmpty) {
//      Utility.showToastMessage("Please enter your city");
//      return false;
//    }

    if (_zipcode.text.isEmpty) {
      Utility.showToastMessage("Please enter your Postcode/Zip/Pin");
      return false;
    }
    return true;
  }

  void _btnSignupClicked() {
    FocusScope.of(context).unfocus();
    if (isValid()) {
      Utility.showLoader(context);
      signupAPI();
    }
  }

  void signupAPI() {
    Map<String, String> bodyParams = {
      "firstname": _firstName.text.toString(),
      "lastname": _lastName.text.toString(),
      "mobile": _mobile.text.toString(),
      "email": _email.text.toString(),
      "password": _password.text.toString(),
//      "street_address": _streetAddress.text.toString(),
//      "street_address_line_two": _streetAddress2.text.toString(),
//      "city_id": selCityId.toString(),
//      "state_id": selStateId.toString(),
//      "country_id": selCountryId.toString(),
      "pincode": _zipcode.text.toString(),
      "gender": _gender.text.toString(),
      "dob": _dob.text.toString(),
    };

    new APIManger().apiRequest(AppConstant.API_SIGN_UP, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      UserModel model = UserModel.fromJson(json);
      Utility().currentUser = model;
      SessionManager().setUserModel(model);
      Utility.showToastMessage(message);
      Navigator.of(context).pushNamed(CustomerHomeScreen.routeName);
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }

  void getCountryListAPI() {
    new APIManger().apiRequest(AppConstant.API_COUNTRY_LIST, null,
        (json, message) {
      countryList = createStateList(json);
      getStateListAPI();
    }, (message) {
      Utility.showToastMessage(message);
    });
  }

  void getStateListAPI() {
    Map<String, dynamic> bodyParams = {"country_id": selCountryId.toString()};

    new APIManger().apiRequest(AppConstant.API_STATE_LIST, bodyParams,
        (json, message) {
      stateList = createStateList(json);
    }, (message) {
      Utility.showToastMessage(message);
    });
  }

  void getCityListAPI() {
    Map<String, dynamic> bodyParams = {"state_id": selStateId.toString()};

    new APIManger().apiRequest(AppConstant.API_CITY_LIST, bodyParams,
        (json, message) {
      cityList = createStateList(json);
    }, (message) {
      Utility.showToastMessage(message);
    });
  }

  List<StateModel> createStateList(List data) {
    List<StateModel> list = new List();
    for (int i = 0; i < data.length; i++) {
      StateModel model = StateModel.fromJson(data[i]);
      list.add(model);
    }
    return list;
  }

  void showDropDownView(List<StateModel> arrData, bool isState) {
    Widget setupAlertDialoadContainer() {
      return Container(
        height: 400.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: arrData.length,
          itemBuilder: (BuildContext context, int index) {
            StateModel model = arrData[index];
            return ListTile(
              title: Text(model.name),
              onTap: () => {},
            );
          },
        ),
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isState ? 'State List' : 'City List'),
            content: setupAlertDialoadContainer(),
          );
        });
  }

  void performOnCountrySelection(StateModel model) {
    selCountryId = model.id;
    _country.text = model.name;
    _state.text = "";
    _city.text = "";
    selStateId = 0;
    selCityId = 0;
    getStateListAPI();
  }

  void performOnStateSelection(StateModel model) {
    selStateId = model.id;
    _state.text = model.name;
    _city.text = "";
    selCityId = 0;
    getCityListAPI();
  }

  void performOnCitySelection(StateModel model) {
    selCityId = model.id;
    _city.text = model.name;
  }
}
