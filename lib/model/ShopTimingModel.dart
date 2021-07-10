class ShopTimingModel {
  String slotTime;
  String daysLabel;

  ShopTimingModel({this.slotTime, this.daysLabel});

  ShopTimingModel.fromJson(Map<String, dynamic> json) {
    slotTime = json['slot_time'];
    daysLabel = json['days_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_time'] = this.slotTime;
    data['days_label'] = this.daysLabel;
    return data;
  }
}