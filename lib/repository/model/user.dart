import 'dart:convert';

class User {
  int userId;
  String userName;
  String nickName;
  String userPassword;
  String userAvatar;
  int userSex;
  String userPhoneNumber;
  String dailyPhoneNumber;
  String email;
  String createdTime;
  String updatedTime;
  String lng;
  String lat;
  String loginIp;
  String loginTime;
  int userType;
  int userStatus;

  User({
    required this.userId,
    required this.userName,
    required this.nickName,
    required this.userPassword,
    required this.userAvatar,
    required this.userSex,
    required this.userPhoneNumber,
    required this.dailyPhoneNumber,
    required this.email,
    required this.createdTime,
    required this.updatedTime,
    required this.lng,
    required this.lat,
    required this.loginIp,
    required this.loginTime,
    required this.userType,
    required this.userStatus,
  });

  /// 从JSON字符串中创建User实例
  factory User.fromJson(String jsonString) {
    final jsonMap = Map<String, dynamic>.from(json.decode(jsonString));
    return User.fromMap(jsonMap);
  }

  /// 从Map对象中创建User实例
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      nickName: map['nickName'] as String,
      userPassword: map['userPassword'] as String,
      userAvatar: map['userAvatar'] as String,
      userSex: map['userSex'] as int,
      userPhoneNumber: map['userPhoneNumber'] as String,
      dailyPhoneNumber: map['dailyPhoneNumber'] as String,
      email: map['email'] as String,
      createdTime: map['createdTime'] as String,
      updatedTime: map['updatedTime'] as String,
      lng: map['lng'] as String,
      lat: map['lat'] as String,
      loginIp: map['loginIp'] as String,
      loginTime: map['loginTime'] as String,
      userType: map['userType'] as int,
      userStatus: map['userStatus'] as int,
    );
  }

  /// 将User实例转换为Map对象
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'nickName': nickName,
      'userPassword': userPassword,
      'userAvatar': userAvatar,
      'userSex': userSex,
      'userPhoneNumber': userPhoneNumber,
      'dailyPhoneNumber': dailyPhoneNumber,
      'email': email,
      'createdTime': createdTime,
      'updatedTime': updatedTime,
      'lng': lng,
      'lat': lat,
      'loginIp': loginIp,
      'loginTime': loginTime,
      'userType': userType,
      'userStatus': userStatus,
    };
  }

  /// 将User实例转换为JSON字符串
  String toJson() {
    return json.encode(toMap());
  }

  @override
  String toString() {
    return 'User{'
        'userId: $userId, '
        'userName: $userName, '
        'nickName: $nickName, '
        'userPassword: $userPassword, '
        'userAvatar: $userAvatar, '
        'userSex: $userSex, '
        'userPhoneNumber: $userPhoneNumber, '
        'dailyPhoneNumber: $dailyPhoneNumber, '
        'email: $email, '
        'createdTime: $createdTime, '
        'updatedTime: $updatedTime, '
        'lng: $lng, '
        'lat: $lat, '
        'loginIp: $loginIp, '
        'loginTime: $loginTime, '
        'userType: $userType, '
        'userStatus: $userStatus'
        '}';
  }
}
