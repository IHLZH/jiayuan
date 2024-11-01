
/*
委托类，测试用
 */
class Commission {
  int commissionType; //委托类型
  String province; //省
  String city; //市
  String county; //县
  String address;
  double? distance; //距离
  String userPhone; //用户手机号
  double price;
  DateTime expectTime; //期望委托开始时间
  DateTime? realStartTime; //实际开始时间
  DateTime? endTime; //结束时间
  double estimatedTime; //预估时间
  int commissionStatus; //委托状态
  bool isLong; //是否是长期
  String? comment; //备注

  Commission({
    required this.commissionType,
    required this.province,
    required this.city,
    required this.county,
    required this.address,
    this.distance,
    required this.userPhone,
    required this.price,
    required this.expectTime,
    this.realStartTime,
    this.endTime,
    required this.estimatedTime,
    required this.commissionStatus,
    required this.isLong,
    this.comment
});


}