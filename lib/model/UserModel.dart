class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String gender;
  final String streetAddrress;
  final String streetAddressTwo;
  final int countryId;
  final String countryName;
  final int stateId;
  final String stateName;
  final int cityId;
  final String cityName;
  final String token;
  String pincode;
  final String dob;
  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.gender,
      this.streetAddrress,
      this.streetAddressTwo,
        this.countryId,
        this.countryName,
      this.stateId,
      this.stateName,
      this.cityId,
      this.cityName,
      this.token,
      this.pincode,
      this.dob});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        email: json['email'],
        mobile: json['mobile'],
        gender: json['gender'],
        streetAddrress: json['street_address'],
        streetAddressTwo: json['street_address_line_two'],
        countryId: json['country_id'],
        countryName: json['country_name'],
        stateId: json['state_id'],
        stateName: json['state_name'],
        cityId: json['city_id'],
        cityName: json['city_name'],
        token: json['token'],
        pincode: json['pincode'],
        dob: json['dob']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['id'] = this.id;
    json['firstname'] = this.firstName;
    json['lastname'] = this.lastName;
    json['email'] = this.email;
    json['gender'] = this.gender;
    json['street_address'] = this.streetAddrress;
    json['street_address_line_two'] = this.streetAddressTwo;
    json['country_id'] = this.countryId;
    json['country_name'] = this.countryName;
    json['state_id'] = this.stateId;
    json['state_name'] = this.stateName;
    json['city_id'] = this.cityId;
    json['city_name'] = this.cityName;
    json['mobile'] = this.mobile;
    json['token'] = this.token;
    json['pincode'] = this.pincode;
    json['dob'] = this.dob;
    return json;
  }
}
