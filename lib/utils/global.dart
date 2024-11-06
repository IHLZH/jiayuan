import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/location_data.dart';

class Global{
  static User? userInfo;
  static String? token;
  static String? input;
  static String? password;
  //sqlite数据库工具类 用于打开和关闭数据库
  static DBUtil? dbUtil;
  //用户定位信息
  static LocationData? location;

}