class BookingListModel {
  int bookingId;
  int outletId;
  String bookingUniqueId;
  int bookingStatus;
  int delayStatus;
  String bookingDate;
  String bookingTime;
  int vendorId;
  int customerId;
  String outletName;
  String contactNoOne;
  String contactNoTwo;
  String contactNoThree;
  String streetAddress;
  String streetAddressLineTwo;
  String pinCode;
  String imgUrl;
  String imgOriginalUrl;
  String email;
  String websiteUrl;
  // ignore: non_constant_identifier_names
  String delay_status_message;

  BookingListModel(
      {this.bookingId,
      this.outletId,
      this.bookingUniqueId,
      this.bookingStatus,
      this.delayStatus,
      this.bookingDate,
      this.bookingTime,
      this.vendorId,
      this.customerId,
      this.outletName,
      this.contactNoOne,
      this.contactNoTwo,
      this.contactNoThree,
      this.streetAddress,
      this.streetAddressLineTwo,
      this.pinCode,
      this.imgUrl,
      this.imgOriginalUrl,
      this.email,
      this.websiteUrl,
      // ignore: non_constant_identifier_names
      this.delay_status_message});

  BookingListModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    outletId = json['outlet_id'];
    bookingUniqueId = json['booking_unique_id'] ?? "";
    bookingStatus = json['booking_status'];
    delayStatus = json['delay_status'];
    bookingDate = json['booking_date'];
    bookingTime = json['booking_time'];
    vendorId = json['vendor_id'];
    customerId = json['customer_id'];
    outletName = json['outlet_name'];
    contactNoOne = json['contact_no_one'];
    contactNoTwo = json['contact_no_two'];
    contactNoThree = json['contact_no_three'];
    streetAddress = json['street_address'];
    streetAddressLineTwo = json['street_address_line_two'];
    pinCode = json['pincode'];
    imgUrl = json['img_url'];
    imgOriginalUrl = json['original_img_url'];
    email = json['email'] ?? "-";
    websiteUrl = json['website_url'];
    delay_status_message = json['delay_status_message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['outlet_id'] = this.outletId;
    data['booking_unique_id'] = this.bookingUniqueId;
    data['booking_status'] = this.bookingStatus;
    data['delay_status'] = this.delayStatus;
    data['booking_date'] = this.bookingDate;
    data['booking_time'] = this.bookingTime;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['outlet_name'] = this.outletName;
    data['contact_no_one'] = this.contactNoOne;
    data['contact_no_two'] = this.contactNoTwo;
    data['contact_no_three'] = this.contactNoThree;
    data['street_address'] = this.streetAddress;
    data['street_address_line_two'] = this.streetAddressLineTwo;
    data['pincode'] = this.pinCode;
    data['img_url'] = this.imgUrl;
    data['original_img_url'] = this.imgOriginalUrl;
    data['email'] = this.email;
    data['website_url'] = this.websiteUrl;
    data['delay_status_message'] = this.delay_status_message;
    return data;
  }
}
