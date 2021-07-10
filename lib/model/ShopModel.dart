class ShopModel {
  int outletId;
  String outletName;
  String vendorName;
  String address;
  int availableSlots;
  double rating;
  String services;
  String imgUrl;



  ShopModel(
      {this.outletId,
        this.outletName,
        this.vendorName,
        this.address,
        this.availableSlots,
        this.rating,
        this.services,
        this.imgUrl});

  ShopModel.fromJson(Map<String, dynamic> json) {
    outletId = json['outlet_id'];
    outletName = json['outlet_name'];
    vendorName = json['vendor_name'];
    address = json['address'];
    availableSlots = json['available_slots'];
    rating = json['rating'];
    services = json['services'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet_id'] = this.outletId;
    data['outlet_name'] = this.outletName;
    data['vendor_name'] = this.vendorName;
    data['address'] = this.address;
    data['available_slots'] = this.availableSlots;
    data['rating'] = this.rating;
    data['services'] = this.services;
    data['img_url'] = this.imgUrl;
    return data;
  }
}