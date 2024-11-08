import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    void _showLogoutDialog(BuildContext context, VoidCallback onLogout) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('退出'),
            content: Text(
              '您确定要退出吗？',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('取消', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('确定', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                  onLogout();
                },
              ),
            ],
          );
        },
      );
    }

    void _logout() async {
      // 注销逻辑
      if (Global.isLogin) {
        String url = UrlPath.logoutUrl;

        try {
          final response = await DioInstance.instance().post(
            path: url,
            options: Options(headers: {"Authorization": Global.token}),
          );
          if (response.statusCode == 200) {
            if (response.data["code"] == 200) {
              showToast("注销成功", duration: Duration(seconds: 1));

              if (isProduction) print("注销");

              Global.isLogin = false;
              Global.userInfo = null;
              RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
            } else {
              showToast("注销失败", duration: Duration(seconds: 1));
            }
          } else {
            if (isProduction)
              showToast("服务器连接失败", duration: Duration(seconds: 1));
          }
        } catch (e) {
          if (isProduction) print("error $e");
        }
      } else {
        showToast("注销成功", duration: Duration(seconds: 1));

        if (isProduction) print("注销");

        Global.isLogin = false;
        RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
      }
    }

    Future<void> _jumpToProfileEditPage() async {
      if (Global.isLogin) {
        final result = await RouteUtils.pushForNamed(
          context,
          RoutePath.profileEditPage,
        );

        if (result == true) {
          setState(() {});
        }
      } else {
        showToast("请先登录", duration: Duration(seconds: 1));
      }
    }

    Widget _buildOrderStatus(String title) {
      IconData icon;
      switch (title) {
        case '未进行':
          icon = Icons.pending_outlined;
          break;
        case '进行中':
          icon = Icons.hourglass_empty;
          break;
        case '待验收':
          icon = Icons.done_all_outlined;
          break;
        case '待评价':
          icon = Icons.rate_review_outlined;
          break;
        default:
          icon = Icons.circle;
      }
      // return Material(
      //   color: Colors.transparent, // 确保背景透明
      //   child: SafeArea(
      //     child: InkWell(
      //       onTap: () {},
      //       splashColor: Theme.of(context).primaryColor.withAlpha(30),
      //       highlightColor: Theme.of(context).primaryColor.withAlpha(30),
      //       // 设置水波纹为圆形
      //       customBorder: const CircleBorder(),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(icon, size: 35, color: Theme.of(context).primaryColor),
      //           SizedBox(height: 8),
      //           Text("$title", style: TextStyle(fontSize: 14)),
      //         ],
      //       ),
      //     ),
      //   ),
      // );
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: InkWell(
            onTap: () {},
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            highlightColor: Theme.of(context).primaryColor.withAlpha(30),
            customBorder: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        AppColors.endColor,
                      ],
                    ).createShader(bounds);
                  },
                  child: Icon(icon, size: 35, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text("$title", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    // 标题
    Widget _buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Expanded(child: SizedBox()),
            TextButton(
              onPressed: () {
                if (title == "服务订单") {
                  //TODO
                } else {
                  //TODO
                }
              },
              child: Text(
                '更多',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    // 管理选项
    Widget _buildManagementOption(IconData icon, String title) {
      // return Material(
      //   color: Colors.transparent, // 确保背景透明
      //   child: SafeArea(
      //     child: InkWell(
      //       onTap: () {},
      //       splashColor: Theme.of(context).primaryColor.withAlpha(30),
      //       highlightColor: Theme.of(context).primaryColor.withAlpha(30),
      //       // 设置水波纹为圆形
      //       customBorder: const CircleBorder(),
      //       child: Column(
      //         children: [
      //           Icon(icon, color: Theme.of(context).primaryColor, size: 35),
      //           SizedBox(height: 8),
      //           Text(title, style: TextStyle(fontSize: 14)),
      //         ],
      //       ),
      //     ),
      //   ),
      // );
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: InkWell(
            onTap: () {},
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            highlightColor: Theme.of(context).primaryColor.withAlpha(30),
            customBorder: const CircleBorder(),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        AppColors.endColor,
                      ],
                    ).createShader(bounds);
                  },
                  child: Icon(icon, size: 35, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(title, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      );
    }

    // Widget _buildOption(IconData icon, String title, {VoidCallback? onCheck}) {
    //   return Material(
    //     color: Colors.transparent,
    //     child: InkWell(
    //       onTap: () {
    //         if (icon == Icons.logout && onCheck != null) {
    //           _showLogoutDialog(context, onCheck);
    //         } else {
    //           // 其他选项的点击事件处理
    //         }
    //       },
    //       // 水波纹颜色
    //       splashColor: Colors.grey[300],
    //       // 高亮颜色
    //       highlightColor: Theme.of(context).primaryColor.withAlpha(30),
    //       child: ListTile(
    //         leading: Icon(icon,
    //             color: icon == Icons.logout
    //                 ? Colors.red
    //                 : Theme.of(context).primaryColor),
    //         title: Text(title,
    //             style: TextStyle(
    //                 color: icon == Icons.logout ? Colors.red : Colors.black)),
    //         trailing: Icon(Icons.arrow_forward_ios, size: 16),
    //       ),
    //     ),
    //   );
    // }

    Widget _buildOption(IconData icon, String title, {VoidCallback? onCheck}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (icon == Icons.logout && onCheck != null) {
              _showLogoutDialog(context, onCheck);
            } else {
              // 其他选项的点击事件处理
            }
          },
          splashColor: Colors.grey[300],
          highlightColor: Theme.of(context).primaryColor.withAlpha(30),
          child: ListTile(
            leading: icon == Icons.logout
                ? Icon(icon, color: Colors.red)
                : ShaderMask(
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
              style: TextStyle(
                  color: icon == Icons.logout ? Colors.red : Colors.black),
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 用户信息头部
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    children: [
                      //头像
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            const AssetImage('assets/images/ikun1.png'),
                      ),
                      SizedBox(width: 16),

                      // 修改昵称显示部分
                      Container(
                        width: 200.w,
                        child: ValueListenableBuilder<User?>(
                          valueListenable: Global.userInfoNotifier,
                          builder: (context, userInfo, child) {
                            return ShaderMask(
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
                              child: Text(
                                userInfo?.nickName ?? '未命名',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Expanded(child: SizedBox()),
                      //个人信息修改
                      Material(
                        color: Colors.transparent, // 确保背景透明
                        child: ClipOval(
                          child: InkWell(
                            onTap: () => _jumpToProfileEditPage(),
                            // 水波纹颜色
                            splashColor:
                                Theme.of(context).primaryColor.withAlpha(30),
                            // 高亮颜色
                            highlightColor:
                                Theme.of(context).primaryColor.withAlpha(30),
                            // 设置水波纹为圆形
                            customBorder: CircleBorder(),
                            child: Icon(Icons.chevron_right_outlined, size: 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                height: 150.h,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Column(
                  children: [
                    _buildSectionTitle('服务订单'),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Divider(),
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildOrderStatus('未进行'),
                          _buildOrderStatus('进行中'),
                          _buildOrderStatus('待验收'),
                          _buildOrderStatus('待评价'),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Container(
                height: 150,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey, width: 1.w),
                ),
                child: Column(
                  children: [
                    _buildSectionTitle('家政管理'),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Divider(),
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildManagementOption(Icons.person_add, '成为家政员'),
                          _buildManagementOption(Icons.edit, '修改信息'),
                          _buildManagementOption(Icons.assignment, '委托中心'),
                          _buildManagementOption(Icons.verified_user, '证书认证'),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

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
                  border: Border.all(color: Colors.grey, width: 1.w),
                ),
                child: Column(
                  children: [
                    _buildOption(Icons.favorite_border, '我的收藏'),
                    _line(),
                    _buildOption(Icons.history, '浏览历史'),
                    _line(),
                    _buildOption(Icons.help_outline, '常见问题'),
                    _line(),
                    _buildOption(Icons.settings, '设置'),
                    _line(),
                    _buildOption(Icons.logout, '退出登录', onCheck: _logout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
