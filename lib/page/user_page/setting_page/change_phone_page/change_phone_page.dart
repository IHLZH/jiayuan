import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/utils/global.dart';

import '../../../../route/route_path.dart';
import '../../../../route/route_utils.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePhonePageState();
}

class _ChangePhonePageState extends State<ChangePhonePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Global.userInfoNotifier,
      builder: (context, userInfo, child) {
        return switch (userInfo?.userPhoneNumber) {
          //手机号为空时
          null || '' => Scaffold(
              backgroundColor: AppColors.backgroundColor5,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text("手机号码"),
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
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android,
                          size: 100, color: Colors.blue[300]),
                      SizedBox(height: 20),
                      Text(
                        "当前手机号未绑定",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      OutlinedButton.icon(
                        icon: Icon(Icons.edit, color: AppColors.blackColor333),
                        label: Text("绑定",
                            style: TextStyle(color: AppColors.blackColor333)),
                        onPressed: () async {
                          final res = await RouteUtils.pushForNamed(
                              context, RoutePath.bindPhonePage);
                          if (res == true) {
                            Global.userInfoNotifier.notifyListeners();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: AppColors.backgroundColor5, width: 2),
                          ),
                          overlayColor: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 手机号不为空时
          _ => Scaffold(
              backgroundColor: AppColors.backgroundColor5,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text("手机号码"),
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
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android,
                          size: 100, color: Colors.blue[300]),
                      SizedBox(height: 20),
                      Text(
                        "你的手机号码:${Global.userInfoNotifier.value!.userPhoneNumber}",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      OutlinedButton.icon(
                        icon: Icon(Icons.edit, color: AppColors.blackColor333),
                        label: Text("更换",
                            style: TextStyle(color: AppColors.blackColor333)),
                        onPressed: () async {
                          final res = await RouteUtils.pushForNamed(
                              context, RoutePath.checkPhonePage);
                          if (res == true) {
                            Global.userInfoNotifier.notifyListeners();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: AppColors.backgroundColor5, width: 2),
                          ),
                          overlayColor: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}
