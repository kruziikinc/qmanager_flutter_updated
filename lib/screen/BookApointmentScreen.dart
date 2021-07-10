import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qmanager_flutter_updated/model/AvailableSlotModel.dart';
import 'package:qmanager_flutter_updated/model/OutletDetailModel.dart';
import 'package:qmanager_flutter_updated/presentation/custom_icons_icons.dart';
import 'package:qmanager_flutter_updated/utils/APIManager.dart';
import 'package:qmanager_flutter_updated/utils/AppColors.dart';
import 'package:qmanager_flutter_updated/utils/AppConstant.dart';
import 'package:qmanager_flutter_updated/utils/Utility.dart';
import 'package:url_launcher/url_launcher.dart';

class BookApointmentScreen extends StatefulWidget {
  final int outletID;

  BookApointmentScreen({
    @required this.outletID,
  });

  @override
  _BookApointmentScreenState createState() =>
      _BookApointmentScreenState(outletID: outletID);
}

class _BookApointmentScreenState extends State<BookApointmentScreen> {
  List data;
  int outletID;
  OutletDetailModel detailModel;
  String selTimeSlot;
  TextEditingController _txtTimeSlot = new TextEditingController();

  _BookApointmentScreenState({
    @required this.outletID,
  });

  @override
  void initState() {
    super.initState();
    selTimeSlot = getCurrentDate();
    this.getOutletDetailsAPI(selTimeSlot);
  }

  void getOutletDetailsAPI(String date) {
    selTimeSlot = "";

    Map<String, String> params = {
      "outlet_id": outletID.toString(),
      "booking_date": date
    };

    new APIManger().apiRequest(AppConstant.API_OUTLET_DETAIL, params,
        (json, message) {
      // Utility.showToastMessage(message);
      this.setState(() {
        detailModel = OutletDetailModel.fromJson(json);
      });
      _txtTimeSlot.text = date;
    }, (message) {
      Utility.showToastMessage(message);
    });
  }

  void addBookingAPI() {
    Map<String, String> bodyParams = {
      "outlet_id": detailModel.outletId.toString(),
      "booking_date": _txtTimeSlot.text,
      "booking_time": selTimeSlot,
      "booking_status": "1",
      "vendor_id": detailModel.vendorId.toString(),
      "customer_id": Utility().currentUser.id.toString()
    };

    Utility.showLoader(context);
    new APIManger().apiRequest(AppConstant.API_ADD_BOOKING, bodyParams,
        (json, message) {
      Utility.hideLoader(context);
      Utility.showToastMessage(message);
      Navigator.of(context).pop();
    }, (message) {
      Utility.showToastMessage(message);
      Utility.hideLoader(context);
    });
  }

