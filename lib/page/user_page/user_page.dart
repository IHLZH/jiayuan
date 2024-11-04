import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/utils/constants.dart';

import '../../route/route_path.dart';
import '../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class UserPage extends StatefulWidget{
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Center(
        child: _buildLogoutButton(context),
      ),
    );
  }

  // 构建注销按钮
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Card(
        color: Colors.red[100],
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
              child: Text("取消"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 执行注销操作逻辑
                if(isProduction)print("注销");
                RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
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
