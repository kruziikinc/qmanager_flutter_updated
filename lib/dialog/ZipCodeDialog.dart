import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppLocalizations.dart';

typedef ZipCallback = void Function(String zipcode);

class ZipCodeDialog extends StatelessWidget {
  final String zipcode;
  final ZipCallback callback;
  final TextEditingController _zipcodeController = new TextEditingController();

  ZipCodeDialog({@required this.zipcode, this.callback});

  //input widget
  Widget _input(String hint, TextEditingController controller, bool obsecure,
      TextInputType type) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        keyboardType: type,
        maxLength: 10,
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
//    if (_zipcodeController.text.isEmpty) {
//      Utility.showToastMessage("Please enter postcode");
//      return false;
//    }
    return true;
  }

  dialogContent(BuildContext context) {
    _submitClick() {
      if (isValid()) {
        Navigator.pop(context);
        callback(_zipcodeController.text);
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
              Row(
                children: <Widget>[
                  Text("Search Postcode",
                      style: new TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grayColor)),
                  Spacer(),
                  FlatButton(
                    onPressed: () => {_zipcodeController.text = ""},
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: AppColors.textColor,
                          size: 16,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("Clear",
                            style: new TextStyle(
                                fontSize: 14, color: AppColors.textColor)),
                      ],
                    ),
                  ),
                ],
              ),
              _input("Enter Postcode/Zip/Pin", _zipcodeController, false,
                  TextInputType.text),
              SizedBox(
                height: 20,
              ),
              Container(
                child: _button(
                    AppLocalizations.of(context).translate('str_submit'),
                    Colors.red,
                    Colors.red,
                    Colors.red,
                    Colors.white,
                    _submitClick),
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
    _zipcodeController.text = this.zipcode;
    return Dialog(
      elevation: 5.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
