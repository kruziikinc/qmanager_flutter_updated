import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qmanager_flutter_updated/model/NotificationModel.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = 'Notification_Screen';

  // TODO: implement createState
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<dynamic> arrNotifications = [];
  bool showPaginationLoader = true;
  ScrollController _scrollController;
  int pageNo = 1;
  bool apiRunning = false;
  static const int recordCount = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    Future.delayed(Duration.zero, () {
      getNotificationListAPI(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.bgColor,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [setupListView()],
        ),
      ),
    );
  }

  Widget setupListView() {
    return Expanded(
      child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refreshNotificationList,
          child: Stack(
            children: [
              if (arrNotifications.length == 0)
                Center(
                  child: noDataView("No notifications available"),
                ),
              ListView.builder(
                  itemCount: arrNotifications.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        setupNotificationItem(arrNotifications[index]),
                        Container(
                          color: Colors.transparent,
                          height: (index == arrNotifications.length - 1 &&
                                  arrNotifications.length >= recordCount &&
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

  Widget setupNotificationItem(NotificationModel model) => GestureDetector(
      onTap: () {
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => BookApointmentScreen(outletID: model.outletId)));
      },
      child: Card(
          color: model.isRead == 1 ? AppColors.colorLightGray : Colors.white,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                              child: Text(model.message,
                                  style: new TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ]),
                          SizedBox(height: 10),
                          Row(children: [
                            Spacer(),
                            Text(convertDateFromString(model.createdAt),
                                textAlign: TextAlign.right,
                                style: new TextStyle(
                                    fontSize: 14,
                                    color: AppColors.lightTextColor)),
                          ])
                        ]),
                  ),
                ]),
          )));

  Widget noDataView(String msg) => Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );

  Future<void> refreshNotificationList() async {
    pageNo = 1;
    arrNotifications.clear();
    getNotificationListAPI(false);
  }

  void getNotificationListAPI(bool showLoader) async {
    Map<String, String> bodyParams = {
      "user_id": Utility().currentUser.id.toString(),
      "no_of_record": recordCount.toString(),
      "page": pageNo.toString()
    };

    if (showLoader) Utility.showLoader(context);

    final response = await http
        .post(Uri.parse(AppConstant.API_NOTIFICATION_LIST), body: bodyParams);
    if (showLoader) Utility.hideLoader(context);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body.toString());
      List responseJson = resBody["response"];
      showPaginationLoader = responseJson.length >= pageNo;
      arrNotifications.addAll(createNotificationList(responseJson));
      apiRunning = false;
      setState(() {});
    } else {
      if (showLoader) Utility.hideLoader(context);
      // Utility.showToastMessage("Failed");
    }
  }

  List<NotificationModel> createNotificationList(List data) {
    List<NotificationModel> list = [];
    for (int i = 0; i < data.length; i++) {
      NotificationModel model = NotificationModel.fromJSON(data[i]);
      var existingItem = arrNotifications.firstWhere(
          (itemToCheck) => itemToCheck.notificationId == model.notificationId,
          orElse: () => null);
      if (existingItem == null) list.add(model);
    }
    return list;
  }

  _scrollListener() {
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter <= 0 &&
        !apiRunning &&
        showPaginationLoader) {
      apiRunning = true;
      pageNo++;
      getNotificationListAPI(false);
    }
  }

  static String convertDateFromString(String strDate) {
    if (strDate != null) {
      DateTime todayDate = DateTime.parse(strDate);
      print(todayDate);
      return formatDate(
          todayDate, [dd, '/', mm, '/', yyyy, ' ', hh, ':', mm, ' ', am]);
    }
    return "";
  }
}
