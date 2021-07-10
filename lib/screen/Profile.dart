import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qmanager_flutter_updated/model/StateModel.dart';
import 'package:qmanager_flutter_updated/model/UserModel.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/AppLocalizations.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class Profile extends StatefulWidget {
  static const routeName = 'profile-screen';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();

  TextEditingController _mobile = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _gender = new TextEditingController();
  TextEditingController _streetAddress = new TextEditingController();
  TextEditingController _streetAddress2 = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _country = new TextEditingController();
  TextEditingController _zipcode = new TextEditingController();
  DateTime selectedDate = DateTime.now();

  PickedFile _image;
  List countryList = [];
  List stateList = [];
  List cityList = [];
  int selCountryId;
  int selStateId;
  int selCityId;

  @override
  void initState() {
    getCountryListAPI();
    setupProfileData();
    super.initState();
  }

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
    Widget _inputFirstName(String hint, TextEditingController controller,
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

    Widget _inputLastName(String hint, TextEditingController controller,
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

    Widget _inputUniqueId(String hint, TextEditingController controller,
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
          readOnly: true,
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
          // readOnly: true,
//          onTap: () async {
//            if (_state.text.length == 0) {
//              Utility.showToastMessage("Please select state");
//              return;
//            }
//            if (cityList.length == 0) {
//              Utility.showToastMessage("No city found");
//              return;
//            }
//            Utility().showStateCityDropDown(context, cityList, "City List",
//                (model) {
//              performOnCitySelection(model);
//            });
//          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
//            suffixIcon: Icon(
//              Icons.keyboard_arrow_down,
//              size: 30,
//            ),
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
          //        readOnly: true,
//          onTap: () async {
//            if (_country.text.length == 0) {
//              Utility.showToastMessage("Please select country");
//              return;
//            }
//            if (stateList.length == 0) {
//              Utility.showToastMessage("No state found");
//              return;
//            }
//            Utility().showStateCityDropDown(context, stateList, "State List",
//                (model) {
//              performOnStateSelection(model);
//            });
//          },
          style: TextStyle(fontSize: 16, color: grayColor),
          decoration: InputDecoration(
            labelStyle: TextStyle(
                fontWeight: FontWeight.normal, fontSize: 16, color: grayColor),
            labelText: hint,
            contentPadding: EdgeInsets.only(left: 15, right: 15),
//            suffixIcon: Icon(
//              Icons.keyboard_arrow_down,
//              size: 30,
//            ),
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
                      padding: EdgeInsets.only(top: 20),

                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            width: 80,
                            height: 80,
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
                    new Padding(
                      padding: EdgeInsets.fromLTRB(50, 40, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
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
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      padding: EdgeInsets.only(top: 55),
                      child: Center(
                        child: Text(
                          "Profile",
                          style: new TextStyle(
                              fontSize: 18,
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
                            child: _inputFirstName("First Name", _firstName,
                                false, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputLastName("Last name", _lastName, false,
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
                            height: 30,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputCountry(
                                "Country", _country, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputStreetAdd("Street Address",
                                _streetAddress, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputStreetAdd2("Street Address Line 2",
                                _streetAddress2, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputState(
                                "State", _state, true, TextInputType.text),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          new Padding(
                            padding: EdgeInsets.only(bottom: 0, top: 0),
                            child: _inputCity(
                                "City", _city, true, TextInputType.text),
                          ),
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              child: _button(
                                  AppLocalizations.of(context)
                                      .translate('str_updateProfile'),
                                  Colors.red,
                                  Colors.red,
                                  Colors.red,
                                  Colors.white,
                                  _btnUpdateProfileClicked),
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

  void setupProfileData() {
    _firstName.text = Utility().currentUser.firstName ?? "";
    _lastName.text = Utility().currentUser.lastName ?? "";
    _mobile.text = Utility().currentUser.mobile ?? "";
    _email.text = Utility().currentUser.email ?? "";
    _dob.text = Utility().currentUser.dob ??
        ""; //Utility.convertDateFromString(Utility().currentUser.dob ?? "");
    _gender.text = Utility().currentUser.gender ?? "";
    _streetAddress.text = Utility().currentUser.streetAddrress ?? "";
    _streetAddress2.text = Utility().currentUser.streetAddressTwo ?? "";
    _country.text = Utility().currentUser.countryName ?? "";
    _state.text = Utility().currentUser.stateName ?? "";
    _city.text = Utility().currentUser.cityName ?? "";
    _zipcode.text = Utility().currentUser.pincode ?? "";

    selCountryId = Utility().currentUser.countryId;
    selStateId = Utility().currentUser.stateId;
    selCityId = Utility().currentUser.cityId;

    //  getStateListAPI();
    // getCityListAPI();
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
      Utility.showToastMessage("Please enter mobile number");
      return false;
    }
    if (_email.text.isEmpty) {
      Utility.showToastMessage("Please enter email");
      return false;
    }
    if (!Utility().isValidEmail(_email.text)) {
      Utility.showToastMessage("Please enter valid");
      return false;
    }

    if (_country.text.isEmpty) {
      Utility.showToastMessage("Please select your country");
      return false;
    }

    if (_streetAddress.text.isEmpty) {
      Utility.showToastMessage("Please enter your address");
      return false;
    }
//    if (_state.text.isEmpty) {
//      Utility.showToastMessage("Please enter your state");
//      return false;
//    }
    if (_city.text.isEmpty) {
      Utility.showToastMessage("Please enter your city");
      return false;
    }
    if (_zipcode.text.isEmpty) {
      Utility.showToastMessage("Please enter your Postcode/Zip/Pin");
      return false;
    }
    return true;
  }

  void _btnUpdateProfileClicked() {
    FocusScope.of(context).unfocus();
    if (isValid()) {
      updateProfileAPI();
    }
  }

  void updateProfileAPI() {
    Map<String, String> bodyParams = {
      "firstname": _firstName.text.toString(),
      "lastname": _lastName.text.toString(),
      "mobile": _mobile.text.toString(),
      "email": _email.text.toString(),
      "street_address": _streetAddress.text.toString(),
      "street_address_line_two": _streetAddress2.text.toString(),
//      "city_id": selCityId.toString(),
//      "state_id": selStateId.toString(),
      "city": _city.text.toString(),
      "state": _state.text.toString() ?? "",
      "country_id": selCountryId.toString(),
      "pincode": _zipcode.text.toString(),
      "dob": _dob.text.toString(),
      "id": Utility().currentUser.id.toString(),
      "gender": _gender.text.toString(),
    };

    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_UPDATE_PROFILE, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage("Profile updated successfully");
      UserModel model = UserModel.fromJson(json);
      Utility().currentUser = model;
      SessionManager().setUserModel(model);
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }

  void getCountryListAPI() {
    new APIManger().apiRequest(AppConstant.API_COUNTRY_LIST, null,
        (json, message) {
      countryList = createStateList(json);
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
    List<StateModel> list = [];
    for (int i = 0; i < data.length; i++) {
      StateModel model = StateModel.fromJson(data[i]);
      list.add(model);
    }
    return list;
  }

  void performOnCountrySelection(StateModel model) {
    selCountryId = model.id;
    _country.text = model.name;
    _state.text = "";
    _city.text = "";
    selStateId = 0;
    selCityId = 0;
    //getStateListAPI();
  }

  void performOnStateSelection(StateModel model) {
    selStateId = model.id;
    _state.text = model.name;
    _city.text = "";
    selCityId = 0;
    //getCityListAPI();
  }

  void performOnCitySelection(StateModel model) {
    selCityId = model.id;
    _city.text = model.name;
  }
}
