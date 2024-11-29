import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';

import '../../route/route_path.dart';
import '../../route/route_utils.dart';

class FloatingSupportBall extends StatefulWidget {
  @override
  _FloatingSupportBallState createState() => _FloatingSupportBallState();
}

class _FloatingSupportBallState extends State<FloatingSupportBall> {
  double _xPosition = 0;
  double _yPosition = 40;
  int _clickCount = 0;
  bool _isFirstClick = true;

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
                  color: _isFirstClick ? AppColors.appColor.withOpacity(0.7) : AppColors.appColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.support_agent_outlined, size: 40, color: Colors.white),
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
                _xPosition = 0-25;
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

              setState(() {});
            },
            child: GestureDetector(
              onTap: () {
                _clickCount++;
                if (_clickCount == 1) {
                  // 第一次点击
                  final size = MediaQuery.of(context).size;
                  if (_xPosition < size.width / 2) {
                    _xPosition = 0;
                  } else {
                    _xPosition = size.width - 60;
                  }
                  _isFirstClick = false;
                } else if (_clickCount == 2) {
                  // 第二次点击
                  _jumpToSettingPage();
                  _clickCount = 0; // 重置点击次数
                  _isFirstClick = true;
                }
                setState(() {});
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _isFirstClick ? AppColors.appColor.withOpacity(0.7) : AppColors.appColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.support_agent_outlined, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _jumpToSettingPage() {
    RouteUtils.pushForNamed(context, RoutePath.settingPage);
  }
}
