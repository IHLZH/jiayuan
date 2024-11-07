class User {
  final int userId;
  final String userName;
  final String nickName;
  final String userPassword;
  final String userAvatar;
  final int userSex;
  final String userPhoneNumber;
  final String? dailyPhoneNumber;
  final String? email;
  final String createdTime;
  final String updatedTime;
  final String? lng;
  final String? lat;
  final String loginIp;
  final String loginTime;
  final int userType;
  final int userStatus;

  User({
    required this.userId,
    required this.userName,
    required this.nickName,
    required this.userPassword,
    required this.userAvatar,
    required this.userSex,
    required this.userPhoneNumber,
    this.dailyPhoneNumber,
    this.email,
    required this.createdTime,
    required this.updatedTime,
    this.lng,
    this.lat,
    required this.loginIp,
    required this.loginTime,
    required this.userType,
    required this.userStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      nickName: json['nickName'] ?? '',
      userPassword: json['userPassword'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      userSex: json['userSex'] ?? 0,
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      dailyPhoneNumber: json['dailyPhoneNumber'] ?? null,
      email: json['email'] ?? null,
      createdTime: json['createdTime'] ?? '',
      updatedTime: json['updatedTime'] ?? '',
      lng: json['lng'] ?? null,
      lat: json['lat'] ?? null,
      loginIp: json['loginIp'] ?? '',
      loginTime: json['loginTime'] ?? '',
      userType: json['userType'] ?? 0,
      userStatus: json['userStatus'] ?? 0,
    );
  }

  Map<String, Object> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'nickName': nickName,
      'userPassword': userPassword,
      'userAvatar': userAvatar,
      'userSex': userSex,
      'userPhoneNumber': userPhoneNumber,
      'dailyPhoneNumber': dailyPhoneNumber ?? '',
      'email': email ?? '',
      'createdTime': createdTime,
      'updatedTime': updatedTime,
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
    return 'User(userId: $userId, userName: $userName, nickName: $nickName, userPassword: $userPassword, userAvatar: $userAvatar, userSex: $userSex, userPhoneNumber: $userPhoneNumber, dailyPhoneNumber: $dailyPhoneNumber, email: $email, createdTime: $createdTime, updatedTime: $updatedTime, lng: $lng, lat: $lat, loginIp: $loginIp, loginTime: $loginTime, userType: $userType, userStatus: $userStatus)';
  }
}
