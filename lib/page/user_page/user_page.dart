import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/url_path.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class UserPage extends StatefulWidget{
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),//禁止滑动
      children: [
        Row(),
        SizedBox(height: 20.h),
        Row(),
        SizedBox(height: 20.h),
        Row(),
        _buildLogoutButton(context),
      ],
    );
  }

  void _logout() async{
    String url = UrlPath.logoutUrl;

    try{
      final response = await DioInstance.instance().post(path: url,options: Options(headers: {"Authorization": Global.token}));
      if(response.statusCode == 200){
        if(response.data["code"]==200){
          showToast("注销成功",duration: Duration(seconds: 1));

          if(isProduction)print("注销");
          RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
        }
        else{
          showToast("注销失败",duration: Duration(seconds: 1));
        }
      }else{
        if(isProduction)showToast("服务器连接失败",duration: Duration(seconds: 1));
      }
    }catch(e){
      if(isProduction)print("error $e");
    }
  }

  // 构建注销按钮
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text(
            "注销",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
    );
  }

  // 注销确认对话框
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("确认注销"),
          content: Text("您确定要退出登录吗？"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消",style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 执行注销操作逻辑
                _logout();
              },
              child: Text(
                "确认",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
