import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';

import '../../route/route_path.dart';
import '../../route/route_utils.dart';

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

  Future<void> _jumpToSendComissionPage() async {
    await RouteUtils.pushForNamed(context, RoutePath.sendCommissionPage);
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
            childWhenDragging: Container(), // 当拖动时，原位置不显示任何内容
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
                width: 60,
                height: 60,
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
          ),
        ),
        if (_isIconsVisible)
          Positioned(
            left: _xPosition < MediaQuery.of(context).size.width / 2
                ? _xPosition + 30
                : _xPosition - 30,
            top: _yPosition - 50,
            child: GestureDetector(
              onTap: _jumpToSendComissionPage,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.appColor, // 设置背景色
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.publish_sharp, size: 35, color: Colors.white),
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
