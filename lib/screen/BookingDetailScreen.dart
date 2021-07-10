import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/dialog/TransferBookingDialog.dart';
import 'package:qmanager_flutter_updated/model/BookingListModel.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

Future<BookingListModel> getBookingDetailAPI(String bookingID) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, String> bodyParams = {
    "booking_id": bookingID,
  };

  // make POST request
  final response = await http.post(Uri.parse(AppConstant.API_BOOKING_DETAIL),
      headers: headers, body: json.encode(bodyParams));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var resBody = json.decode(response.body.toString());
    BookingListModel model = BookingListModel.fromJson(resBody["response"]);
    return model;
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

// ignore: camel_case_types
typedef refreshCallback = void Function();

class BookingDetailScreen extends StatefulWidget {
  final refreshCallback callback;
  final bool fromUpcomming;
  final BookingListModel bookingModel;
  BookingDetailScreen(
      {@required this.bookingModel,
      @required this.callback,
      @required this.fromUpcomming});

  @override
  _BookingDetailScreen createState() => _BookingDetailScreen(
      bookingModel: bookingModel,
      callback: callback,
      fromUpcomming: fromUpcomming);
}

class _BookingDetailScreen extends State<BookingDetailScreen> {
  final bookingModel;
  final refreshCallback callback;
  final fromUpcomming;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  // bool _isLoading = false;

  _BookingDetailScreen(
      {@required this.bookingModel,
      @required this.callback,
      @required this.fromUpcomming});

  @override
  void initState() {
    // here first we are checking network connection
    Utility.isConnected().then((internet) {
      if (internet) {
        // set state while we fetch data from API
        setState(() {
          // calling API to show the data
          // you can also do it with any button click.
          getBookingDetailAPI(bookingModel.bookingId.toString());
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
      getBookingDetailAPI(bookingModel.bookingId.toString());
    });
  }

  Widget designDetailPage(BookingListModel model) => Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                60,
            child: SingleChildScrollView(child: designDetailData(model)),
          ),
          if (fromUpcomming)
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      color: AppColors.colorLightGray,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Visibility(
                            child: Expanded(
                                //flex: 1,
                                child: Center(
                              child: FlatButton(
                                onPressed: () => {performScan()},
                                color: Colors.transparent,
                                child: Visibility(
                                  child: Row(
                                    // Re
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // place with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(
                                        Icons.scanner,
                                        color: AppColors.textColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Scan",
                                          style: new TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textColor)),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ),
                          Visibility(
                            visible: true,
                            child: Expanded(
                                //flex: 1,
                                child: Center(
                              child: FlatButton(
                                onPressed: () => {performTransferBooking()},
                                color: Colors.transparent,
                                child: Visibility(
                                  child: Row(
                                    // Re
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // place with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(
                                        Icons.cached,
                                        color: AppColors.textColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Transfer",
                                          style: new TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textColor)),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                          ),
                          Expanded(
                              child: Center(
                            child: FlatButton(
                              onPressed: () => {performCancelBooking()},
                              color: Colors.transparent,
                              child: Row(
                                // Re
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // place with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(
                                    Icons.cancel,
                                    color: AppColors.textColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Cancel",
                                      style: new TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor)),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  )),
            ),
        ],
      );

  Widget designDetailData(BookingListModel model) => Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 220,
                  decoration: BoxDecoration(
                      color: const Color(0xff000000),
//            color: const Color(0xffffffff),
                      image: DecorationImage(
                        image: new NetworkImage(model.imgOriginalUrl ??
                            AppConstant.OUTLET_BANNER_PLACEHOLDER),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.red.withOpacity(0.5), BlendMode.dstATop),
                      )),
                  child: Stack(
                    //  fit: StackFit.expand,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30, left: 10),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: new AssetImage(
                                            "assets/images/ic_logo_sign.png"),
                                        fit: BoxFit.fill)),
                              ),
                            )
                          ],
                        ),
                      ),
                      /*Column(
                       // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(model.outletName,
                              style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.colorWhite)),
                          SizedBox(height: 10),
                        ],
                      ), */
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(model.outletName,
                                  style: new TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.colorWhite)),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
