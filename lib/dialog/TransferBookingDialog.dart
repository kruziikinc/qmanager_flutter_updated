import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppLocalizations.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

typedef EmailCallBack = void Function(String email);

class TransferBookingDialog extends StatelessWidget {
  final TextEditingController _emailController = new TextEditingController();

  final EmailCallBack callback;

  TransferBookingDialog(this.callback);
  //input widget
  Widget _input(String hint, TextEditingController controller, bool obsecure,
      TextInputType type) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        keyboardType: type,
        style: TextStyle(fontSize: 16, color: AppColors.grayColor),
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: AppColors.grayColor),
          labelText: hint,
          contentPadding: EdgeInsets.only(left: 15, right: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: AppColors.grayColor,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(
              color: AppColors.grayColor,
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
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(text,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () {
        function();
      },
    );
  }

  bool isValid() {
    if (_emailController.text.isEmpty ||
        !Utility().isValidEmail(_emailController.text)) {
      Utility.showToastMessage("Please enter valid email address");
      return false;
    }
    return true;
  }

  dialogContent(BuildContext context) {
    void transferClick() {
      if (isValid()) {
        Navigator.of(context).pop();
        callback(_emailController.text);
      }
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text("Transfer the booking\nAppointment to other User",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayColor)),
              SizedBox(
                height: 20,
              ),
              _input("Enter Email", _emailController, false,
                  TextInputType.emailAddress),
              SizedBox(
                height: 30,
              ),
              Container(
                child: _button(
                    AppLocalizations.of(context).translate('str_transfer'),
                    Colors.red,
                    Colors.red,
                    Colors.red,
                    Colors.white,
                    transferClick),
                height: 40,
                width: 150,
              ),
            ],
          ),
        ),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              RaisedButton(
                highlightElevation: 0.0,
                elevation: 0.0,
                color: AppColors.colorWhite,
                shape: CircleBorder(),
                child: Icon(Icons.cancel, color: AppColors.textColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
