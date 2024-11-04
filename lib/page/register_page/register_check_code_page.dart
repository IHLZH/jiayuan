import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/url_path.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';

class RegisterCheckCodePage extends StatefulWidget {
  const RegisterCheckCodePage({Key? key}) : super(key: key);

  @override
  _RegisterCheckCodePageState createState() => _RegisterCheckCodePageState();
}

class _RegisterCheckCodePageState extends State<RegisterCheckCodePage> {
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

  //获取验证码
  void _getVerificationCode() async {
    final String input =
    _isEmail ? _emailController.text : _phoneController.text;
    if (input.isEmpty) {
      showToast('邮箱/手机号不能为空', duration: Duration(seconds: 1));
      return;
    }

    // String url = UrlPath.

    _startTimer();
  }

  //TODO
  //验证码认证
  Future<void> _navigateToNextPage() async {
    final String input =
    _isEmail ? _emailController.text : _phoneController.text;
    final verificationCode = _verificationCodeController.text;
    // 检查验证码和输入是否为空
    if (input.isEmpty || verificationCode.isEmpty) {
      showToast('邮箱/手机号、验证码不能为空', duration: Duration(seconds: 1));
      return;
    }

    //TODO
    RouteUtils.pushForNamed(
      context,
      RoutePath.forgetPasswordNewPasswordPage,
      arguments: {"input": input, "isEmail": _isEmail},
    );

    // try {
    //   // 发送POST请求校验验证码
    //   final response = await DioInstance.instance().post(
    //     path: UrlPath.forgetPasswordCheckCodeUrl,
    //   );
    //
    //   // 检查校验结果
    //   if (response.statusCode == 200 && response.data['code'] == 200) {
    //     // 导航到重置密码页面
    //     RouteUtils.pushForNamed(
    //       context,
    //       RoutePath.forgetPasswordNewPasswordPage,
    //       arguments: {"input": input, "isEmail": _isEmail},
    //     );
    //   } else {
    //     // 显示错误提示
    //     showToast('验证码校验失败', duration: Duration(seconds: 1));
    //   }
    // } catch (e) {
    //   print("错误: $e");
    //   showToast('验证码校验失败', duration: Duration(seconds: 1));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      // 包裹整个页面
      child: Scaffold(
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
                        foregroundColor: _isEmail
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text('使用邮箱'),
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
                          style:
                          TextStyle(color: Theme.of(context).primaryColor))
                    else
                      ElevatedButton(
                        onPressed: _getVerificationCode,
                        child: Text('获取验证码',
                            style: TextStyle(color: Colors.white)),
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
