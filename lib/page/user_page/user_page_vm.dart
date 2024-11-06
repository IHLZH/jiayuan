// view_model/profile_view_model.dart
import 'package:flutter/material.dart';
import '../../repository/model/user.dart';
import '../../utils/global.dart';

class UserViewModel extends ChangeNotifier {
  // 模拟用户数据
  User? user = Global.userInfo;

  // 更新用户信息（可以假设从服务器获取数据）
  void updateUser(User newUser) {
    user = newUser;
    notifyListeners(); // 通知 UI 数据更新
  }
}
