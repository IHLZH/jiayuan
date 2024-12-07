import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:ifly_speech_recognition/ifly_speech_recognition.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/repository/model/standardPrice.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/location_data.dart';

import '../page/commission_page/commission_vm.dart';

class Global {
  //个人信息与监听器
  //Global.userInfoNotifier.value = (User)updatedUser;//这样来实现更新
  static final userInfoNotifier = ValueNotifier<User?>(null);
  // static late SpeechRecognitionService speechRecognitionService;
  // //初始化语音识别服务
  // static Future SpeechRecognitionServiceinit() async {
  //   Global.speechRecognitionService = SpeechRecognitionService(
  //     appId: '6ccedc6f',
  //     appKey: 'YmQxN2U1OWU3ZjRlMmM2ZmU0MDAwZTMw',
  //     appSecret: '6fef031bd90be01d7b51fc84465f24fa',
  //   );
  //   Global.speechRecognitionService.initRecorder();
  // }
  static User? get userInfo => userInfoNotifier.value;
  static set userInfo(User? value) {
    userInfoNotifier.value = value;
  }

  //家政员信息监听
  static final keeperInfoNotifier = ValueNotifier<HousekeeperDataDetail?>(null);

  static HousekeeperDataDetail? get keeperInfo => keeperInfoNotifier.value;
  static set keeperInfo(HousekeeperDataDetail? keeper){
    keeperInfoNotifier.value = keeper;
  }

  //定位信息监听
  static final locationInfoNotifier = ValueNotifier<LocationData?>(null);

  static LocationData? get locationInfo => locationInfoNotifier.value;
  static set locationInfo(LocationData? locationData){
    locationInfoNotifier.value = locationData;
  }

  static String? token;
  static String? input;
  static String? password;

  // 价格标准
  static List<StandardPrice> standPrices = [];

  static bool isLogin = false;

  //sqlite数据库工具类 用于打开和关闭数据库
  static DBUtil? dbUtil;

  //委托类型表
  static List<CommissionType> CommissionTypes = [
    CommissionType(icon: Icons.import_contacts, typeText: "typeText"),
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
