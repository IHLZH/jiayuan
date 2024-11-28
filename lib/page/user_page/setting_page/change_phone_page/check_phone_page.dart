import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

bool isProduction = Constants.IS_Production;

class CheckPhonePage extends StatefulWidget {
  const CheckPhonePage({Key? key}) : super(key: key);

  @override
  _CheckPhonePageState createState() => _CheckPhonePageState();
}

class _CheckPhonePageState extends State<CheckPhonePage> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  int _secondsRemaining = 0;
  Timer? _timer;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _codeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _codeFocusNode.removeListener(_onFocusChange);
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
    final String phone = Global.userInfoNotifier.value!.userPhoneNumber!;

    final String url = UrlPath.getPhoneCodeUrl + "?phone=$phone";
    _isSending = true;
    setState(() {});

    try {
      final response = await DioInstance.instance().get(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast("验证码已发送", duration: const Duration(seconds: 1));
          _startTimer();
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      }
    } catch (e) {
      showToast("发送失败，请稍后重试", duration: const Duration(seconds: 1));
    } finally {
      _isSending = false;
      setState(() {});
    }
  }

  Future<void> _verifyCode() async {
    final String code = _codeController.text;
    final String phone = Global.userInfoNotifier.value!.userPhoneNumber!;

    if (code.isEmpty) {
      showToast("请输入验证码", duration: const Duration(seconds: 1));
      return;
    }

    try {
      final response = await DioInstance.instance().post(
        path: UrlPath.verifyPhoneUrl,
        queryParameters: {
          "phone": phone,
          "smsCode": code,
        },
        options: Options(headers: {"Authorization": Global.token!}),
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast("验证成功", duration: const Duration(seconds: 1));
          // 验证成功后跳转到绑定新手机号页面
          RouteUtils.pushForNamed(context, RoutePath.bindPhonePage);
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      }
    } catch (e) {
      showToast("验证失败，请稍后重试", duration: const Duration(seconds: 1));
      if(isProduction)print("error ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor5,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("验证手机号"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.all(20),
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
                children: [
                  Text(
                    "当前手机号：${Global.userInfoNotifier.value!.userPhoneNumber}",
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).primaryColor),
                  ),
                ],
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
                  onPressed: _verifyCode,
                  child: Text(
                    "验证",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
