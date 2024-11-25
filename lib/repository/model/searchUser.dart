class SearchUser {
  // 类名已更改
  int userId;
  String userName;
  String nickName;
  String userAvatar;
  int userSex;
  String userPhoneNumber;
  String? dailyPhoneNumber;
  String? email;
  String? lng;
  String? lat;
  String loginIp;
  String loginTime;
  int userType;
  int userStatus;

  SearchUser({
    // 构造函数类名已更改
    required this.userId,
    required this.userName,
    required this.nickName,
    required this.userAvatar,
    required this.userSex,
    required this.userPhoneNumber,
    this.dailyPhoneNumber,
    this.email,
    this.lng,
    this.lat,
    required this.loginIp,
    required this.loginTime,
    required this.userType,
    required this.userStatus,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    // 工厂方法类名已更改
    return SearchUser(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      nickName: json['nickName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      userSex: json['userSex'] ?? 0,
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      dailyPhoneNumber: json['dailyPhoneNumber'] ?? null,
      email: json['email'] ?? null,
      lng: json['lng'] ?? null,
      lat: json['lat'] ?? null,
      loginIp: json['loginIp'] ?? '',
      loginTime: json['loginTime'] ?? '',
      userType: json['userType'] ?? 0,
      userStatus: json['userStatus'] ?? 0,
    );
  }

  // Map<String, Object>

  Object toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'nickName': nickName,
      'userAvatar': userAvatar,
      'userSex': userSex,
      'userPhoneNumber': userPhoneNumber,
      'dailyPhoneNumber': dailyPhoneNumber ?? '',
      'email': email ?? '',
      'lng': lng ?? '',
      'lat': lat ?? '',
      'loginIp': loginIp,
      'loginTime': loginTime,
      'userType': userType,
      'userStatus': userStatus,
    };
  }

  Map<String, dynamic> toMapKV() {
    return {
      'userId': userId,
      'userName': userName,
      'nickName': nickName,
      'userAvatar': userAvatar,
      'userSex': userSex,
      'userPhoneNumber': userPhoneNumber,
      'dailyPhoneNumber': dailyPhoneNumber ?? '',
      'email': email ?? '',
      'lng': lng ?? '',
      'lat': lat ?? '',
      'loginIp': loginIp,
      'loginTime': loginTime,
      'userType': userType,
      'userStatus': userStatus,
    };
  }

  @override
  String toString() {
    return 'SearchUser(userId: $userId, userName: $userName, nickName: $nickName, userAvatar: $userAvatar, userSex: $userSex, userPhoneNumber: $userPhoneNumber, dailyPhoneNumber: $dailyPhoneNumber, email: $email, lng: $lng, lat: $lat, loginIp: $loginIp, loginTime: $loginTime, userType: $userType, userStatus: $userStatus)'; // 更新了toString方法
  }
}
