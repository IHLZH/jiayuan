import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/login_page/email_login_page.dart';
import 'package:jiayuan/page/login_page/forget_password_check_code_page.dart';
import 'package:jiayuan/page/login_page/forget_password_page.dart';
import 'package:jiayuan/page/login_page/forget_password_submit_page.dart';
import 'package:jiayuan/page/login_page/login_page.dart';
import 'package:jiayuan/page/register_page/register_check_code_page.dart';
import 'package:jiayuan/page/start_page.dart';
import 'package:jiayuan/route/route_path.dart';

import '../page/tab_page/tab_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //首页tab
      case RoutePath.tab:
        return pageRoute(const TabPage(), settings: settings);
      // 启动页
      case RoutePath.startPage:
        return pageRoute(StartPage());
      //账号密码登录页
      case RoutePath.loginPage:
        return pageRoute(LoginPage());
      // 邮箱验证码登录页
      case RoutePath.emailLoginPage:
        return pageRoute(EmailLoginPage());
      // 忘记密码页（不用）
      case RoutePath.forgetPasswordPage:
        return pageRoute(ForgetPasswordPage());
      // 忘记密码验证码页
      case RoutePath.forgetPasswordCodePage:
        return pageRoute(ForgetPasswordCheckCodePage());
      // 忘记密码新密码页
      case RoutePath.forgetPasswordNewPasswordPage:
        final args = settings.arguments as Map<String, dynamic>;
        final input = args['input'] as String;
        final isEmail = args['isEmail'] as bool;
        return pageRoute(
            ForgetPasswordSubmitPage(input: input, isEmail: isEmail));
        //注册验证码页
      case RoutePath.registerCheckCodePage:
        return pageRoute(RegisterCheckCodePage());
    }
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body:
                Center(child: Text('No route defined for ${settings.name}'))));
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}
