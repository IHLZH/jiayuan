import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/sliver/sliver_app_bar_delegate.dart';

///吸顶布局
class SliverHeader extends StatefulWidget {
  final List<Widget> children;
  final bool? pinned;
  final bool? floating;
  final double? childHeight;

  const SliverHeader({super.key, this.pinned, this.floating, required this.children, this.childHeight});

  @override
  State createState() {
    return _SliverHeaderState();
  }
}

class _SliverHeaderState extends State<SliverHeader> {

  double? _myHeight;

  @override
  Widget build(BuildContext context) {

    _myHeight = widget.childHeight;

    return SliverPersistentHeader(
        pinned: widget.pinned ?? true,
        floating: widget.floating ?? true,
        delegate: SliverAppBarDelegate(
            minHeight: _myHeight ?? 70.h,
            maxHeight: _myHeight ?? 70.h,
            child: LayoutBuilder(
              builder: (context, constraints) {
                //通过LayoutBuilder动态获取子组件的高度
                return Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(children: widget.children));
              },
            )));
  }
}
