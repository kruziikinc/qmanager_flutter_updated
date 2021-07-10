import 'package:qmanager_flutter_updated/model/AvailableSlotModel.dart';
import 'package:qmanager_flutter_updated/model/ShopTimingModel.dart';

class OutletDetailModel {
  int outletId;
  int vendorId;
  String outletName;
  String vendor;
  String outletImage;
  String outletOriginalImage;
  String vendorImage;
  String contact1;
  String contact2;
  String contact3;
  String address;
  String streetAddress;
  String streetAddressLineTwo;
  bool isOn;
  int maxAllowedBooking;
  int totalPrebookingDays;
  String services;
  String email;
  String websiteUrl;
  List<ShopTimingModel> shopTimings;
  List<AvailableSlotModel> availableSlots;

  OutletDetailModel(
      {this.outletId,
      this.vendorId,
      this.outletName,
      this.vendor,
      this.outletImage,
      this.outletOriginalImage,
      this.vendorImage,
      this.contact1,
      this.contact2,
      this.contact3,
      this.streetAddress,
      this.streetAddressLineTwo,
      this.isOn,
      this.maxAllowedBooking,
      this.totalPrebookingDays,
      this.services,
      this.email,
      this.shopTimings,
      this.availableSlots,
      this.websiteUrl});

  OutletDetailModel.fromJson(Map<String, dynamic> json) {
    outletId = json['outlet_id'];
    vendorId = json['vendor_id'];
    outletName = json['outlet_name'];
    vendor = json['vendor'];
    outletImage = json['outlet_image'];
    outletOriginalImage = json['outlet_original_image'];
    vendorImage = json['vendor_image'];
    contact1 = json['contact1'];
    contact2 = json['contact2'];
    contact3 = json['contact3'];
    address = json['address'];
    streetAddress = json['street_address'];
    streetAddressLineTwo = json['street_address_line_two'];
    isOn = json['is_on'];
    maxAllowedBooking = json['max_allowed_booking'];
    totalPrebookingDays = json['total_prebooking_days'];

    services = json['services'];
    email = json['email'] ?? "-";
    websiteUrl = json['website_url'];
    if (json['shop_timings_new'] != null) {
      shopTimings = <ShopTimingModel>[];
      json['shop_timings_new'].forEach((v) {
        shopTimings.add(new ShopTimingModel.fromJson(v));
      });
    }

    if (json['available_slots'] != null) {
      availableSlots = <AvailableSlotModel>[];
      json['available_slots'].forEach((v) {
        availableSlots.add(new AvailableSlotModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outlet_id'] = this.outletId;
    data['vendor_id'] = this.vendorId;
    data['outlet_name'] = this.outletName;
    data['vendor'] = this.vendor;
    data['outlet_image'] = this.outletImage;
    data['outlet_original_image'] = this.outletOriginalImage;
    data['vendor_image'] = this.vendorImage;
    data['contact1'] = this.contact1;
    data['contact2'] = this.contact2;
    data['contact3'] = this.contact3;
    data['address'] = this.address;
    data['street_address'] = this.streetAddress;
    data['street_address_line_two'] = this.streetAddressLineTwo;
    data['is_on'] = this.isOn;
    data['max_allowed_booking'] = this.maxAllowedBooking;
    data['total_prebooking_days'] = this.totalPrebookingDays;
    data['services'] = this.services;
    data['email'] = this.email;
    data['website_url'] = this.websiteUrl;
    if (this.availableSlots != null) {
      data['available_slots'] =
          this.availableSlots.map((v) => v.toJson()).toList();
    }

    if (this.shopTimings != null) {
      data['shop_timings_new'] =
          this.shopTimings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
