import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordSubmitPage extends StatefulWidget {
  final String input;
  final bool isEmail;

  const ForgetPasswordSubmitPage({Key? key, required this.input, required this.isEmail}) : super(key: key);

  @override
  _ForgetPasswordSubmitPageState createState() => _ForgetPasswordSubmitPageState();
}

class _ForgetPasswordSubmitPageState extends State<ForgetPasswordSubmitPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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

    try {
      // 假设你有一个 API 来处理密码重置
      // await DioInstance.instance().post(
      //   path: UrlPath.resetPasswordUrl,
      //   data: {
      //     'emailOrPhone': widget.isEmail ? widget.input : widget.input,
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
        title: Text('重置密码'),
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
                child: Text('更改密码', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
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
