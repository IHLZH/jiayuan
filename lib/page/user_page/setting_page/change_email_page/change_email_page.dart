import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/utils/global.dart';

import '../../../../utils/constants.dart';

bool isProduction = Constants.IS_Production;

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  @override
  Widget build(BuildContext context) {
    return switch (Global.userInfo!.email) {
      //邮箱为空时
      null => Scaffold(
          backgroundColor: AppColors.backgroundColor5,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("邮箱地址"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 100, color: Colors.blue[300]),
                  SizedBox(height: 20),
                  Text(
                    "当前邮箱未绑定",
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit, color: AppColors.blackColor333),
                    label: Text("绑定",
                        style: TextStyle(color: AppColors.blackColor333)),
                    onPressed: () {
                      // 处理更换邮箱地址的逻辑
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 修改为方形带圆角
                        side: BorderSide(
                            color: AppColors.backgroundColor5, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      // 邮箱不为空时
      _ => Scaffold(
          backgroundColor: AppColors.backgroundColor5,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("邮箱地址"),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.center,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 100, color: Colors.blue[300]),
                  SizedBox(height: 20),
                  Text(
                    "你的邮箱地址:${Global.userInfo!.email}",
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit, color: AppColors.blackColor333),
                    label: Text("更换",
                        style: TextStyle(color: AppColors.blackColor333)),
                    onPressed: () {
                      // 处理更换邮箱地址的逻辑
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 修改为方形带圆角
                        side: BorderSide(
                            color: AppColors.backgroundColor5, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    };
  }
}
