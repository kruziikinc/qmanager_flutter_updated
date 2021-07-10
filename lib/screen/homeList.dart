import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/dialog/ZipCodeDialog.dart';
import 'package:qmanager_flutter_updated/model/OutletModel.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

import 'BookApointmentScreen.dart';

TextEditingController _search = new TextEditingController();

//test
Future<List<OutletModel>> getShopList(String zipcode) async {
  // set up POST request arguments
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, String> bodyParams;

  bodyParams = {
    "user_id": Utility().currentUser.id.toString(),
    "pincode": zipcode ?? "",
    "keyword": _search.text ?? "",
    "no_of_record": "1000"
  };

  // make POST request
  final response =
      await http.post(Uri.parse(AppConstant.API_SHOP_LIST), body: bodyParams);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var resBody = json.decode(response.body.toString());
    List responseJson = resBody["response"];
    List<OutletModel> jsonList = createOrderList(responseJson);
    return jsonList;
    /* if (resBody["status"]) {
      List responseJson = resBody["response"];
      List<ShopModel> jsonList = createOrderList(responseJson);
      return jsonList;
    } else {
      Utility.showToastMessage(resBody["message"]);
    }*/

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

List<OutletModel> createOrderList(List data) {
  List<OutletModel> list = new List();
  for (int i = 0; i < data.length; i++) {
    OutletModel model = OutletModel.fromJson(data[i]);
    list.add(model);
  }
  return list;
}

class HomeList extends StatefulWidget {
  @override
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int notificationCounter = 0;
  String zipcode = "";

  @override
  void initState() {
    // here first we are checking network connection
    Utility.isConnected().then((internet) {
      if (internet) {
        // set state while we fetch data from API
        setState(() {
          // calling API to show the data
          // you can also do it with any button click.

          SessionManager().getDeviceToken((resultString) {
            if (resultString != null) {
              updateDeviceTokenAPI(resultString);
            }
          });
        });
      } else {
        /*Display dialog with no internet connection message*/
        Utility.showToastMessage("Please Check network connection");
      }
    });
    super.initState();
  }

  Future<void> _getData() async {
    setState(() {
      getShopList(zipcode);
    });
  }

  // Item Design
  Widget designItem(OutletModel model) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookApointmentScreen(outletID: model.outletId)),
          );
        },
        child: new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: AppColors.colorWhite,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage(model.thumbnailImgUrl ??
                                  AppConstant.OUTLET_THUMB_PLACEHOLDER)))),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                              child: Text(model.outletName ?? "",
                                  style: new TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                            Visibility(
                              visible: false,
                              child: Container(
                                decoration: new BoxDecoration(
                                    color: Colors.green,
                                    //new Color.fromRGBO(255, 0, 0, 0.0),
                                    borderRadius: BorderRadius.circular(3.0)),
                                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                        model.totalusersrating
                                            .toString(), //model.rating.toString(),
                                        style: new TextStyle(
                                            fontSize: 12,
                                            color: AppColors.colorWhite)),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Icon(Icons.star,
                                        size: 15, color: AppColors.colorWhite),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 4,
                          ),
                          Text(model.vendorName ?? "",
                              style: new TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightTextColor)),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Outlet ID: " + (model.outletUniqueId ?? ""),
                              style: new TextStyle(
                                  fontSize: 14,
                                  color: AppColors.lightTextColor,
                                  fontWeight: FontWeight.normal)),

                          /* Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: AppColors.textColor,
                                size: 14,
                              ),

                              Text("-",
                                  style: new TextStyle(
                                      fontSize: 12,
                                      color: AppColors.lightTextColor)),


                            ],
                          ), */
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.location,
                                color: AppColors.textColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(model.address ?? "",
                                    style: new TextStyle(
                                        fontSize: 12,
                                        color: AppColors.lightTextColor)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Visibility(
                            visible: true,
                            child: Row(
                              children: <Widget>[
                                Text(
                                    model.availableSlots > 0
                                        ? model.availableSlots.toString() +
                                            " Slot(s)"
                                        : "No" + " Slot(s)",
                                    style: new TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.bold)),
                                Text(" Available Today",
                                    style: new TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(model.services ?? "",
                              style: new TextStyle(
                                  fontSize: 12,
                                  color: AppColors.lightTextColor)),
                        ]),
                  ),
                ]),
          ),
        ),
      );

  // Progress indicator widget to show loading.
  Widget loadingView() => Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      );

  // View to empty data message
  Widget noDataView(String msg) => Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image(
                      image: new AssetImage("assets/images/bg_top_home.png"),
                      fit: BoxFit.fill),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: new Center(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: new AssetImage(
                                    "assets/images/ic_logo_sign.png"),
                                fit: BoxFit.fill)),
                      ),

                      Spacer(),

                      Text("Home",
                          style: new TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorWhite)),

                      Spacer(),

                      // Using Stack to show Notification Badge
                      Visibility(
                        visible: true,
                        child: new Stack(
                          children: <Widget>[
                            Visibility(
                              visible: true,
                              child: new IconButton(
                                  icon: Icon(Icons.notifications),
                                  color: AppColors.colorWhite,
                                  iconSize: 0,
                                  onPressed: () {
                                    /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShoppingCartScreen()),
                                  );*/
                                  }),
                            ),
                            notificationCounter != 0
                                ? new Positioned(
                                    right: 6,
                                    top: 6,
                                    child: new Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: new BoxDecoration(
                                        color: AppColors.colorWhite,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        '$notificationCounter',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : new Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: TextField(
                          controller: _search,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 16, color: AppColors.colorWhite),
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: AppColors.colorWhite),
                            hintText: "Name, Services, Outlet ID",
                            contentPadding:
                                EdgeInsets.only(left: 15, right: 15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.colorWhite,
                                width: 1,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.colorWhite,
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.colorWhite,
                                  size: 18,
                                ),
                                onPressed: () {
                                  if (_search.text.isNotEmpty) {
                                    setState(() {
                                      _search.clear();
                                    });
                                  }
                                }),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.colorWhite,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.colorWhite,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        child: RaisedButton(
                          highlightElevation: 0.0,
                          elevation: 0.0,
                          padding: EdgeInsets.only(right: 1),
                          color: zipcode.length > 0
                              ? Colors.black54
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: AppColors.colorWhite)),
                          child: Icon(Icons.location_on,
                              color: AppColors.colorWhite),
                          onPressed: () {
                            showZipCodeDialog(this.zipcode);
                            /*setState(() {
                              notificationCounter++;
                            });*/
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (zipcode.length > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 250,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: AppColors.colorWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Text("Postcode/Zip/Pin: " + zipcode ?? "",
                              style: new TextStyle(
                                  fontSize: 16, color: AppColors.textColor)),
                        ),
                      ],
                    ),
                  Expanded(
                    child: new FutureBuilder<List<OutletModel>>(
                      future: getShopList(zipcode),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            {
                              // here we are showing loading view in waiting state.
                              return loadingView();
                            }
                          case ConnectionState.active:
                            {
                              break;
                            }
                          case ConnectionState.done:
                            {
                              // in done state we will handle the snapshot data.
                              // if snapshot has data show list else set you message.
                              if (snapshot.hasData) {
                                // hasdata same as data!=null
                                if (snapshot.data != null) {
                                  if (snapshot.data.length > 0) {
                                    // here inflate data list
                                    return RefreshIndicator(
                                      key: _refreshIndicatorKey,
                                      onRefresh: _getData,
                                      child: new ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return designItem(
                                                snapshot.data[index]);
                                          }),
                                    );
                                  } else {
                                    // display message for empty data message.
                                    return noDataView("No data found");
                                  }
                                } else {
                                  // display error message if your list or data is null.
                                  return noDataView("No data found");
                                }
                              } else if (snapshot.hasError) {
                                // display your message if snapshot has error.
                                return noDataView("Something went wrong");
                              } else {
                                return noDataView("Something went wrong");
                              }
                              break;
                            }
                          case ConnectionState.none:
                            {
                              break;
                            }
                        }

                        // By default, show a loading spinner
                        return new CircularProgressIndicator();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showZipCodeDialog(String zipCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ZipCodeDialog(
          zipcode: zipCode,
          callback: (zipCode) {
            this.zipcode = zipCode;
            Utility().currentUser.pincode = zipCode;
            setState(() {
              getShopList(zipCode);
            });
          }),
    );
  }

  void updateDeviceTokenAPI(String token) {
    Map<String, String> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "token": token,
      "device_type": Platform.isAndroid ? "ANDROID" : "IOS"
    };

    APIManger().apiRequest(AppConstant.API_UPDATE_DEVICE_TOKEN, bodyParams,
        (json, message) {
      Utility.showToastMessage(message);
    }, (message) {
      Utility.showToastMessage(message);
    });
  }
}
