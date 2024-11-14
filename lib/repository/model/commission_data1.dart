import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/utils/common_data.dart';

/// commissionId : 0
/// userId : 0
/// keeperId : 0
/// commissionBudget : 0
/// commissionDescription : ""
/// province : ""
/// city : ""
/// county : ""
/// commissionAddress : ""
/// lng : ""
/// lat : ""
/// userPhoneNumber : ""
/// createTime : ""
/// updatedTime : ""
/// expectStartTime : ""
/// realStartTime : ""
/// endTime : ""
/// specifyServiceDuration : ""
/// commissionStatus : 0

class CommissionData1 {
  CommissionData1({
      int? commissionId,
      int? userId,
      int? keeperId,
      double? commissionBudget,
      String? commissionDescription, 
      String? province, 
      String? city, 
      String? county, 
      String? commissionAddress, 
      double? lng,
      double? lat,
      String? userPhoneNumber,
    DateTime? createTime,
    DateTime? updatedTime,
    DateTime? expectStartTime,
    DateTime? realStartTime,
    DateTime? endTime,
      String? specifyServiceDuration,
      int? commissionStatus,}){
    _commissionId = commissionId;
    _userId = userId;
    _keeperId = keeperId;
    _commissionBudget = commissionBudget;
    _commissionDescription = commissionDescription;
    _province = province;
    _city = city;
    _county = county;
    _commissionAddress = commissionAddress;
    _lng = lng;
    _lat = lat;
    _userPhoneNumber = userPhoneNumber;
    _createTime = createTime;
    _updatedTime = updatedTime;
    _expectStartTime = expectStartTime;
    _realStartTime = realStartTime;
    _endTime = endTime;
    _specifyServiceDuration = specifyServiceDuration;
    _commissionStatus = commissionStatus;
}

  CommissionData1.fromJson(dynamic json) {
    _commissionId = json['commissionId'];
    _userId = json['userId'];
    _userName = User.fromJson(json['user']).nickName;
    _keeperId = json['keeperId'] ?? 0;
    _typeName = json['service'];
    _commissionBudget = json['commissionBudget'].toDouble();
    _commissionDescription = json['commissionDescription'];
    _province = json['province'];
    _city = json['city'];
    _county = json['county'];
    _commissionAddress = json['commissionAddress'];
    _lng = double.parse(json['lng']);
    _lat = double.parse(json['lat']);
    _userPhoneNumber = json['userPhoneNumber'];
    _createTime = DateTime.parse(json['createTime']);
    _updatedTime = DateTime.parse(json['updatedTime']);
    _expectStartTime = DateTime.parse(json['expectStartTime'] ?? "1999-01-01T01:00:00.000+00:00");
    _realStartTime = DateTime.parse(json['realStartTime'] ?? "1999-01-01T01:00:00.000+00:00");
    _endTime = DateTime.parse(json['endTime'] ?? "1999-01-01T01:00:00.000+00:00");
    _specifyServiceDuration = json['specifyServiceDuration'];
    _commissionStatus = json['commissionStatus'];

    _initDays();
    _initType();
  }

  void _initType(){

  }

  void _initDays(){
    _typeId = CommonData.TypeId[_typeName];
    _isLong = typeId > 6 ? true : false;

    DateTime currentTime = DateTime.now();
    int currentMonth = currentTime.month;
    int currentDay = currentTime.day;

    if(expectStartTime.month == currentMonth && expectStartTime.day == currentDay){
      _days = "今天";
    }else{
      _days = ((expectStartTime.month - currentMonth) * 30 + (expectStartTime.day - currentDay)).toString() + "天后";
    }
  }


