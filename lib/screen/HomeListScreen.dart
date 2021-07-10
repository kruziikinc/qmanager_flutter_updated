import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/dialog/ZipCodeDialog.dart';
import 'package:qmanager_flutter_updated/model/OutletModel.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/screen/BookApointmentScreen.dart';
import 'package:qmanager_flutter_updated/screen/NotificationsScreen.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/SessionManager.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class HomeListScreen extends StatefulWidget {
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  TextEditingController _search = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String zipcode = "";
  int pageNo = 1;
  static const int recordCount = 10;
  bool showPaginationLoader = true;
  bool apiRunning = false;
  List<OutletModel> arrVendorList = [];
  ScrollController _scrollController;
  int notificationCount = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);

    Utility.isConnected().then((internet) {
      if (internet) {
        getVendorListAPI(true);
        SessionManager().getDeviceToken((resultString) {
          if (resultString != null) {
            updateDeviceTokenAPI(resultString);
            getNotificationCountAPI();
          }
        });
      } else {
        Utility.showToastMessage("Please Check network connection");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: <Widget>[
              Image(
                  image: new AssetImage("assets/images/bg_top_home.png"),
                  fit: BoxFit.fill),
            ],
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Column(children: [
                setupNavigation(),
                SizedBox(
                  height: 15,
                ),
                setupSearchView(),
                SizedBox(
                  height: 15,
                ),
                setupListView()
              ])),
        ],
      ),
    );
  }

  Widget setupNavigation() {
    return Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: AssetImage("assets/images/ic_logo_sign.png"),
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
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(NotificationsScreen.routeName);
                    }),
              ),
              Positioned(
                  right: 4,
                  top: 3,
                  child: Visibility(
                    visible: notificationCount > 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: AppColors.colorWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget setupSearchView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
          child: TextField(
            controller: _search,
            obscureText: false,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 16, color: AppColors.colorWhite),
            onChanged: (text) {
              Future.delayed(const Duration(milliseconds: 2000), () {
                refreshVendorList();
              });
            },
            decoration: InputDecoration(
              hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: AppColors.colorWhite),
              hintText: "Name, Services, Outlet ID",
              contentPadding: EdgeInsets.only(left: 15, right: 15),
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
                      _search.clear();
                      refreshVendorList();
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
            color: zipcode.length > 0 ? Colors.black54 : Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: AppColors.colorWhite)),
            child: Icon(Icons.location_on, color: AppColors.colorWhite),
            onPressed: () {
              showZipCodeDialog(this.zipcode);
            },
          ),
        ),
      ],
    );
  }

  Widget setupListView() {
    return Expanded(
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshVendorList,
          child: Stack(
            children: [
              if (arrVendorList.length == 0)
                Center(
                  child: noDataView("No vendors available"),
                ),
              ListView.builder(
                  itemCount: arrVendorList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        setupVendorItem(arrVendorList[index]),
                        Container(
                          color: Colors.transparent,
                          height: (index == arrVendorList.length - 1 &&
                                  arrVendorList.length >= recordCount &&
                                  showPaginationLoader)
                              ? 50
                              : 0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      ],
                    );
                  }),
            ],
          )),
    );
  }

  Widget setupVendorItem(OutletModel model) => GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookApointmentScreen(outletID: model.outletId)));
      },
      child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ]),
                          SizedBox(height: 5),
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
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Icon(
                                CustomIcons.location,
                                color: AppColors.textColor,
                                size: 14,
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(model.address ?? "",
                                    style: new TextStyle(
                                        fontSize: 12,
                                        color: AppColors.lightTextColor)),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
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
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor)),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(model.services ?? "",
                              style: new TextStyle(
                                  fontSize: 12,
                                  color: AppColors.lightTextColor)),
                        ]),
                  ),
                ]),
          )));

  Future<void> refreshVendorList() async {
    // getVendorListAPI(false);
    pageNo = 1;
    arrVendorList.clear();
    getVendorListAPI(false);
  }

  Widget noDataView(String msg) => Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );

  void getVendorListAPI(bool showLoader) async {
    Map<String, String> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "pincode": zipcode ?? "",
      "keyword": _search.text ?? "",
      "no_of_record": recordCount.toString(),
      "page": pageNo.toString()
    };

    if (showLoader) Utility.showLoader(context);

    final response =
        await http.post(Uri.parse(AppConstant.API_SHOP_LIST), body: bodyParams);
    if (showLoader) Utility.hideLoader(context);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body.toString());
      List responseJson = resBody["response"];
      showPaginationLoader = responseJson.length >= pageNo;
      arrVendorList.addAll(createOrderList(responseJson));
      apiRunning = false;
      setState(() {});
    } else {
      if (showLoader) Utility.hideLoader(context);
      // Utility.showToastMessage("Failed");
    }
  }

  List<OutletModel> createOrderList(List data) {
    List<OutletModel> list = [];
    for (int i = 0; i < data.length; i++) {
      OutletModel model = OutletModel.fromJson(data[i]);
      var existingItem = arrVendorList.firstWhere(
          (itemToCheck) => itemToCheck.outletId == model.outletId,
          orElse: () => null);
      if (existingItem == null) list.add(model);
    }
    return list;
  }

  void updateDeviceTokenAPI(String token) {
    Map<String, String> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "token": token,
      "device_type": Platform.isAndroid ? "ANDROID" : "IOS"
    };

    APIManger().apiRequest(AppConstant.API_UPDATE_DEVICE_TOKEN, bodyParams,
        (json, message) {
      // Utility.showToastMessage(message);
    }, (message) {
      // Utility.showToastMessage(message);
    });
  }

  void getNotificationCountAPI() {
    Map<String, String> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
    };

    APIManger().apiRequest(AppConstant.API_NOTIFICATION_COUNT, bodyParams,
        (json, message) {
      Map<String, dynamic> obj = json;
      notificationCount = obj['total_count'];
      setState(() {});
    }, (message) {});
  }

  void showZipCodeDialog(String zipCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ZipCodeDialog(
          zipcode: zipCode,
          callback: (zipCode) {
            arrVendorList.clear();
            this.zipcode = zipCode;
            Utility().currentUser.pincode = zipCode;
            refreshVendorList();
          }),
    );
  }

  _scrollListener() {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter <= 0 &&
        !apiRunning &&
        showPaginationLoader) {
      apiRunning = true;
      pageNo++;
      getVendorListAPI(false);
    }
  }
}
