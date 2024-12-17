import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {

    Future<void> _jumpToChangeEmailPage() async {
      RouteUtils.pushForNamed(context, RoutePath.changeEmailPage);
    }

    Future<void> _jumpToChangePhonePage() async {
      RouteUtils.pushForNamed(context, RoutePath.changePhonePage);
    }

    Future<void> _jumpToChangePasswordPage() async {
      RouteUtils.pushForNamed(context, RoutePath.changePasswordPage);
    }

    Future<void> _jumpToBackendPage() async {
      RouteUtils.pushForNamed(context, RoutePath.webViewPage, arguments: {'url': Constants.BACKEND_URL});
    }

    Widget _buildOption(IconData icon, String title) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            switch (title) {
              case '邮箱地址':
                _jumpToChangeEmailPage();
                break;
              case '手机号码':
                _jumpToChangePhonePage();
                break;
              case '修改密码':
                _jumpToChangePasswordPage();
                break;
              case '进入后台':
                _jumpToBackendPage();
                break;
              default:
                break;
            }
          },
          splashColor: Colors.grey[300],
          highlightColor: Theme.of(context).primaryColor.withAlpha(30),
          child: ListTile(
            leading: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    AppColors.appColor,
                  ],
                ).createShader(bounds);
              },
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      );
    }

    Widget _line() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.r),
        child: Divider(
          height: 2.h,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 使用 Container 包裹 AppBar 以实现渐变背景
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                AppColors.endDeepColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text('设置',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            RouteUtils.pop(context);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor5,
        ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.r),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                      border: Border.all(color: Colors.grey, width: 0.1.w),
                    ),
                    child: Column(
                      children: [
                        _buildOption(Icons.email_outlined, '邮箱地址'),
                        _line(),
                        _buildOption(Icons.phone, '手机号码'),
                        _line(),
                        _buildOption(Icons.lock, '修改密码'),
                        if(Global.userInfo!.userId==1||Global.userInfo!.userId==19)...[
                          _line(),
                          _buildOption(Icons.web_stories, '进入后台'),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
