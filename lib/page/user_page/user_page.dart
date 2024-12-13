import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';

import '../../common_ui/floating_support_ball/floating_support_ball.dart';
import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../im/im_chat_api.dart';
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

    void logout() async {
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
              if (isProduction) print("注销");

              Global.isLogin = false;
              Global.password = null;
              Global.userInfoNotifier.value = null;
              Global.keeperInfoNotifier.value = null;

              //IM注销登录
              await ImChatApi.getInstance().logout();

              showToast("退出登录", duration: Duration(seconds: 1));

              await SpUtils.saveString("password", "");

              RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
            } else {
              showToast("退出登录失败 ${response.data['message']}",
                  duration: Duration(seconds: 1));
            }
          } else {
            if (isProduction)
              showToast("服务器连接失败", duration: Duration(seconds: 1));
          }
        } catch (e) {
          if (isProduction) print("error $e");
        }
      } else {
        showToast("退出登录成功", duration: Duration(seconds: 1));

        if (isProduction) print("退出登录");

        Global.isLogin = false;

        RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
      }
    }

    Future<void> _jumpToProfileEditPage() async {
      if (false) {
        final result = await RouteUtils.pushForNamed(
          context,
          RoutePath.profileEditPage,
        );

        if (result == true) {
          setState(() {});
        }
      } else {
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
    }

    // 委托中心
    Future<void> _jumpToCommissionCenterPage() async {
      if (isProduction)
        RouteUtils.pushForNamed(context, RoutePath.commissionCenter);
      else {
        switch (Global.userInfoNotifier.value!.userType) {
          case 0:
            showToast("请先成为家政员", duration: Duration(seconds: 1));
            break;
          case 1:
            RouteUtils.pushForNamed(context, RoutePath.commissionCenter);
            break;
        }
      }
    }

    // 设置
    Future<void> _jumpToSettingPage() async {
      RouteUtils.pushForNamed(context, RoutePath.settingPage);
    }

    // 成为家政员
    Future<void> _jumpToKeeperCertified() async {
      RouteUtils.pushForNamed(context, RoutePath.keeperCertified);
    }

    // 证书认证
    Future<void> _jumpToCertCertified() async {
      RouteUtils.pushForNamed(context, RoutePath.certCertified);
    }

    // 订单
    Future<void> _jumpToOrderPage(int status) async {
      RouteUtils.pushForNamed(context, RoutePath.orderPage,
          arguments: {"status": status});
    }

    //已接订单
    Future<void> _jumpToComissionOrderPage() async {
      RouteUtils.pushForNamed(context, RoutePath.centerOrder);
    }

    // 水平图标1.0
    // Widget _buildOrderStatus(String title) {
    //   IconData icon;
    //   switch (title) {
    //     case '待接取':
    //       icon = Icons.pending_outlined;
    //       break;
    //     case '服务中':
    //       icon = Icons.hourglass_empty;
    //       break;
    //     case '待支付':
    //       icon = Icons.done_all_outlined;
    //       break;
    //     case '已完成':
    //       icon = Icons.rate_review_outlined;
    //       break;
    //     default:
    //       icon = Icons.circle;
    //   }
    //   // return Material(
    //   //   color: Colors.transparent, // 确保背景透明
    //   //   child: SafeArea(
    //   //     child: InkWell(
    //   //       onTap: () {},
    //   //       splashColor: Theme.of(context).primaryColor.withAlpha(30),
    //   //       highlightColor: Theme.of(context).primaryColor.withAlpha(30),
    //   //       // 设置水波纹为圆形
    //   //       customBorder: const CircleBorder(),
    //   //       child: Column(
    //   //         mainAxisAlignment: MainAxisAlignment.center,
    //   //         children: [
    //   //           Icon(icon, size: 35, color: Theme.of(context).primaryColor),
    //   //           SizedBox(height: 8),
    //   //           Text("$title", style: TextStyle(fontSize: 14)),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //   ),
    //   // );
    //   return Material(
    //     color: Colors.transparent,
    //     child: SafeArea(
    //       child: InkWell(
    //         onTap: () {},
    //         splashColor: Theme.of(context).primaryColor.withAlpha(30),
    //         highlightColor: Theme.of(context).primaryColor.withAlpha(30),
    //         customBorder: const CircleBorder(),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             ShaderMask(
    //               shaderCallback: (Rect bounds) {
    //                 return LinearGradient(
    //                   begin: Alignment.topLeft,
    //                   end: Alignment.bottomRight,
    //                   colors: [
    //                     Theme.of(context).primaryColor,
    //                     AppColors.appColor,
    //                     AppColors.endDeepColor,
    //                   ],
    //                 ).createShader(bounds);
    //               },
    //               child: Icon(icon, size: 35, color: Colors.white),
    //             ),
    //             SizedBox(height: 8),
    //             Text("$title", style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold)),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // 标题
    Widget _buildSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold),
            ),
            Expanded(child: SizedBox()),
            TextButton(
              onPressed: () {
                if (title == "服务订单") {
                  _jumpToOrderPage(-1);
                } else {
                  _jumpToCommissionCenterPage();
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

    // 水平图标2.0
    Widget _buildManagementOption(IconData icon, String title) {
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: InkWell(
            onTap: () {
              if (title == '待接取') {
                _jumpToOrderPage(0);
              } else if (title == '待确认') {
                _jumpToOrderPage(1);
              } else if (title == '待服务') {
                _jumpToOrderPage(2);
              } else if (title == '服务中') {
                _jumpToOrderPage(3);
              } else if (title == '待支付') {
                _jumpToOrderPage(4);
              } else if (title == '已完成') {
                _jumpToOrderPage(5);
              } else if (title == '成为家政员') {
                _jumpToKeeperCertified();
              } else if (title == '已接订单') {
                _jumpToComissionOrderPage();
              } else if (title == '服务中心') {
                _jumpToCommissionCenterPage();
              } else if (title == '证书认证') {
                _jumpToCertCertified();
              }
            },
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            highlightColor: Theme.of(context).primaryColor.withAlpha(30),
            customBorder: const CircleBorder(),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        AppColors.appColor,
                        AppColors.endDeepColor,
                      ],
                    ).createShader(bounds);
                  },
                  child: Icon(icon, size: 35, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(title,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
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

    //点击导航栏2.0
    Widget _buildOption(IconData icon, String title, {VoidCallback? onCheck}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (icon == Icons.logout && onCheck != null) {
              _showLogoutDialog(context, onCheck);
            } else if (icon == Icons.settings) {
              _jumpToSettingPage();
            } else if (icon == Icons.favorite_border) {
              RouteUtils.pushForNamed(context, RoutePath.keeperCollection);
              // 其他选项的点击事件处理
            } else if (icon == Icons.history) {
              RouteUtils.pushForNamed(context, RoutePath.browseHistoryPage);
            }
          },
          // 水波纹颜色
          splashColor: Colors.grey[300],
          // 高亮颜色
          highlightColor: Colors.grey[300],
          child: ListTile(
            leading: icon == Icons.logout
                ? Icon(icon, color: Colors.red)
                : ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          AppColors.appColor,
                          AppColors.endDeepColor,
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
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor4.withOpacity(0.6),
        toolbarHeight: 10.h,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 用户信息头部
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.backgroundColor4.withOpacity(0.6),
                            Colors.white.withOpacity(0.3),
                          ], // 自定义渐变颜色
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //头像
                              Container(
                                child: ValueListenableBuilder<User?>(
                                    valueListenable: Global.userInfoNotifier,
                                    builder: (context, userInfo, child) {
                                      if (isProduction)
                                        print(
                                            "ValueListenableBuilder重建: ${userInfo?.userAvatar}"); // 调试信息
                                      if (userInfo == null) {
                                        return CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                              'assets/images/ikun1.png'),
                                        );
                                      }

                                      return CircleAvatar(
                                          radius: 40,
                                          backgroundImage: userInfo
                                                          ?.userAvatar !=
                                                      null &&
                                                  userInfo.userAvatar != "默认头像"
                                              ? CachedNetworkImageProvider(
                                                  userInfo.userAvatar!)
                                              : AssetImage(
                                                  'assets/images/ikun1.png'));
                                    }),
                              ),
                              SizedBox(width: 16),

                              // 修改昵称显示部分
                              Container(
                                width: 150.w,
                                child: SafeArea(
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
                                              // AppColors.endDeepColor,
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
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                                    splashColor: Colors.grey[300],
                                    // 高亮颜色
                                    highlightColor: Colors.grey[300],
                                    // 设置水波纹为圆形
                                    customBorder: CircleBorder(),
                                    child: Icon(Icons.chevron_right_outlined,
                                        size: 40),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                  //水平图标2.0
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
                      border: Border.all(color: Colors.grey, width: 0.1.w),
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
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildManagementOption(
                                  Icons.pending_outlined, '待接取'),
                              _buildManagementOption(
                                  Icons.check_box_outlined, '待确认'),
                              _buildManagementOption(
                                  Icons.monetization_on_outlined, '待支付'),
                              _buildManagementOption(
                                  Icons.done_all_outlined, '已完成'),
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),

                  //水平图标1.0
                  // Container(
                  //   height: 150.h,
                  //   margin: EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10.0),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.5),
                  //         spreadRadius: 0,
                  //         blurRadius: 2,
                  //         offset: Offset(0, 1),
                  //       ),
                  //     ],
                  //     border: Border.all(color: Colors.grey, width: 1.0),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       _buildSectionTitle('服务订单'),
                  //       Container(
                  //         margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  //         child: Divider(),
                  //       ),
                  //       Expanded(child: SizedBox()),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           children: [
                  //             // _buildOrderStatus('待接取'),
                  //             // _buildOrderStatus('服务中'),
                  //             // _buildOrderStatus('待支付'),
                  //             // _buildOrderStatus('已完成'),
                  //
                  //
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(child: SizedBox()),
                  //     ],
                  //   ),
                  // ),

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
                      border: Border.all(color: Colors.grey, width: 0.1.w),
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
                              _buildManagementOption(Icons.assignment, '已接订单'),
                              _buildManagementOption(
                                  Icons.format_align_center_outlined, '服务中心'),
                              _buildManagementOption(
                                  Icons.verified_user, '证书认证'),
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
                      border: Border.all(color: Colors.grey, width: 0.1.w),
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
                        _buildOption(Icons.logout, '退出登录', onCheck: logout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
