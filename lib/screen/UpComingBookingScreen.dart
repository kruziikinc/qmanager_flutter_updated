import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/dialog/TransferBookingDialog.dart';
import 'package:qmanager_flutter_updated/model/BookingListModel.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'BookingDetailScreen.dart';

Future<List<BookingListModel>> getBookingList() async {
  // set up POST request arguments
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, String> bodyParams = {
    "customer_id": Utility().currentUser.id.toString()
  };

  // make POST request
  final response = await http
      .post(Uri.parse(AppConstant.API_UPCOMING_BOOKING_LIST), body: bodyParams);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var resBody = json.decode(response.body.toString());
    List responseJson = resBody["response"];
    List<BookingListModel> jsonList = createBookingList(responseJson);
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

List<BookingListModel> createBookingList(List data) {
  List<BookingListModel> list = new List();
  for (int i = 0; i < data.length; i++) {
    BookingListModel model = BookingListModel.fromJson(data[i]);
    list.add(model);
  }
  return list;
}

class UpComingBookingScreen extends StatefulWidget {
  @override
  _UpComingBookingScreenState createState() => _UpComingBookingScreenState();
}

class _UpComingBookingScreenState extends State<UpComingBookingScreen> {
  @override
  void initState() {
    // here first we are checking network connection
    Utility.isConnected().then((internet) {
      if (internet) {
        // set state while we fetch data from API
        setState(() {
          // calling API to show the data
          // you can also do it with any button click.
          getBookingList();
        });
      } else {
        /*Display dialog with no internet connection message*/
        Utility.showToastMessage("Please Check network connection");
      }
    });
    super.initState();
  }

  void refreshList() {
    setState(() {});
  }

  // Item Design
  Widget designItem(BookingListModel model) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingDetailScreen(
                      bookingModel: model,
                      callback: () => refreshList(),
                      fromUpcomming: true,
                    )),
          );
        },
        child: new Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: AppColors.colorWhite,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: <Widget>[
                new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      new Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      new NetworkImage(model.imgUrl ?? "")))),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(model.outletName ?? "",
                                  style: new TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                  "Booking ID : " + model.bookingUniqueId ?? "",
                                  style: new TextStyle(
                                      fontSize: 14,
                                      color: AppColors.lightTextColor)),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                  Utility.convertDateFromString(
                                          model.bookingDate) +
                                      " | " +
                                      Utility.getFormattedTime(
                                          model.bookingDate +
                                              " " +
                                              model.bookingTime),
                                  style: new TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor)),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: AppColors.textColor,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(model.contactNoOne ?? "",
                                      style: new TextStyle(
                                          fontSize: 12,
                                          color: AppColors.lightTextColor)),
                                ],
                              ),
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
                                    child: Text(
                                        model.streetAddress +
                                            (model.streetAddressLineTwo != null
                                                ? (", " +
                                                    model.streetAddressLineTwo)
                                                : "") +
                                            (model.pinCode != null
                                                ? (", " + model.pinCode)
                                                : ""),
                                        style: new TextStyle(
                                            fontSize: 12,
                                            color: AppColors.lightTextColor)),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                              SizedBox(height: 5),
                            ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ]),
                SizedBox(
                  height: 5,
                ),
                if (model.delayStatus != 0)
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(model.delay_status_message,
                        style: new TextStyle(
                            fontSize: 14, color: AppColors.lightTextColor)),
                  ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Visibility(
                        child: Expanded(
                            flex: 1,
                            child: Center(
                              child: FlatButton(
                                onPressed: () => {performScan(model)},
                                color: Colors.transparent,
                                child: Row(
                                  // Re
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // place with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Icon(
                                      Icons.scanner,
                                      color: AppColors.textColor,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("Scan", //Scan
                                        style: new TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textColor)),
                                  ],
                                ),
                              ),
                            )),
                        visible: true,
                      ),
                      Visibility(
                        visible: true,
                        child: Expanded(
                            flex: 1,
                            child: Center(
                              child: FlatButton(
                                onPressed: () => {
                                  // showTransferDialog()
                                  performTransferBooking(model.bookingId)
                                },
                                color: Colors.transparent,
                                child: Visibility(
                                  visible: true,
                                  child: Row(
                                    // Re
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // place with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(
                                        Icons.cached,
                                        color: AppColors.textColor,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text("Transfer",
                                          style: new TextStyle(
                                              fontSize: 12,
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
                            flex: 1,
                            child: Center(
                              child: FlatButton(
                                onPressed: () =>
                                    {performCancelBooking(model.bookingId)},
                                color: Colors.transparent,
                                child: Visibility(
                                  visible: true,
                                  child: Row(
                                    // Re
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // place with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(
                                        Icons.cancel,
                                        color: AppColors.textColor,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text("Cancel",
                                          style: new TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textColor)),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

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
      backgroundColor: Colors.transparent,
      body: Container(
        child: new Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: new FutureBuilder<List<BookingListModel>>(
                  future: getBookingList(),
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
                                return new ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return designItem(snapshot.data[index]);
                                    });
                              } else {
                                // display message for empty data message.
                                return noDataView("No Bookings available");
                              }
                            } else {
                              // display error message if your list or data is null.
                              return noDataView("No Bookings available");
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
    );
  }

  getStatusColor(int bookingStatus) {
    if (bookingStatus == 1) {
      return Colors.green;
    } else if (bookingStatus == 2) {
      return Colors.orange;
    } else {
      return AppColors.colorRed;
    }
  }

  void performCancelBooking(int bookingId) {
    Utility.showAlertDialog(context, "Cancel Booking",
        "Are you sure that you want to cancel booking?", () {
      cancelBookingAPI(bookingId);
    });
  }

  void cancelBookingAPI(int bookingId) {
    Map<String, String> bodyParams = {
      "booking_id": bookingId.toString(),
    };
    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_CANCEL_BOOKING, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
      setState(() {});
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }

  void performTransferBooking(int bookingId) {
    showTransferDialog(bookingId);
  }

  showTransferDialog(int bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => TransferBookingDialog((email) {
        transferBookingAPI(email, bookingId);
      }),
    );
  }

  void performScan(BookingListModel model) async {
    //Search SCANNER_LIBRARY_CHECK in project
    // for Android
    // String value = await FlutterBarcodeScanner.scanBarcode("#FFfc0303", "Cancel", true, ScanMode.DEFAULT);

    // for iOS
    String value = await scanner.scan();

    bookingVisitedAPI(model, value);
  }

  void transferBookingAPI(String email, int bookingID) {
    Map<String, String> bodyParams = {
      "booking_id": bookingID.toString(),
      "customer_id": Utility().currentUser.id.toString(),
      "email": email
    };
    Utility.showLoader(context);
    APIManger().apiRequest(AppConstant.API_TRANSFER_BOOKING, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage("Booking transfer successfully");
      setState(() {});
    }, (message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
    });
  }

  void bookingVisitedAPI(BookingListModel bookingModel, String outletId) {
    Map<String, String> bodyParams = {
      "booking_id": bookingModel.bookingId.toString(),
      "booking_unique_id": bookingModel.bookingUniqueId.toString(),
      "customer_id": Utility().currentUser.id.toString(),
      "outlet_unique_id": outletId,
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