//                Text("Booking Details",
//                    style: new TextStyle(fontSize: 18, color: AppColors.textColor)
//                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      //Booking ID
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_box,
                            color: AppColors.textColor,
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Booking ID",
                                  style: new TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(model.bookingUniqueId ?? "",
                                  style: new TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textColor)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Booking Date & Time
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.textColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Booking Date & Time",
                                  style: new TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                  model.bookingDate +
                                      " | " +
                                      Utility.getFormattedTime(
                                          (model.bookingDate ?? "") +
                                              " " +
                                              (model.bookingTime ?? "")),
                                  style: new TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textColor)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      //Phone Number
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone_android,
                            color: AppColors.textColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Phone No",
                                  style: new TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  Text(model.contactNoOne,
                                      style: new TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textColor)),
                                  GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                    ),
                                    onTap: () {
                                      launch("tel://" + model.contactNoOne);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.mail,
                            color: AppColors.textColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Email",
                                  style: new TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(model.email,
                                        style: new TextStyle(
                                            fontSize: 16,
                                            color: AppColors.textColor)),
                                    onTap: () {
                                      launch("mailto:" + model.email);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      //Address
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: AppColors.textColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Address",
                                    style: new TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textColor)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  model.streetAddress +
                                      (model.streetAddressLineTwo != null
                                          ? (", " + model.streetAddressLineTwo)
                                          : "") +
                                      (model.pinCode != null
                                          ? (", " + model.pinCode)
                                          : ""),
                                  style: new TextStyle(
                                      fontSize: 16, color: AppColors.textColor),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      if (model.websiteUrl != null) websiteWidget(model),
                      Divider(
                        height: 0.5,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),

                      //Booking ID
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget websiteWidget(BookingListModel model) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 0, bottom: 20),
          child: Icon(
            Icons.web,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Website",
              style: new TextStyle(fontSize: 12, color: AppColors.textColor),
            ),
            SizedBox(height: 5),
            InkWell(
                child: new Text(model.websiteUrl ?? "-"),
                onTap: () => launch(model.websiteUrl ?? "")),
          ],
        ),
      ],
    );
  }

  // Progress indicator widget to show loading.
  Widget loadingView() => Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
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
      body: new Center(
        child: new FutureBuilder<BookingListModel>(
          future: getBookingDetailAPI(bookingModel.bookingId.toString()),
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
                      return RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _getData,
                        child: designDetailPage(snapshot.data),
                      );
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
      ),
    );
  }

  void performCancelBooking() {
    Utility.showAlertDialog(context, "Cancel Booking",
        "Are you sure that you want to cancel booking?", () {
      cancelBookingAPI();
    });
  }

  void performTransferBooking() {
    showTransferDialog();
  }

  showTransferDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TransferBookingDialog((email) {
        transferBookingAPI(email);
      }),
    );
  }

  void performScan() async {
    //Search SCANNER_LIBRARY_CHECK in project
    // for Android
    //String value = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);

    // for iOS
    String value = await scanner.scan();

    bookingVisitedAPI(value);
  }

  void cancelBookingAPI() {
    Map<String, String> bodyParams = {
      "booking_id": bookingModel.bookingId.toString(),
    };
    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_CANCEL_BOOKING, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      callback();
      Navigator.pop(context);
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }

  void transferBookingAPI(String email) {
    Map<String, String> bodyParams = {
      "booking_id": bookingModel.bookingId.toString(),
      "customer_id": Utility().currentUser.id.toString(),
      "email": email
    };
    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_TRANSFER_BOOKING, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage("Booking transfer successfully");
      callback();
      Navigator.pop(context);
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }

  void bookingVisitedAPI(String vendorId) {
    Map<String, String> bodyParams = {
      "booking_id": bookingModel.bookingId.toString(),
      "booking_unique_id": bookingModel.bookingUniqueId.toString(),
      "customer_id": Utility().currentUser.id.toString(),
      "outlet_unique_id": vendorId,
      "booking_date": bookingModel.bookingDate
    };
    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_BOOKING_VISITED, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }
}