  int? _commissionId;
  int? _userId;
  String? _userName;
  int? _keeperId;
  int? _typeId;
  String? _typeName;
  double? _commissionBudget;
  String? _commissionDescription;
  String? _province;
  String? _city;
  String? _county;
  String? _commissionAddress;
  double? _lng;
  double? _lat;
  String? _userPhoneNumber;
  DateTime? _createTime;
  DateTime? _updatedTime;
  DateTime? _expectStartTime;
  DateTime? _realStartTime;
  DateTime? _endTime;
  String? _specifyServiceDuration;
  int? _commissionStatus;
  bool? _isLong; //是否是长期
  String? _days;


CommissionData1 copyWith({
  int? commissionId,
  int? userId,
  int? keeperId,
  double? commissionBudget,
  String? commissionDescription,
  String? province,
  String? city,
  String? county,
  String? commissionAddress,
  double? lng,
  double? lat,
  String? userPhoneNumber,
  DateTime? createTime,
  DateTime? updatedTime,
  DateTime? expectStartTime,
  DateTime? realStartTime,
  DateTime? endTime,
  String? specifyServiceDuration,
  int? commissionStatus,
}) => CommissionData1(
  commissionId: commissionId ?? _commissionId,
  userId: userId ?? _userId,
  keeperId: keeperId ?? _keeperId,
  commissionBudget: commissionBudget ?? _commissionBudget,
  commissionDescription: commissionDescription ?? _commissionDescription,
  province: province ?? _province,
  city: city ?? _city,
  county: county ?? _county,
  commissionAddress: commissionAddress ?? _commissionAddress,
  lng: lng ?? _lng,
  lat: lat ?? _lat,
  userPhoneNumber: userPhoneNumber ?? _userPhoneNumber,
  createTime: createTime ?? _createTime,
  updatedTime: updatedTime ?? _updatedTime,
  expectStartTime: expectStartTime ?? _expectStartTime,
  realStartTime: realStartTime ?? _realStartTime,
  endTime: endTime ?? _endTime,
  specifyServiceDuration: specifyServiceDuration ?? _specifyServiceDuration,
  commissionStatus: commissionStatus ?? _commissionStatus,
);
  int get commissionId => _commissionId ?? 1;
  int get userId => _userId ?? 0;
  String get userName => _userName ?? "";
  int get keeperId => _keeperId ?? 0;
  int get typeId => _typeId ?? 1;
  String get typeName => _typeName ?? "";
  double get commissionBudget => _commissionBudget ?? 999999;
  String get commissionDescription => _commissionDescription ?? "";
  String get province => _province ?? "";
  String get city => _city ?? "";
  String get county => _county ?? "";
  String get commissionAddress => _commissionAddress ?? "";
  double get lng => _lng ?? 0.0;
  double get lat => _lat ?? 0.0;
  String get userPhoneNumber => _userPhoneNumber ?? "";
  DateTime get createTime => _createTime ?? DateTime(1999,1,1,0,0,0);
  DateTime get updatedTime => _updatedTime ?? DateTime(1999,1,1,0,0,0);
  DateTime get expectStartTime => _expectStartTime ?? DateTime(1999,1,1,0,0,0);
  DateTime get realStartTime => _realStartTime ?? DateTime(1999,1,1,0,0,0);
  DateTime get endTime => _endTime ?? DateTime(1999,1,1,0,0,0);
  String get specifyServiceDuration => _specifyServiceDuration ?? "";
  int get commissionStatus => _commissionStatus ?? 0;
  bool get isLong => _isLong ?? false;
  String get days => _days ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commissionId'] = _commissionId.toString();
    map['userId'] = _userId.toString();
    map['keeperId'] = _keeperId.toString();
    map['commissionBudget'] = _commissionBudget.toString();
    map['commissionDescription'] = _commissionDescription;
    map['province'] = _province;
    map['city'] = _city;
    map['county'] = _county;
    map['commissionAddress'] = _commissionAddress;
    map['lng'] = _lng.toString();
    map['lat'] = _lat.toString();
    map['userPhoneNumber'] = _userPhoneNumber;
    map['createTime'] = _createTime.toString();
    map['updatedTime'] = _updatedTime.toString();
    map['expectStartTime'] = _expectStartTime.toString();
    map['realStartTime'] = _realStartTime.toString();
    map['endTime'] = _endTime.toString();
    map['specifyServiceDuration'] = _specifyServiceDuration.toString();
    map['commissionStatus'] = _commissionStatus.toString();
    return map;
  }

  @override
  String toString() {
    return 'CommissionData1{_commissionId: $_commissionId, _userId: $_userId, _keeperId: $_keeperId, _commissionBudget: $_commissionBudget, _commissionDescription: $_commissionDescription, _province: $_province, _city: $_city, _county: $_county, _commissionAddress: $_commissionAddress, _lng: $_lng, _lat: $_lat, _userPhoneNumber: $_userPhoneNumber, _createTime: $_createTime, _updatedTime: $_updatedTime, _expectStartTime: $_expectStartTime, _realStartTime: $_realStartTime, _endTime: $_endTime, _specifyServiceDuration: $_specifyServiceDuration, _commissionStatus: $_commissionStatus, _isLong: $_isLong, _days: $_days}';
  }
}