import 'package:jiayuan/repository/model/StandardPrice.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/location_data.dart';

class Global{

  static User? userTmp = User(userId: 1, userName: "ikun", nickName: "nickName", userPassword: "123456", userAvatar: "userAvatar", userSex: 1, userPhoneNumber: "userPhoneNumber", createdTime: "createdTime", updatedTime: "updatedTime", loginIp: "loginIp", loginTime: "loginTime", userType: 1, userStatus: 1);
  static User? userInfo;
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