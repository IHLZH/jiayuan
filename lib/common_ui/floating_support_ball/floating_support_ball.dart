import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/send_commission_page/send_commision_page.dart';
import 'package:jiayuan/utils/constants.dart';

import '../../page/home_page/home_vm.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class FloatingSupportBall extends StatefulWidget {
  @override
  _FloatingSupportBallState createState() => _FloatingSupportBallState();
}

class _FloatingSupportBallState extends State<FloatingSupportBall> {
  double _xPosition = 0 - 25;
  double _yPosition = 340;
  int _clickCount = 0;
  bool _isFirstClick = true;
  bool _isIconsVisible = false;

  Future<void> _jumpToSettingPage() async {
    await RouteUtils.pushForNamed(context, RoutePath.settingPage);
  }

  Future<void> _jumpToSendComissionPage(int index) async {
    await RouteUtils.push(context, SendCommissionPage(id: index));
  }

  // void _showCommissionOptionsDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SafeArea(
  //         child: AlertDialog(
  //           backgroundColor: AppColors.backgroundColor5,
  //           // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           title: Container(
  //             padding: EdgeInsets.only(bottom: 3),
  //             child: Center(
  //               child: Text(
  //                 '选择委托服务',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //               ),
  //             ),
  //           ),
  //           content: SizedBox(
  //             width: 300, // 设置一个固定的宽度
  //             height: 350,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: List.generate(11, (index) {
  //                   final options = [
  //                     '日常保洁',
  //                     '家电维修',
  //                     '搬家搬厂',
  //                     '收纳整理',
  //                     '管道疏通',
  //                     '维修拆装',
  //                     '保姆月嫂',
  //                     '居家养老',
  //                     '居家托育',
  //                     '专业养护',
  //                     '家庭保健'
  //                   ];
  //                   return Column(
  //                     children: [
  //                       ListTile(
  //                         title: Text(options[index]),
  //                         onTap: () {
  //                           if (isProduction)
  //                             print("========= id: $index ==========");
  //                           Navigator.of(context).pop(); // 关闭对话框
  //                           _jumpToSendComissionPage(index);
  //                         },
  //                       ),
  //                       if (index < 10) // 添加分隔线，最后一个选项不加
  //                         Divider(height: 1, color: Colors.grey),
  //                     ],
  //                   );
  //                 }),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showCommissionOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: AlertDialog(
            backgroundColor: AppColors.backgroundColor5,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        // Theme.of(context).primaryColor,
                        AppColors.appColor,
                        AppColors.appColor,
                        // AppColors.endColor,
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '选择委托服务',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(HomeViewModel.CommissionTypes.length,
                      (index) {
                    final commissionType = HomeViewModel.CommissionTypes[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  AppColors.appColor,
                                  AppColors.endColor,
                                ],
                              ).createShader(bounds);
                            },
                            child: Icon(
                              commissionType.icon,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          title: Text(commissionType.typeText),
                          onTap: () {
                            if (isProduction)
                              print("========= id: $index ==========");
                            Navigator.of(context).pop(); // 关闭对话框
                            _jumpToSendComissionPage(index);
                          },
                        ),
                        if (index <
                            HomeViewModel.CommissionTypes.length -
                                1) // 添加分隔线，最后一个选项不加
                          Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _xPosition,
          top: _yPosition,
          child: Draggable(
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isFirstClick
                      ? AppColors.appColor.withOpacity(0.7)
                      : AppColors.appColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.accessibility_new_outlined,
                      size: 40, color: Colors.white),
                ),
              ),
            ),
            childWhenDragging: Container(),
            // 当拖动时，原位置不显示任何内容
            onDragStarted: () {
              _isIconsVisible = false;
              setState(() {});
            },
            onDragEnd: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final position = details.offset;
              final size = MediaQuery.of(context).size;

              // 吸附到边缘
              if (position.dx < size.width / 2) {
                _xPosition = 0 - 25;
              } else {
                _xPosition = size.width - 30;
              }

              // 确保顶部位置不低于40
              if (position.dy < 40) {
                _yPosition = 40;
              } else if (position.dy > size.height - 130) {
                _yPosition = size.height - 130;
              } else {
                _yPosition = position.dy;
              }

              // 重置点击次数
              _clickCount = 0;
              _isFirstClick = true;
              _isIconsVisible = false;

              setState(() {});
            },
            child: GestureDetector(
              onTap: () {
                _clickCount++;
                if (_clickCount == 1) {
                  // 第一次点击
                  final size = MediaQuery.of(context).size;
                  if (_xPosition < size.width / 2) {
                    _xPosition = 5;
                  } else {
                    _xPosition = size.width - 65;
                  }
                  _isFirstClick = false;
                  _isIconsVisible = true;
                } else if (_clickCount == 2) {
                  // 第二次点击
                  _clickCount = 0; // 重置点击次数
                  _isFirstClick = true;
                  _isIconsVisible = false;
                }
                setState(() {});
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: _isFirstClick
                      ? AppColors.appColor.withOpacity(0.7)
                      : AppColors.appColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.accessibility_new_outlined,
                      size: 38, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        if (_isIconsVisible)
          //发布委托
          Positioned(
            left: _xPosition < MediaQuery.of(context).size.width / 2
                ? _xPosition + 30
                : _xPosition - 30,
            top: _yPosition - 50,
            child: GestureDetector(
              onTap: _showCommissionOptionsDialog,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.appColor, // 设置背景色
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.add, size: 35, color: Colors.white),
                ),
              ),
            ),
          ),
        if (_isIconsVisible)
          Positioned(
            left: _xPosition < MediaQuery.of(context).size.width / 2
                ? _xPosition + 70
                : _xPosition - 60,
            top: _yPosition + 5,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.appColor, // 设置背景色
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.support_agent_outlined,
                    size: 35, color: Colors.white),
              ),
            ),
          ),
        if (_isIconsVisible)
          Positioned(
            left: _xPosition < MediaQuery.of(context).size.width / 2
                ? _xPosition + 30
                : _xPosition - 30,
            top: _yPosition + 60,
            child: GestureDetector(
              onTap: _jumpToSettingPage,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.appColor, // 设置背景色
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.settings, size: 35, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
