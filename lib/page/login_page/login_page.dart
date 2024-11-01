import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/utils/global.dart';

import '../../repository/model/user.dart';
import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/constants.dart';

bool isProduction  =  Constants.IS_Production;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Uint8List? captchaImage;
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  FocusNode _accountFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _captchaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadInitialCaptcha();
    _accountFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _captchaFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _accountFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _captchaFocusNode.removeListener(_onFocusChange);
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    _captchaFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _loadInitialCaptcha() async {
    try {
      final response = await DioInstance.instance().get(
        path: UrlPath.captchaImageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      setState(() {
        captchaImage = response.data;
      });
      if (isProduction) print('Initial captcha loaded successfully.');
      if(isProduction)print("res : $response");
    } catch (e) {
      if (isProduction) print('Error loading initial captcha: $e');
      setState(() {
        captchaImage = null; // 设置为 null 表示无法获取验证码
      });
    }
  }

  void _reloadImage() async {
    try {
      final response = await DioInstance.instance().get(
        path: UrlPath.captchaImageUrl +
            "?timestamp=${DateTime.now().millisecondsSinceEpoch}",
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        captchaImage = response.data;
      });
    } catch (e) {
      if (isProduction) print('Error reloading captcha: $e');
      setState(() {
        captchaImage = null; // 设置为 null 表示无法获取验证码
      });
    }
  }

  void _jumpToTab() async {
    RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
  }

  void _jumpToForgetPasswordPage() async {
    RouteUtils.pushForNamed(context, RoutePath.forgetPasswordCodePage);
  }

  Future<void> _login() async {
    final String captcha = _captchaController.text;
    final String account = _accountController.text;
    final String password = _passwordController.text;
    final String url = UrlPath.loginUrl + "?countId=$account&password=$password" + "&captchaCode=$captcha";

    // final String url = "/sss";

    try {
      final response = await DioInstance.instance().post(path: url);
      if(isProduction)print("res: $response");
      // if(isProduction)print("statusCode : ${response.statusCode}");
      // if(isProduction)print("statusmessage : ${response.statusMessage}");
      // if(isProduction)print("code : ${response.data["code"]}");
      // if(isProduction)print("message : ${response.data["message"]}");\

      if(isProduction)print("res header: ${response.headers['Authorization']}");

      if (response.statusCode == 200&&response.data["code"]==200) {
        final data = response.data;

        // Global.userInfo = User.fromMap(data);

        // if (isProduction) print("response : $response");

        _jumpToTab();
      } else {
        if (isProduction) print('Login failed: ${response}');
      }
    } catch (e) {
      if (isProduction) print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _jumpToTab,
            child: Text(
              "游客登录>",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100.h),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "账号登录",
                    style: TextStyle(
                        fontSize: 30, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    width: 350.w,
                    height: 600.h,
                    child: ListView(
                      children: [
                        TextField(
                          controller: _accountController,
                          focusNode: _accountFocusNode,
                          decoration: InputDecoration(
                            labelText: "账号",
                            labelStyle: TextStyle(
                              color: _accountFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                decoration: InputDecoration(
                                  labelText: "密码",
                                  labelStyle: TextStyle(
                                    color: _passwordFocusNode.hasFocus
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _jumpToForgetPasswordPage,
                              child: Text(
                                "忘记密码",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 50.h,
                          width: 250.w,
                          child: Row(
                            children: [
                              Container(
                                width: 100.w,
                                height: 50.h,
                                child: GestureDetector(
                                  onTap: _reloadImage,
                                  child: captchaImage != null
                                      ? Image.memory(captchaImage!)
                                      : Center(
                                      child: Text("无法获取验证码",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight:
                                              FontWeight.bold))),
                                ),
                              ),
                              SizedBox(width: 50.w),
                              Container(
                                width: 200.w,
                                height: 50.h,
                                child: TextField(
                                  controller: _captchaController,
                                  focusNode: _captchaFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "验证码",
                                    labelStyle: TextStyle(
                                      color: _captchaFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: _login,
                          child: Text('登录',
                              style:
                              TextStyle(fontSize: 18, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.r, vertical: 15.r),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50.h,
                          width: 300.w,
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "注册",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                              Expanded(child: SizedBox()),
                              TextButton(
                                  onPressed: () {
                                    RouteUtils.pushForNamed(
                                        context, RoutePath.phoneLoginPage);
                                  },
                                  child: Text(
                                    "使用手机验证码登录",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: 50.h,
                          width: 300.w,
                          child: Row(
                            children: [
                              Expanded(child: SizedBox()),
                              TextButton(
                                  onPressed: () {
                                    RouteUtils.pushForNamed(
                                        context, RoutePath.emailLoginPage);
                                  },
                                  child: Text(
                                    "使用邮箱验证码登录",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
