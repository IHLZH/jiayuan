import 'package:flutter/material.dart';

class PopUpAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PopUpAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 800)})
      : super(key: key);

  @override
  _PopUpAnimationState createState() => _PopUpAnimationState();
}

class _PopUpAnimationState extends State<PopUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3), // 从稍微往下的位置开始
      end: Offset.zero, // 到达原位
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward(); // 启动动画
  }

  @override
  void dispose() {
    _controller.dispose(); // 销毁动画控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child,
      ),
    );
  }
}
