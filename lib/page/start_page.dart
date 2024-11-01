import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';

import '../route/routes.dart';
import '../utils/constants.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    // 初始化CookieJar
    DioInstance.instance().initDio(baseUrl: "");
    DioInstance.instance().changeBaseUrl(UrlPath.BaseUrl);

    // 设置延迟，2秒后跳转
    // 检验token是否存活


    // 如果Token存活 跳转到首页
    // Future.delayed(Duration(seconds: 2), () {});

    // 如果Token不存活 跳转到登录界面
    Future.delayed(const Duration(seconds: 2), () {
      RouteUtils.pushNamedAndRemoveUntil(context,RoutePath.loginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("欢迎使用家缘服务平台",style: TextStyle(fontSize: 24,),),
            SizedBox(height: 20),
            CircularProgressIndicator(), // 圆形加载框
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
