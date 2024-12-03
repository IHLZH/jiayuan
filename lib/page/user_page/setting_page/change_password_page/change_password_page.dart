import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../repository/model/user.dart';
import '../../../../route/route_path.dart';
import '../../../../route/route_utils.dart';
import '../../../../utils/sp_utils.dart';

bool isProduction = Constants.IS_Production;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordFocusNode.addListener(_onFocusChange);
    _newPasswordFocusNode.addListener(_onFocusChange);
    _confirmPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _oldPasswordFocusNode.removeListener(_onFocusChange);
    _newPasswordFocusNode.removeListener(_onFocusChange);
    _confirmPasswordFocusNode.removeListener(_onFocusChange);
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Future<void> _changePassword() async {
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showToast("请填写完整信息", duration: const Duration(seconds: 1));
      return;
    }

    if (newPassword != confirmPassword) {
      showToast("新密码和确认密码不一致", duration: const Duration(seconds: 1));
      return;
    }

    _isSubmitting = true;
    setState(() {});

    try {
      final response = await DioInstance.instance().put(
        path: UrlPath.updatePasswordUrl,
        queryParameters: {
          "old": oldPassword,
          "new": newPassword,
        },
        options: Options(headers: {"Authorization": Global.token!}),
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast("密码修改成功", duration: const Duration(seconds: 1));

          Global.userInfoNotifier.value = User.fromJson(response.data['data']);
          Global.password = newPassword;

          // 保存token
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;

          //持久化
          await SpUtils.saveString("password", Global.password!);
          await SpUtils.saveString("token", Global.token!);

          Navigator.pop(context, true);
        } else {
          showToast(response.data['message'],
              duration: const Duration(seconds: 1));
        }
      }
    } catch (e) {
      showToast("修改失败，请稍后重试", duration: const Duration(seconds: 1));
      if (isProduction) print("Error: $e");
    } finally {
      _isSubmitting = false;
      setState(() {});
    }
  }

  void _navigateToPasswordCheckPage() {
    RouteUtils.pushForNamed(
      context,
      RoutePath.passwordCheckPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              TextField(
                controller: _oldPasswordController,
                focusNode: _oldPasswordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "旧密码",
                  labelStyle: TextStyle(
                    color: _oldPasswordFocusNode.hasFocus
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
              TextField(
                controller: _newPasswordController,
                focusNode: _newPasswordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "新密码",
                  labelStyle: TextStyle(
                    color: _newPasswordFocusNode.hasFocus
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
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _changePassword,
                  child: Text(
                    _isSubmitting ? "提交中..." : "提交",
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                TextButton(
                  onPressed: _navigateToPasswordCheckPage,
                  child: Text(
                    "验证码修改密码",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],),
            ],
          ),
        ),
      ),
    );
  }
}
