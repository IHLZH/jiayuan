import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

class BindEmailPage extends StatefulWidget {
  const BindEmailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BindEmailPageState();
}

class _BindEmailPageState extends State<BindEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _codeFocusNode = FocusNode();
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isSending = false;

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
    _emailFocusNode.dispose();
    _codeFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _secondsRemaining = 60;
    _timer?.cancel();
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
    if (email.isEmpty) {
      showToast("请输入邮箱地址", duration: const Duration(seconds: 1));
      return;
    }

    Global.userInfoNotifier.value!.email = "114514@qq.com";
    Navigator.pop(context, true);

    // final String url = UrlPath.getEmailCodeUrl + "?email=$email&purpose=bind";
    // _isSending = true;
    // setState(() {});

    // try {
    //   final response = await DioInstance.instance().get(path: url);
    //   if (response.statusCode == 200) {
    //     if (response.data['code'] == 200) {
    //       showToast("验证码已发送", duration: const Duration(seconds: 1));
    //       _startTimer();
    //     } else {
    //       showToast(response.data['message'],
    //           duration: const Duration(seconds: 1));
    //     }
    //   }
    // } catch (e) {
    //   showToast("发送失败，请稍后重试", duration: const Duration(seconds: 1));
    // } finally {
    //   _isSending = false;
    //   setState(() {});
    // }
  }

  Future<void> _bindEmail() async {
    final String email = _emailController.text;
    final String code = _codeController.text;

    if (email.isEmpty || code.isEmpty) {
      showToast("请填写完整信息", duration: const Duration(seconds: 1));
      return;
    }

    try {
      final response = await DioInstance.instance().post(
        path: UrlPath.bindEmailUrl,
        queryParameters: {
          "email": email,
          "emailCode": code,
        },
        options: Options(headers: {"Authorization": Global.token!}),
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast("绑定成功", duration: const Duration(seconds: 1));
          Navigator.pop(context, true);
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      }
    } catch (e) {
      showToast("绑定失败，请稍后重试", duration: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor5,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor5,
        title: Text("绑定邮箱"),
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
              TextField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: "邮箱地址",
                  labelStyle: TextStyle(
                    color: _emailFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _codeController,
                      focusNode: _codeFocusNode,
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
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: _secondsRemaining > 0 || _isSending
                          ? null
                          : _getVerificationCode,
                      child: Text(
                        _isSending
                            ? "发送中..."
                            : _secondsRemaining > 0
                                ? "${_secondsRemaining}s"
                                : "获取验证码",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _bindEmail,
                  child: Text(
                    "绑定",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
