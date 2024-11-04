import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/url_path.dart';
import '../../repository/model/user.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  int _secondsRemaining = 0;
  Timer? _timer;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _codeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFocusChange);
    _codeFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose(); //销毁焦点监听
    _codeFocusNode.dispose(); //销毁焦点监听
    _timer?.cancel(); //销毁定时器
    super.dispose();
  }

  void _startTimer() {
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

  Future<void> _getVerificationCode() async {
    final String email = _emailController.text;
    final String url = UrlPath.getEmailCodeUrl + "?email=$email&purpose=login";

    try {
      final response = await DioInstance.instance().get(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          // final data = response.data;

          showToast("获取验证码成功", duration: const Duration(seconds: 1));

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

  void _jumpToTab() async {
    RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
  }

  Future<void> _loginWithEmailCode() async {
    final String email = _emailController.text;
    final String code = _codeController.text;
    final String url =
        UrlPath.loginWithEmailCodeUrl + "?email=$email&emailCode=$code";

    try {
      final response = await DioInstance.instance().post(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          final data = response.data;

          // 保存用户信息
          Global.userInfo = User.fromJson(data["data"]);

          // 保存token
          final List<String> token = response.headers["Authorization"] as List<String>;
          Global.token = token.first;

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

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "邮箱登录",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 100),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "邮箱登录",
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
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "邮箱",
                            labelStyle: TextStyle(
                              color: _emailFocusNode.hasFocus
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
                          onPressed: _loginWithEmailCode,
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
                                  onPressed: () {
                                    RouteUtils.pushForNamed(context, RoutePath.registerCheckCodePage);
                                  },
                                  child: Text(
                                    "注册",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
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
    );
  }
}
