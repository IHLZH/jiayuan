import 'package:flutter/foundation.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/repository/model/standardPrice.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/location_data.dart';

class Global {
  static User? userTmp = User(
      userId: 1,
      userName: "ikun",
      nickName: "nickName",
      userPassword: "123456",
      userAvatar: "userAvatar",
      userSex: 1,
      userPhoneNumber: "userPhoneNumber",
      createdTime: "createdTime",
      updatedTime: "updatedTime",
      loginIp: "loginIp",
      loginTime: "loginTime",
      userType: 1,
      userStatus: 1);

  //个人信息与监听器
  //Global.userInfoNotifier.value = Global.userInfo;//这样来实现更新
  static final userInfoNotifier = ValueNotifier<User?>(null);

  static User? get userInfo => userInfoNotifier.value;
  static set userInfo(User? value) {
    userInfoNotifier.value = value;
  }

  static String? token;
  static String? input;
  static String? password;

  // 价格标准
  static List<StandardPrice>? standPrices;

  static bool isLogin = false;

  //sqlite数据库工具类 用于打开和关闭数据库
  static DBUtil? dbUtil;

  //用户定位信息
  static LocationData? location;
}