  String getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    return formattedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (detailModel == null) {
      return new Scaffold(
          body: Center(
              // Aligns the container to center
              child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      )));
    } else {
      return new Scaffold(
        body: new SingleChildScrollView(
          child: designDetailPage(),
        ),
      );
    }
  }

  Widget designDetailPage() {
    return Column(
      children: <Widget>[
        topView(),
        Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: [
              mobileWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  color: Colors.black,
                  height: 0.5,
                ),
              ),
              openingTimeWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  color: Colors.black,
                  height: 0.5,
                ),
              ),
              addressWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  color: Colors.black,
                  height: 0.5,
                ),
              ),
              servicesWidget(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  color: Colors.black,
                  height: 0.5,
                ),
              ),
              emailWidget(),
              Divider(
                color: Colors.black,
                height: 1,
              ),
              if (detailModel.websiteUrl != null) websiteWidget(),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 20.0,
          color: AppColors.bgColor,
        ),
        timeSlotWidget(),
      ],
    );
  }

  Widget mobileWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Icon(
            Icons.phone_android,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "Contact Number",
              style: new TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  detailModel.contact1 ?? "",
                  style: new TextStyle(fontSize: 14, color: Colors.black),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      CustomIcons.phone,
                      color: Colors.green,
                      size: 20.0,
                    ),
                  ),
                  onTap: () {
                    launch("tel://" + detailModel.contact1);
                  },
                ),
                SizedBox(height: 5),
              ],
            ),
            SizedBox(height: 5),
            detailModel.contact2 != null
                ? Row(
                    children: [
                      Text(
                        detailModel.contact2 ?? "",
                        style: new TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            CustomIcons.phone,
                            color: Colors.green,
                            size: 20.0,
                          ),
                        ),
                        onTap: () {
                          launch("tel://" + detailModel.contact2);
                        },
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                : Container(),
            SizedBox(height: 5),
            detailModel.contact3 != null
                ? Row(
                    children: [
                      Text(
                        detailModel.contact3 ?? "",
                        style: new TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            CustomIcons.phone,
                            color: Colors.green,
                            size: 20.0,
                          ),
                        ),
                        onTap: () {
                          launch("tel://" + detailModel.contact3);
                        },
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                : Container(),
            SizedBox(height: 5),
          ],
        ),
      ],
    );
  }

  Widget openingTimeWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Icon(
            Icons.access_time,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Opening Timings",
              style: new TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 5),
            Column(children: getShopTimingsDetails()),
            SizedBox(height: 5),
            if (!detailModel.isOn)
              Text(
                detailModel.isOn ? "" : "Currently Closed",
                style: new TextStyle(fontSize: 13, color: Colors.red[700]),
              ),
            SizedBox(height: 5),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  List<Widget> getShopTimingsDetails() {
    List<Widget> arrList = <Widget>[];
    detailModel.shopTimings.forEach((model) {
      arrList.add(Column(
        children: [
          Row(
            children: [
              Text(
                model.slotTime ?? "",
                style: new TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: new Container(
                  child: _button(model.daysLabel ?? "", Colors.green,
                      Colors.white, Colors.green, Colors.white, 10.0, null),
                  height: 25,
                  width: 140,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          )
        ],
      ));
    });
    return arrList;
  }

  Widget addressWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Icon(
            CustomIcons.location,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address",
                style: new TextStyle(fontSize: 12, color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                detailModel.address ?? "",
                style: new TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget servicesWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Icon(
            Icons.local_laundry_service,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services",
              style: new TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              detailModel.services ?? "-",
              style: new TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget websiteWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
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
              style: new TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 5),
            InkWell(
                child: new Text(detailModel.websiteUrl ?? "-"),
                onTap: () => launch(detailModel.websiteUrl ?? "")),
          ],
        ),
      ],
    );
  }

  Widget emailWidget() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Icon(
            Icons.email,
            color: AppColors.textColor,
            size: 25.0,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: new TextStyle(fontSize: 12, color: Colors.black),
            ),
            SizedBox(height: 5),
            InkWell(
              child: new Text(detailModel.email ?? "-"),
              onTap: () => launch("mailto:" + detailModel.email),
            ),
          ],
        ),
      ],
    );
  }

  Widget timeSlotWidget() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Available Time Slots",
                  style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                )),
                child: GestureDetector(
                  onTap: () {
                    Utility().showDatePicker(
                        context,
                        DateTime.now(),
                        DateTime.now().add(new Duration(
                            days: detailModel.totalPrebookingDays)), (value) {
                      _txtTimeSlot.text = value;
                      getOutletDetailsAPI(value);
                    });
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _txtTimeSlot,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: AppColors.textColor, width: 0.3),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ),
              (detailModel.isOn || detailModel.availableSlots.length > 0)
                  ? Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Select Time",
                                style: TextStyle(
                                    color: AppColors.textColor, fontSize: 14),
                              ),
                            )),
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 2.4,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                              detailModel.availableSlots.length, (index) {
                            return GestureDetector(
                              child: timeSlotGridTile(index),
                              onTap: () {
                                setState(() {
                                  AvailableSlotModel model =
                                      detailModel.availableSlots[index];
                                  if (model.isAvailable) {
                                    selTimeSlot = model.slotTime;
                                  }
                                });
                              },
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            width: 150,
                            height: 45,
                            child: _button("Book Now", Colors.red, Colors.white,
                                Colors.red, Colors.white, 16.0, btnBookClicked),
                          ),
                        ),
                      ],
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "No Slot(s) Available",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  void btnBookClicked() {
    if (selTimeSlot == "") {
      Utility.showToastMessage("Please select time slot");
      return;
    }
    addBookingAPI();
  }

  Widget timeSlotGridTile(int index) {
    AvailableSlotModel model = detailModel.availableSlots[index];
    return Container(
      decoration: BoxDecoration(
          color: model.isAvailable == true
              ? (selTimeSlot == model.slotTime ? Colors.green : Colors.white)
              : Colors.grey[500],
          border: Border.all(
            color: Colors.grey,
          )),
      alignment: Alignment.center,
      child: Text(model.slotTime,
          style: TextStyle(
              fontSize: 14,
              color: model.isAvailable == true
                  ? (selTimeSlot == model.slotTime
                      ? Colors.white
                      : AppColors.textColor)
                  : AppColors.colorWhite)),
    );
  }

  Widget topView() {
    return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
            color: const Color(0xff000000),
//            color: const Color(0xffffffff),
            image: DecorationImage(
              image: new NetworkImage(detailModel.outletOriginalImage ??
                  AppConstant.OUTLET_BANNER_PLACEHOLDER),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.red.withOpacity(0.5), BlendMode.dstATop),
            )),
        child: Stack(children: <Widget>[
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
          Positioned.fill(
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: Row(children: <Widget>[
                      new Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: new BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: (detailModel.vendorImage != null &&
                                      detailModel.vendorImage != "")
                                  ? new NetworkImage(detailModel.vendorImage)
                                  : new NetworkImage(
                                      AppConstant.VENDOR_THUMB_PLACEHOLDER)),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        (detailModel.outletName + "\n" + detailModel.vendor),
                        style: new TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ]))),
          )
        ]));
  }

  //button widget
  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, double fontSize, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      splashColor: splashColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(text,
          style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.normal)),
      onPressed: () {
        function();
      },
    );
  }
}
