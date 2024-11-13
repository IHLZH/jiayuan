import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/repository/model/standardPrice.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/location_data.dart';

import '../page/commission_page/commission_vm.dart';

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
  //Global.userInfoNotifier.value = (User)updatedUser;//这样来实现更新
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

  //委托类型表
  static List<CommissionType> CommissionTypes = [
    CommissionType(
        icon: Icons.house,
        typeText: "日常保洁"
    ),
    CommissionType(
        icon: Icons.auto_fix_high,
        typeText: "家电维修"
    ),
    CommissionType(
        icon: Icons.car_crash,
        typeText: "搬家搬厂"
    ),
    CommissionType(
        icon: Icons.fastfood,
        typeText: "收纳整理"
    ),
    CommissionType(
        icon: Icons.handyman,
        typeText: "管道疏通"
    ),
    CommissionType(
        icon: Icons.precision_manufacturing,
        typeText: "维修拆装"
    ),
    CommissionType(
        icon: Icons.baby_changing_station,
        typeText: "保姆月嫂"
    ),
    CommissionType(
        icon: Icons.elderly,
        typeText: "居家养老"
    ),
    CommissionType(
        icon: Icons.bedroom_baby,
        typeText: "居家托育"
    ),
    CommissionType(
        icon: Icons.child_care,
        typeText: "专业养护"
    ),
    CommissionType(
        icon: Icons.family_restroom,
        typeText: "家庭保健"
    ),
  ];
}
