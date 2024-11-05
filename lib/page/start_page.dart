import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../repository/model/user.dart';
import '../route/routes.dart';
import '../utils/constants.dart';
import '../utils/global.dart';

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

    // 异步初始化持久化数据
    _initializeData();
  }

  Future<void> _initializeData() async {
    // 获取持久化数据
    Global.input = await SpUtils.getString("input");
    Global.token = await SpUtils.getString("token");
    Global.password = await SpUtils.getString("password");

    _AutoLogin();
  }

  void _jumpToTab(){
    // 如果Token存活 跳转到首页
    Future.delayed(Duration(seconds: 2), () {
      RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
    });
  }

  void _jumpToLogin(){
    // 如果Token不存活 跳转到登录界面
    Future.delayed(const Duration(seconds: 2), () {
      RouteUtils.pushNamedAndRemoveUntil(context,RoutePath.loginPage);
    });
  }

  void _AutoLogin() async{
    // 设置延迟，2秒后跳转
    // 检验token是否存活
    if(Global.token != null){
      try{
        final response = await DioInstance.instance().post(path: UrlPath.loginAutoUrl,options: Options(headers: {"Authorization": Global.token}));
        if(response.statusCode == 200){
          if(response.data['code'] == 200){
            final data = response.data;

            // 保存用户信息
            Global.userInfo = User.fromJson(data["data"]);

            // 保存token
            final List<String> token =
            response.headers["Authorization"] as List<String>;
            Global.token = token.first;

            //持久化
            await SpUtils.saveString("token", Global.token!);

            showToast("自动登录成功",duration: const Duration(seconds: 1));
            _jumpToTab();
          }else{
            showToast(response.data['message'],duration: const Duration(seconds: 1));
            _jumpToLogin();
          }
        }else{
          showToast("无法连接服务器",duration: const Duration(seconds: 1));
          _jumpToLogin();
        }
      }catch(e){
        _jumpToLogin();
      }
    }else{
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
            Text("欢迎使用家缘服务平台",style: TextStyle(fontSize: 24,),),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Theme.of(context).primaryColor,), // 圆形加载框
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
