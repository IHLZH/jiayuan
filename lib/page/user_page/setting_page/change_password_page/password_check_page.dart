import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../common_ui/styles/app_colors.dart';
import '../../../../http/dio_instance.dart';
import '../../../../http/url_path.dart';
import '../../../../route/route_path.dart';
import '../../../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class PasswordCheckPage extends StatefulWidget {
  const PasswordCheckPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordCheckPageState();
}

class _PasswordCheckPageState extends State<PasswordCheckPage> {
  final TextEditingController _emailController =
      TextEditingController(text: Global.userInfo!.email ?? "未绑定");
  final TextEditingController _phoneController =
      TextEditingController(text: Global.userInfo!.userPhoneNumber ?? "未绑定");
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _verificationCodeFocusNode = FocusNode();

  bool _isEmail = true;
  int _secondsRemaining = 0;
  Timer? _timer;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _phoneFocusNode.addListener(_onFocusChange);
    _verificationCodeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _phoneFocusNode.removeListener(_onFocusChange);
    _verificationCodeFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _verificationCodeFocusNode.dispose();
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

  void _jumpToNext(String input) {
    if (isProduction) print("input: $input");
    final res = RouteUtils.pushForNamed(
      context,
      RoutePath.resetPasswordPage,
      arguments: {"input": input},
    );

    if (res == "true") {
      RouteUtils.pop(context);
    }
  }

  // 获取验证码
  void _getVerificationCode() async {
    final String input =
        _isEmail ? _emailController.text : _phoneController.text;
    if (input.isEmpty) {
      showToast('邮箱/手机号不能为空', duration: Duration(seconds: 1));
      return;
    }
    String url = _isEmail
        ? UrlPath.getEmailCodeUrl + "?email=$input&purpose=forget"
        : UrlPath.getPhoneCodeUrl + "?phone=$input&purpose=forget";

    _isSending = true;

    try {
      final response = await DioInstance.instance().get(
        path: url,
        options: Options(headers: {"Authorization": Global.token!}),
      );
      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          // 验证码发送成功，计时
          showToast('验证码已发送', duration: Duration(seconds: 1));
          _isSending = false;
          _startTimer();
        } else {
          showToast(response.data['message'], duration: Duration(seconds: 1));
          _isSending = false;
          _secondsRemaining = 0;
        }
      } else {
        showToast("无法连接服务器", duration: Duration(seconds: 1));
        _isSending = false;
        _secondsRemaining = 0;
      }
    } catch (e) {
      if (isProduction) print("error: $e");
      showToast("系统异常", duration: Duration(seconds: 1));
      _isSending = false;
      _secondsRemaining = 0;
    }
  }

  //验证码认证
  Future<void> _navigateToNextPage() async {
    final String input =
        _isEmail ? _emailController.text : _phoneController.text;
    final verificationCode = _verificationCodeController.text;
    // 检查验证码和输入是否为空
    if (input.isEmpty || verificationCode.isEmpty) {
      showToast('输入的手机号/邮箱、验证码不能为空', duration: Duration(seconds: 1));
      return;
    }
    String url = _isEmail
        ? UrlPath.checkPasswordEmailCodeUrl +
            "?email=$input&emailCode=$verificationCode"
        : UrlPath.checkPasswordPhoneCodeUrl +
            "?phone=$input&smsCode=$verificationCode";

    try {
      final response = await DioInstance.instance().post(
        path: url,
        options: Options(headers: {"Authorization": Global.token!}),
      );
      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          showToast("验证码正确", duration: Duration(seconds: 1));
          _jumpToNext(input);
        } else {
          showToast(response.data["message"], duration: Duration(seconds: 1));
          if (isProduction) print("error: ${response.data["message"]}");
        }
      } else {
        showToast(response.data["message"], duration: Duration(seconds: 1));
        if (isProduction) print("error: ${response.data["message"]}");
      }
    } catch (e) {
      print("error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      // 包裹整个页面
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor5,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor5,
          title: Text("修改密码"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _toggleInputType(true),
                      style: TextButton.styleFrom(
                        foregroundColor: _isEmail
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        '使用邮箱',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _toggleInputType(false),
                      style: TextButton.styleFrom(
                        foregroundColor: !_isEmail
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        '使用手机号',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                if (_isEmail)
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "邮箱",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                if (!_isEmail)
                  TextField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "手机号",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
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
                    Container(
                      height: 65,
                      child: Center(
                        child: TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10.0), // 设置小幅度的圆角
                              ),
                            ),
                          ),
                          onPressed: _secondsRemaining > 0 || _isSending
                              ? null
                              : _getVerificationCode,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              _isSending
                                  ? "发送中..."
                                  : _secondsRemaining > 0
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
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: _navigateToNextPage,
                  child: Text('下一步',
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
      ),
    );
  }
}
