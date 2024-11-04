import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';

import '../../animation/PopUpAnimation.dart';
import '../../common_ui/dialog/loading.dart';
import '../../common_ui/styles/app_colors.dart';
import '../commission_page/commission_vm.dart';

class SendCommissionPage extends StatefulWidget {
  final int id;

  SendCommissionPage({required this.id});

  @override
  State<SendCommissionPage> createState() => _SendCommissionPageState();
}

class _SendCommissionPageState extends State<SendCommissionPage> {
  late CommissionType commissionType;

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
    commissionType = HomeViewModel.CommissionTypes[widget.id];
    print(commissionType.typeText);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      Loading.dismissAll();
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: Text("接委托"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30.w, right: 30.w),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildTypeService(),
            SizedBox(height: 20.h),
            _buildAreaService(),
            SizedBox(height: 20.h),
            _buildTimeService(),
            SizedBox(height: 20.h),
            _buildDurationService()
          ],
        ),
      ),
    );
  }

  //设置服务时长
  Widget _buildDurationService() {
    return PopUpAnimation(
        child: Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Text(
              "服务时长:      ",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text("请选择服务时长",style: TextStyle(fontSize: 13,color: Colors.grey),),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ]
            )
          ]
        )
      )
        )
    );
  }

  //设置服务时间
  Widget _buildTimeService() {
    return PopUpAnimation(
        child: Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Text(
              "服务时间:      ",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(width: 10.w),
                Text("请选择服务时间",style: TextStyle(fontSize: 13,color: Colors.grey),),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    ));
  }
  //设置服务地点
  Widget _buildAreaService() {
    return PopUpAnimation(
        child: Container(
          width: double.infinity,
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  "服务地点:      ",
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    Text("请选择服务地点",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  //服务类型
  Widget _buildTypeService() {
    return PopUpAnimation(
        child: Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SizedBox(width: 20.w,),
            Text(
              "服务类型:      ",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                Icon(commissionType.icon,
                    size: 30.w, color: AppColors.appColor),
                SizedBox(width: 10.w),
                Text(commissionType.typeText),
                SizedBox(width: 9.w,)
              ],
            )
          ],
        ),
      ),
    ));
  }
}
