import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../repository/model/user.dart';
import '../../utils/constants.dart';
import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  int _secondsRemaining = 0;
  Timer? _timer;
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _codeFocusNode = FocusNode();
  bool _isAgreed = false; // 新增变量，用于控制协议同意状态

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onFocusChange);
    _codeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onFocusChange);
    _codeFocusNode.removeListener(_onFocusChange);
    _phoneFocusNode.dispose(); //销毁焦点监听
    _codeFocusNode.dispose(); //销毁焦点监听
    _timer?.cancel(); //销毁定时器
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _startTimer() async {
    const duration = Duration(seconds: 1);
    _secondsRemaining = 60;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreed = !_isAgreed;
    });
  }

  Future<void> _getVerificationCode() async {
    final String phone = _phoneController.text;
    final String url = UrlPath.getPhoneCodeUrl + "?phone=$phone&purpose=login";

    try {
      final response = await DioInstance.instance().get(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          // 显示提示信息
          showToast("获取验证码成功");

          // 启动倒计时
          _startTimer();
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      } else {
        showToast("无法连接服务器", duration: const Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) {
        print('Error: $e');
      }
    }
  }

  void _jumpToTab() {
    RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
  }

  void _jumpToRegisterPage() async {
    RouteUtils.pushForNamed(context, RoutePath.registerCheckCodePage);
  }

  void _loginWithPhoneCode() async {
    final String phone = _phoneController.text;
    final String code = _codeController.text;

    if (phone.isEmpty) {
      showToast("请输入手机号", duration: const Duration(seconds: 1));
      return;
    }
    if (code.isEmpty) {
      showToast("请输入验证码", duration: const Duration(seconds: 1));
      return;
    }
    if (!_isAgreed) {
      showToast("请先同意用户协议", duration: const Duration(seconds: 1));
      return;
    }

    final String url =
        UrlPath.loginWithPhoneCodeUrl + "?phone=$phone&smsCode=$code";

    try {
      final response = await DioInstance.instance().post(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          final data = response.data;

          Global.isLogin = true;

          // 保存用户信息
          Global.userInfo = User.fromJson(data["data"]);
          Global.input = phone;

          // 保存token
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;

          //持久化
          await SpUtils.saveString("input", Global.input!);
          await SpUtils.saveString("token", Global.token!);

          if (isProduction) print("userInfo: ${Global.userInfo.toString()}");
          if (isProduction) print("token: ${Global.token}");

          // 跳转
          _jumpToTab();
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      } else {
        showToast("无法连接服务器", duration: const Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            RouteUtils.pop(context);
          },
        ),
        title: Text(
          "手机号登录",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100),
        child: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "手机号登录",
                    style: TextStyle(
                        fontSize: 30, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 350,
                    height: 600,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TextField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "手机号",
                            labelStyle: TextStyle(
                              color: _phoneFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 80,
                          width: 250,
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: 200,
                                child: Center(
                                  child: TextField(
                                    focusNode: _codeFocusNode,
                                    controller: _codeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "验证码",
                                      labelStyle: TextStyle(
                                        color: _codeFocusNode.hasFocus
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
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                height: 65,
                                child: Center(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.0),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // 设置小幅度的圆角
                                        ),
                                      ),
                                    ),
                                    onPressed: _secondsRemaining > 0
                                        ? null
                                        : _getVerificationCode,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _secondsRemaining > 0
                                            ? "重新获取 ($_secondsRemaining)"
                                            : "获取验证码",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loginWithPhoneCode,
                          child: Text('登录',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          width: 300,
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: _jumpToRegisterPage,
                                  child: Text(
                                    "注册",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Expanded(child: SizedBox()),
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
