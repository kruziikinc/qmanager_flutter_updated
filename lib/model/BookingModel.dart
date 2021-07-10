class BookingModel {
  int outletId;
  String outletName;
  String bookingId;
  String date;
  String time;
  String shopContact;
  String shopAddress;
  int bookingStatus;
  String imgUrl;
  String imgOriginalUrl;

  BookingModel(
      {this.outletId,
      this.outletName,
      this.bookingId,
      this.date,
      this.time,
      this.shopContact,
      this.shopAddress,
      this.bookingStatus,
      this.imgUrl,
      this.imgOriginalUrl});

  BookingModel.fromJson(Map<String, dynamic> json) {
    outletId = json['outlet_id'];
    outletName = json['outlet_name'];
    bookingId = json['booking_id'];
    date = json['date'];
    time = json['time'];
    shopContact = json['shop_contact'];
    shopAddress = json['shop_address'];
    bookingStatus = json['booking_status'];
    imgUrl = json['img_url'];
    imgOriginalUrl = json['original_img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet_id'] = this.outletId;
    data['outlet_name'] = this.outletName;
    data['booking_id'] = this.bookingId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['shop_contact'] = this.shopContact;
    data['shop_address'] = this.shopAddress;
    data['booking_status'] = this.bookingStatus;
    data['img_url'] = this.imgUrl;
    data['original_img_url'] = this.imgOriginalUrl;

    return data;
  }
}
