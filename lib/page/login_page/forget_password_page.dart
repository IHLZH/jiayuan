import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationCodeController =
  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _verificationCodeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isEmail = true;
  int _secondsRemaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _phoneFocusNode.addListener(_onFocusChange);
    _verificationCodeFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _confirmPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _phoneFocusNode.removeListener(_onFocusChange);
    _verificationCodeFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _confirmPasswordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _verificationCodeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _toggleInputType(bool isEmail) {
    setState(() {
      _isEmail = isEmail;
    });
  }

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _secondsRemaining = 60;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  //TODO
  void _getVerificationCode() async {
    if (_isEmail) {
      final String email = _emailController.text;
      // 发送验证码到邮箱
      // await DioInstance.instance().post(
      //   path: UrlPath.sendVerificationCodeByEmailUrl,
      //   data: {'email': email},
      // );
    } else {
      final String phone = _phoneController.text;
      // 发送验证码到手机号
      // await DioInstance.instance().post(
      //   path: UrlPath.sendVerificationCodeByPhoneUrl,
      //   data: {'phone': phone},
      // );
    }
    _startTimer();
  }

  void _resetPassword() async {
    final String verificationCode = _verificationCodeController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('两次输入的密码不一致')),
      );
      return;
    }

    //TODO
    try {
      // 假设你有一个 API 来处理密码重置
      // await DioInstance.instance().post(
      //   path: UrlPath.resetPasswordUrl,
      //   data: {
      //     'emailOrPhone': _isEmail ? _emailController.text : _phoneController.text,
      //     'verificationCode': verificationCode,
      //     'password': password,
      //   },
      // );

      // 如果成功，显示一个消息提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('密码已重置，请登录')),
      );
    } catch (e) {
      // 如果失败，显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('重置密码失败，请稍后再试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('忘记密码'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _toggleInputType(true),
                    style: TextButton.styleFrom(
                      foregroundColor: _isEmail ? Theme.of(context).primaryColor : Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text('使用邮箱'),
                  ),
                  TextButton(
                    onPressed: () => _toggleInputType(false),
                    style: TextButton.styleFrom(
                      foregroundColor: !_isEmail ? Theme.of(context).primaryColor : Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text('使用手机号'),
                  ),

                ],
              ),
              SizedBox(height: 20.h),
              if (_isEmail)
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    labelText: "邮箱",
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              if (!_isEmail)
                TextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  decoration: InputDecoration(
                    labelText: "手机号",
                    labelStyle: TextStyle(
                      color: _phoneFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _verificationCodeController,
                      focusNode: _verificationCodeFocusNode,
                      decoration: InputDecoration(
                        labelText: "验证码",
                        labelStyle: TextStyle(
                          color: _verificationCodeFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  if (_secondsRemaining > 0)
                    Text('$_secondsRemaining s',
                        style: TextStyle(color: Theme.of(context).primaryColor))
                  else
                    ElevatedButton(
                      onPressed: _getVerificationCode,
                      child:
                      Text('获取验证码', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "新密码",
                  labelStyle: TextStyle(
                    color: _passwordFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "确认新密码",
                  labelStyle: TextStyle(
                    color: _confirmPasswordFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('更改密码',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                  EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
