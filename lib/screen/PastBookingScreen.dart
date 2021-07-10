import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/model/BookingListModel.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

import 'BookingDetailScreen.dart';

Future<List<BookingListModel>> getBookingList() async {
  // set up POST request arguments
  // Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, String> bodyParams = {
    "customer_id": Utility().currentUser.id.toString()
  };

  // make POST request
  final response = await http.post(Uri.parse(AppConstant.API_PAST_BOOKING_LIST),
      body: bodyParams);

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
  List<BookingListModel> list = [];
  for (int i = 0; i < data.length; i++) {
    BookingListModel model = BookingListModel.fromJson(data[i]);
    list.add(model);
  }
  return list;
}

class PastBookingScreen extends StatefulWidget {
  @override
  _PastBookingScreenState createState() => _PastBookingScreenState();
}

class _PastBookingScreenState extends State<PastBookingScreen> {
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

  // Item Design
  Widget designItem(BookingListModel model) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingDetailScreen(
                      bookingModel: model,
                      fromUpcomming: false,
                      callback: () {},
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
                              image: new NetworkImage(model.imgUrl ?? "")))),
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
                          ]),
                          SizedBox(
                            height: 4,
                          ),
                          Text("Booking ID: " + model.bookingUniqueId,
                              style: new TextStyle(
                                  fontSize: 14, color: AppColors.textColor)),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                              Utility.convertDateFromString(
                                      model.bookingDate ?? "") +
                                  " | " +
                                  Utility.getFormattedTime(
                                      (model.bookingDate ?? "") +
                                          " " +
                                          (model.bookingTime ?? "")),
                              style: new TextStyle(
                                  fontSize: 14, color: AppColors.textColor)),
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
                                Icons.location_on,
                                color: AppColors.textColor,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(
                                    (model.streetAddress ?? "") +
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
                            ],
                          ),
                        ]),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          getStatusIcon(model.bookingStatus),
                          size: getStatusIconSize(model.bookingStatus ?? 0),
                          color: getStatusColor(model.bookingStatus ?? 0),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        getStatusText(model.bookingStatus ?? 0),
                        style: TextStyle(
                            color: getStatusColor(model.bookingStatus ?? 0),
                            fontSize: 12),
                      ),
                    ],
                  )
                ]),
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
                                return noDataView("No past bookings");
                              }
                            } else {
                              // display error message if your list or data is null.
                              return noDataView("No past bookings");
                            }
                          } else if (snapshot.hasError) {
                            // display your message if snapshot has error.
                            return noDataView("Something went wrong");
                          } else {
                            return noDataView("No past bookings");
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
    if (bookingStatus == 3) {
      return Colors.green;
    } else if (bookingStatus == 4 || bookingStatus == 1) {
      return Colors.orangeAccent;
    } else if (bookingStatus == 2) {
      return AppColors.colorRed;
    }
  }

  getStatusIcon(int bookingStatus) {
    if (bookingStatus == 3) {
      return CustomIcons.ic_visited;
    } else if (bookingStatus == 4 || bookingStatus == 1) {
      return CustomIcons.ic_no_show_01;
    } else if (bookingStatus == 2) {
      return CustomIcons.ic_cancelled;
    }
  }

  getStatusIconSize(int bookingStatus) {
    if (bookingStatus == 3) {
      return 30.0;
    } else if (bookingStatus == 4) {
      return 30.0;
    } else if (bookingStatus == 2) {
      return 30.0;
    }
  }

  getStatusText(int bookingStatus) {
    if (bookingStatus == 3) {
      return "Visited";
    } else if (bookingStatus == 4 || bookingStatus == 1) {
      return "No Show";
    } else if (bookingStatus == 2) {
      return "Cancelled";
    } else {
      return "";
    }
  }
}
