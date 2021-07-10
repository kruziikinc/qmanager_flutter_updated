class AvailableSlotModel {
  String slotTime;
  int totalBooked;
  int availableTotalSlot;
  bool isAvailable;
  bool isSelected = false;

  AvailableSlotModel({this.slotTime, this.totalBooked, this.availableTotalSlot ,this.isAvailable , this.isSelected});

  AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    slotTime = json['slot_time'];
    totalBooked = json['total_booked'];
    availableTotalSlot = json['available_total_slot'];
    isAvailable = json['is_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_time'] = this.slotTime;
    data['total_booked'] = this.totalBooked;
    data['available_total_slot'] = this.availableTotalSlot;
    data['is_available'] = this.isAvailable;
    return data;
  }
}