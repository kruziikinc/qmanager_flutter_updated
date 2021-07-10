class OutletModel {
  int outletId;
  String outletUniqueId;
  String outletName;
  String vendorName;
  String address;
  String imgUrl;
  String thumbnailImgUrl;
  int availableSlots;
  bool isOn;
  String services;
  // double rating;
  int totalusersrating;

  OutletModel(
      {this.outletId,
      this.outletUniqueId,
      this.outletName,
      this.vendorName,
      this.address,
      this.imgUrl,
      this.thumbnailImgUrl,
      this.availableSlots,
      this.isOn,
      this.services,
      //this.rating,
      this.totalusersrating});

  OutletModel.fromJson(Map<String, dynamic> json) {
    outletId = json['outlet_id'];
    outletUniqueId = json['outlet_unique_id'];
    outletName = json['outlet_name'];
    vendorName = json['vendor_name'];
    address = json['address'];
    imgUrl = json['img_url'];
    thumbnailImgUrl = json['thumbnail_img_url'];
    availableSlots = json['available_slots'];
    isOn = json['is_on'];
    services = json['services'];
    //rating = json['rating'];
    totalusersrating = json['totalusersrating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet_id'] = this.outletId;
    data['outlet_unique_id'] = this.outletUniqueId;
    data['outlet_name'] = this.outletName;
    data['vendor_name'] = this.vendorName;
    data['address'] = this.address;
    data['img_url'] = this.imgUrl;
    data['thumbnail_img_url'] = this.thumbnailImgUrl;
    data['available_slots'] = this.availableSlots;
    data['is_on'] = this.isOn;
    data['services'] = this.services;
    //data['rating'] = this.rating;
    data['totalusersrating'] = this.totalusersrating;
    return data;
  }
}
