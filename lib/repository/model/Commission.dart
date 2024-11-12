class Commission {
  int? commissionId;

  int? userId;

  int? keeperId;

  double? commissionBudget;

  double? downPayment;

  String? commissionDescription;

  String? province;

  String? city;

  String? county;

  String? commissionAddress;

  String? lng;

  String? lat;

  String? userPhoneNumber;

  DateTime? createTime;

  DateTime? updatedTime;

  DateTime? expectStartTime;

  DateTime? realStartTime;

  DateTime? endTime;

  String? specifyServiceDuration;

  int? commissionStatus;

  //
  Commission({
    this.commissionId,
    this.userId,
    this.keeperId,
    this.commissionBudget,
    this.downPayment,
    this.commissionDescription,
    this.province,
    this.city,
    this.county,
    this.commissionAddress,
    this.lng,
    this.lat,
    this.userPhoneNumber,
    this.createTime,
    this.updatedTime,
    this.expectStartTime,
    this.realStartTime,
    this.endTime,
    this.specifyServiceDuration,
    this.commissionStatus,
  });
  Commission.fromJson(Map<String, dynamic> json) {
    commissionId = json['commissionId'];
    userId = json['userId'];
    keeperId = json['keeperId'];
    commissionBudget = json['commissionBudget'];
    downPayment = json['down_payment'];
    commissionDescription = json['commissionDescription'];
    province = json['province'];
    city = json['city'];
    county = json['county'];
    commissionAddress = json['commissionAddress'];
    lng = json['lng'];
    lat = json['lat'];
    userPhoneNumber = json['userPhoneNumber'];
    createTime = DateTime.parse(json['createTime']);
    updatedTime = DateTime.parse(json['updatedTime']);
    expectStartTime = DateTime.parse(json['expectStartTime']);
    realStartTime = DateTime.parse(json['realStartTime']);
    endTime = DateTime.parse(json['endTime']);
    specifyServiceDuration = json['specifyServiceDuration'];
    commissionStatus = json['commissionStatus'];
  }


  Map<String, dynamic> toJson() {
    return {
      'commissionId': commissionId,
      'userId': userId,
      'keeperId': keeperId,
      'commissionBudget': commissionBudget,
      'down_payment': downPayment,
      'commissionDescription': commissionDescription,
      'province': province,
      'city': city,
      'county': county,
      'commissionAddress': commissionAddress,
      'lng': lng,
      'lat': lat,
      'userPhoneNumber': userPhoneNumber,
      'createTime': createTime?.toIso8601String(),
      'updatedTime': updatedTime?.toIso8601String(),
      'expectStartTime': expectStartTime?.toIso8601String(),
      'realStartTime': realStartTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'specifyServiceDuration': specifyServiceDuration,
      'commissionStatus': commissionStatus,
    };
  }
}
