class FullOrder {
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
  String? keeperName;
  String? serviceName;

  // 构造函数
  FullOrder({
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
    this.keeperName,
    this.serviceName,
  });

  // fromJson 方法
  factory FullOrder.fromJson(Map<String, dynamic> json) {
    return FullOrder(
      commissionId: json['commissionId'],
      userId: json['userId'],
      keeperId: json['keeperId'],
      commissionBudget: json['commissionBudget']?.toDouble(),
      downPayment: json['down_payment']?.toDouble(),
      commissionDescription: json['commissionDescription'],
      province: json['province'],
      city: json['city'],
      county: json['county'],
      commissionAddress: json['commissionAddress'],
      lng: json['lng'],
      lat: json['lat'],
      userPhoneNumber: json['userPhoneNumber'],
      createTime: json['createTime'] != null ? DateTime.parse(json['createTime']) : null,
      updatedTime: json['updatedTime'] != null ? DateTime.parse(json['updatedTime']) : null,
      expectStartTime: json['expectStartTime'] != null ? DateTime.parse(json['expectStartTime']) : null,
      realStartTime: json['realStartTime'] != null ? DateTime.parse(json['realStartTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      specifyServiceDuration: json['specifyServiceDuration'],
      commissionStatus: json['commissionStatus'],
      keeperName: json['keeperName'],
      serviceName: json['serviceName'],
    );
  }

  // toMap 方法
  Map<String, dynamic> toMap() {
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
      'keeperName': keeperName,
      'serviceName': serviceName,
    };
  }

  // toString 方法
  @override
  String toString() {
    return 'FullOrder{'
        'commissionId: $commissionId, '
        'userId: $userId, '
        'keeperId: $keeperId, '
        'commissionBudget: $commissionBudget, '
        'downPayment: $downPayment, '
        'commissionDescription: $commissionDescription, '
        'province: $province, '
        'city: $city, '
        'county: $county, '
        'commissionAddress: $commissionAddress, '
        'lng: $lng, '
        'lat: $lat, '
        'userPhoneNumber: $userPhoneNumber, '
        'createTime: $createTime, '
        'updatedTime: $updatedTime, '
        'expectStartTime: $expectStartTime, '
        'realStartTime: $realStartTime, '
        'endTime: $endTime, '
        'specifyServiceDuration: $specifyServiceDuration, '
        'commissionStatus: $commissionStatus, '
        'keeperName: $keeperName, '
        'serviceName: $serviceName'
        '}';
  }

  static List<FullOrder> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FullOrder.fromJson(json)).toList();
  }
}
