import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../repository/model/user.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/constants.dart';
import '../../utils/sp_utils.dart';

bool isProduction = Constants.IS_Production;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Uint8List? captchaImage;
  TextEditingController _accountController =
      TextEditingController(text: Global.input);
  TextEditingController _passwordController =
      TextEditingController(text: Global.password);
  TextEditingController _captchaController = TextEditingController();
  FocusNode _accountFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _captchaFocusNode = FocusNode();
  bool _isPasswordVisible = false; // 新增变量，用于控制密码是否可见
  bool _isAgreed = false; // 新增变量，用于控制协议同意状态

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
      if (isProduction) print("res : $response");
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
    await Global.dbUtil!.open();

    //await Global.dbUtil!.deleteAllByHelper('tbl_user');
    // await Global.dbUtil!.insertByHelper("tbl_user", Global.userTmp!.toMap());
    // if (Global.isLogin)
    //   await Global.dbUtil!.insertByHelper("tbl_user", Global.userInfo!.toMap());
    await Global.dbUtil!.close();

    RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
  }

  void _jumpToForgetPasswordPage() async {
    RouteUtils.pushForNamed(context, RoutePath.forgetPasswordCodePage);
  }

  void _jumpToRegisterPage() async {
    RouteUtils.pushForNamed(context, RoutePath.registerCheckCodePage);
  }

  void _jumpToPhoneLoginPage() async {
    RouteUtils.pushForNamed(context, RoutePath.phoneLoginPage);
  }

  void _jumpToEmailLoginPage() async {
    RouteUtils.pushForNamed(context, RoutePath.emailLoginPage);
  }

  Future<void> _login() async {
    final String captcha = _captchaController.text;
    final String account = _accountController.text;
    final String password = _passwordController.text;

    if (account.isEmpty) {
      showToast("账号不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (password.isEmpty) {
      showToast("密码不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (captcha.isEmpty) {
      showToast("验证码不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (!_isAgreed) {
      showToast("请先同意协议",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    final String url = UrlPath.loginUrl +
        "?countId=$account&password=$password" +
        "&captchaCode=$captcha";

    try {
      final response = await DioInstance.instance().post(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          final data = response.data;

          Global.isLogin = true;

          // 保存用户信息
          Global.userInfo = User.fromJson(data["data"]);
          Global.input = account;
          Global.password = password;

          // 保存token
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;

          //持久化
          await SpUtils.saveString("input", Global.input!);
          await SpUtils.saveString("password", Global.password!);
          await SpUtils.saveString("token", Global.token!);

          if (isProduction) print("userInfo: ${Global.userInfo.toString()}");
          if (isProduction) print("token: ${Global.token}");

          showToast("登陆成功", duration: Duration(seconds: 1));

          // 跳转
          _jumpToTab();
        } else {
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) print('Login failed: ${response}');
      }
    } catch (e) {
      if (isProduction) print('Error: $e');
    }
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreed = !_isAgreed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _jumpToTab,
            child: Text(
              "游客登录>",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "账号登录",
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        width: 350.w,
                        height: 600.h,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
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
                                    obscureText: !_isPasswordVisible,
                                    // 控制密码是否可见
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _jumpToForgetPasswordPage,
                                  child: Text(
                                    "忘记密码",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
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
                                      onPressed: _jumpToRegisterPage,
                                      child: Text(
                                        "注册",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                  Expanded(child: SizedBox()),
                                  TextButton(
                                      onPressed: _jumpToPhoneLoginPage,
                                      child: Text(
                                        "使用手机验证码登录",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
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
                                      onPressed: _jumpToEmailLoginPage,
                                      child: Text(
                                        "使用邮箱验证码登录",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
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
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40),
        child: Row(
          children: [
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: _toggleAgreement,
              child: Icon(
                _isAgreed
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline,
                color: _isAgreed ? Theme.of(context).primaryColor : Colors.grey,
                size: 25,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "我已阅读《服务协议》《隐私协议》",
              style: TextStyle(
                color: _isAgreed ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
