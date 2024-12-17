import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pay/flutter_pay.dart';
// import 'package:ifly_speech_recognition/ifly_speech_recognition.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/sqlite/tables_init.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:jiayuan/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../im/im_chat_api.dart';
import '../repository/api/keeper_api.dart';
import '../repository/model/user.dart';
import '../utils/notification_helper.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
 //   Global.SpeechRecognitionServiceinit();
    super.initState();

    //获取通知权限
    NotificationHelper.getInstance().requestNotificationPermissions();
    //初始化通知
    NotificationHelper.getInstance().initialize();

    // 初始化CookieJar
   DioInstance.instance().changeBaseUrl(UrlPath.testBaseUrl);

    //初始化sqlite数据库
    _initDB();

    //初始化IM SDK
    ImChatApi.getInstance().initSDK();

    // 设置延迟，2秒后跳转
    // 检验token是否存活
    // 异步初始化持久化数据
    _initializeData();
    //初始化支付插件
    FlutterPay.initConfig(
      aliPayAppId: "9021000142642965",
    );
  }

  Future<void> _initializeData() async {
    // 获取持久化数据
    Global.input = await SpUtils.getString("input");
    Global.token = await SpUtils.getString("token");
    Global.password = await SpUtils.getString("password");

    _AutoLogin();
  }

  void _jumpToTab() {
    // 如果Token存活 跳转到首页
    Future.delayed(Duration(seconds: 1), () {
      RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
    });
  }

  void _jumpToLogin() {
    // 如果Token不存活 跳转到登录界面
    Future.delayed(const Duration(seconds: 1), () {
      RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
    });
  }

  Future<void> _initDB() async {
    TablesInit tables = TablesInit();
    await tables.init();
    Global.dbUtil = DBUtil();
    // await Global.dbUtil?.open();
  }

  void _AutoLogin() async {
    // 设置延迟，2秒后跳转
    // 检验token是否存活
    if (Global.token != null) {
      try {
        final response = await DioInstance.instance().post(
            path: UrlPath.loginAutoUrl,
            options: Options(headers: {"Authorization": Global.token}));
        if (response.statusCode == 200) {
          if (response.data['code'] == 200) {
            final data = response.data;

            Global.isLogin = true;

            // 保存用户信息
            Global.userInfo = User.fromJson(data["data"]);

            // 保存token
            final List<String> token =
                response.headers["Authorization"] as List<String>;
            Global.token = token.first;

            if (isProduction) print("token : ${Global.token}");

            //持久化
            await SpUtils.saveString("token", Global.token!);

            //获取家政员信息
            if((Global.userInfo?.userType ?? 0) == 1){
              await KeeperApi.instance.getKeeperDataByUserId();
            }

            //IM登录
            String userSig = response.data['message'];

            if (isProduction) print("userSig : $userSig");

            await ImChatApi.getInstance()
                .login(Global.userInfo!.userId.toString(), userSig);

            await ImChatApi.getInstance().setSelfInfo(
                Global.userInfo!.userId.toString(),
                Global.userInfo!.nickName,
                Global.userInfo!.userAvatar,
                Global.userInfo!.userSex,
                Global.userInfo!.userType);

            showToast("自动登录成功", duration: const Duration(seconds: 1));
            _jumpToTab();
          } else {
            showToast(response.data['message'],
                duration: const Duration(seconds: 1));
            _jumpToLogin();
          }
        } else {
          showToast("无法连接服务器", duration: const Duration(seconds: 1));
          _jumpToLogin();
        }
      } catch (e) {
        _jumpToLogin();
      }
    } else {
      _jumpToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "欢迎使用家缘服务平台",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ), // 圆形加载框
            SizedBox(height: 20), // 间隔
            Text(
              '进入中...',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
