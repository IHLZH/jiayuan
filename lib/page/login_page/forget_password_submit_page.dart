import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:oktoast/oktoast.dart';

class ForgetPasswordSubmitPage extends StatefulWidget {
  final String input;
  final bool isEmail;

  const ForgetPasswordSubmitPage(
      {Key? key, required this.input, required this.isEmail})
      : super(key: key);

  @override
  _ForgetPasswordSubmitPageState createState() =>
      _ForgetPasswordSubmitPageState();
}

class _ForgetPasswordSubmitPageState extends State<ForgetPasswordSubmitPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _resetPassword() async {
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('两次输入的密码不一致')),
      );
      return;
    }

    String url = UrlPath.resetPasswordUrl +
        "?countId=${widget.input}&password=$password&confirmPassword=$confirmPassword";

    try {
      final response = await DioInstance.instance().post(path: url);

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast(response.data['message'], duration: Duration(seconds: 1));
          RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
        } else {
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        showToast("连接不到服务器", duration: Duration(seconds: 1));
      }
    } catch (e) {
      // 如果失败，显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('异常，请稍后再试')),
      );
      print("error : $e");
    }
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
          "新密码确认",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            children: [
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
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
