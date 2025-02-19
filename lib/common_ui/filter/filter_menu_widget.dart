import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/app_colors.dart';
import '../title/app_text.dart';

///条件过滤菜单组件
class FilterMenuWidget extends StatefulWidget {
  final String? name;
  final bool? selected;
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const FilterMenuWidget({
    super.key,
    this.name,
    this.selected,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _FilterMenuWidgetState();
  }
}

class _FilterMenuWidgetState extends State<FilterMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.only(left: 15.w, right: 17.w, top: 11.h, bottom: 11.h),
          color: widget.backgroundColor ?? AppColors.searchBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                  text: widget.name ?? "",
                  fontSize: 16.sp,
                  textColor:
                      widget.selected == true ? AppColors.titleColor3030 : AppColors.textColorAd),
              SizedBox(width: 5.w),
              Image.asset(
                  widget.selected == true
                      ? "assets/images/icon_daosanjiao_shixin.png"
                      : "assets/images/icon_daosanjiao_shixin_grey.png",
                  width: 8.w,
                  height: 6.h)
            ],
          ),
        ));
  }
}
