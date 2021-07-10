import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/screen/PastBookingScreen.dart';
import 'package:qmanager_flutter_updated/screen/UpComingBookingScreen.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  int notificationCounter = 0;

  @override
  void initState() {
    super.initState();
  }

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

                      Text("My Bookings",
                          style: new TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorWhite)),

                      Spacer(),

                      // Using Stack to show Notification Badge
                      new Stack(
                        children: <Widget>[
                          new IconButton(
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
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(text: "Upcoming"),
                                  Tab(text: "Past")
                                ],
                                indicatorColor: AppColors.colorWhite,
                              ),
                              Expanded(
                                child: Container(
                                    child: TabBarView(
                                  children: [
                                    UpComingBookingScreen(),
                                    PastBookingScreen(),
                                  ],
                                )),
                              )
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
