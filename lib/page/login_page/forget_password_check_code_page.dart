import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/login_page/email_login_page.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../common_ui/styles/app_colors.dart'; // 引入oktoast包

class ForgetPasswordCheckCodePage extends StatefulWidget {
  const ForgetPasswordCheckCodePage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordCheckCodePageState createState() =>
      _ForgetPasswordCheckCodePageState();
}

class _ForgetPasswordCheckCodePageState
    extends State<ForgetPasswordCheckCodePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
    RouteUtils.pushForNamed(
      context,
      RoutePath.forgetPasswordNewPasswordPage,
      arguments: {"input": input, "isEmail": _isEmail},
    );
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
      final response = await DioInstance.instance().get(path: url);
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
      final response = await DioInstance.instance().post(path: url);
      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          // showToast("验证码正确", duration: Duration(seconds: 1));
          _jumpToNext(input);
        } else {
          showToast(response.data["message"], duration: Duration(seconds: 1));
        }
      } else {
        showToast(response.data["message"], duration: Duration(seconds: 1));
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
        backgroundColor: AppColors.backgroundColor2,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor2,
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
            "忘记密码",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.only(top: 40.h),
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              children: [
                Image(image: AssetImage("assets/images/ikun1.png")),
                SizedBox(height: 10.h),
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
