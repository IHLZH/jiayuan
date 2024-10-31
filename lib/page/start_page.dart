import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';

import '../route/routes.dart';
import '../utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '家缘服务平台',
      theme: ThemeData(
        primaryColor: Colors.teal,
        cardColor: Colors.grey,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.green),
          bodyMedium: TextStyle(color: Colors.teal),
        ),
      ),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePath.startPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    // 初始化CookieJar
    DioInstance.instance().initDio();
    DioInstance.instance().changeBaseUrl(UrlPath.BaseUrl);

    // 设置延迟，2秒后跳转
    // 检验token是否存活


    // 如果Token存活 跳转到首页
    // Future.delayed(Duration(seconds: 2), () {});

    // 如果Token不存活 跳转到登录界面
    Future.delayed(Duration(seconds: 2), () {
      RouteUtils.pushNamedAndRemoveUntil(context,RoutePath.loginPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
