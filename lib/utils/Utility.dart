import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qmanager_flutter_updated/model/StateModel.dart';
import 'package:qmanager_flutter_updated/model/UserModel.dart';

typedef dropDownCallback = void Function(StateModel model);
typedef stringCallback = void Function(String value);

class Utility {
  UserModel currentUser;
  String currentAppVersionAsPerPlatform = "";
  static final Utility _singleton = Utility._internal();

  factory Utility() {
    return _singleton;
  }

  Utility._internal();
  static void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  static void showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(
                // Aligns the container to center
                child: Container(
              // A simplified version of dialog.
              width: 40.0,
              height: 40.0,
              color: Color.fromARGB(0, 0, 0, 0),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )));
  }

  static void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }

  // method defined to check internet connectivity
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static String convertDateFromString(String strDate) {
    if (strDate != null) {
      DateTime todayDate = DateTime.parse(strDate);
      print(todayDate);
      return formatDate(todayDate, [dd, '/', mm, '/', yyyy]);
    }
    return "";
  }

  static String getFormattedTime(String strDate) {
    if (strDate != null) {
      DateTime todayDate = DateTime.parse(strDate);
      print(todayDate);
      return formatDate(todayDate, [hh, ':', nn, ' ', am]);
    }
    return "";
  }

  void showStateCityDropDown(BuildContext context, List<StateModel> arrData,
      String title, dropDownCallback callback) {
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
              onTap: () =>
                  {Navigator.of(context).pop(), callback(arrData[index])},
            );
          },
        ),
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: setupAlertDialoadContainer(),
          );
        });
  }

  bool isValidEmail(String email) {
    bool emailValid = RegExp(
            r'^([\w-]|(?<!\.)\.)+[a-zA-Z0-9]@[a-zA-Z0-9]([a-zA-Z0-9\-]+)((\.([a-zA-Z]){2,9}){0,2})$')
        .hasMatch(email);
    return emailValid;
  }

  void showBottonSheetMenu(
      BuildContext context, List<String> data, stringCallback callback) async {
    Widget createListView(BuildContext context, List<String> values) {
      return Container(
          height: 120.0,
          //width: 300.0,
          child: new ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            itemCount: values.length,
            itemBuilder: (BuildContext context, int index) {
              return new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new CupertinoActionSheetAction(
                        child: new Text(
                          values[index],
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () =>
                            {callback(values[index]), Navigator.pop(context)}),
                  ]);
            },
          ));
    }

    List<String> values = await data;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[createListView(context, values)],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  void showDatePicker(BuildContext context, DateTime minimumDate,
      DateTime maxDate, stringCallback callback) {
    DateTime dateTime = DateTime.now();

    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minimumDate,
        maxTime: maxDate, onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      callback(DateFormat('yyyy-MM-dd').format(date));
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  double _kPickerSheetHeight = 300.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 10.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String message, Function onOKClick) {
    Widget okButton = FlatButton(
        child: Text("OK", style: TextStyle(fontSize: 18)),
        onPressed: () {
          Navigator.pop(context);
          onOKClick();
        });

    Widget noButton = FlatButton(
      child: Text("Cancel", style: TextStyle(fontSize: 18)),
      onPressed: () => {Navigator.pop(context)},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(
        message,
        style: TextStyle(fontSize: 20.0),
      ),
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
}
