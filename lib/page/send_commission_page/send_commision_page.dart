import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
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

  String selectedDuration = "请选择服务时长";

  String selectedTime = "请选择服务时间";

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
      body: Container(
          width: MediaQuery.of(context).size.width,
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
          child: Column(
            children: [
              Container(
                child: AppBar(
                  title: Text("需求发布"),
                  centerTitle: true,
                  backgroundColor: Colors.transparent, // 使 AppBar 背景透明
                  elevation: 0, // 取消阴影
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                child: Column(
                  children: [
                    _buildTypeService(),
                    _buildAreaService(),
                    _buildTimeService(),
                    _buildDurationService(),
                    _buildContactService(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  //填写联系方式
  Widget _buildContactService() {
    return PopUpAnimation(
        child: Container(
            margin: EdgeInsets.only(top: 20.h),
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
                child: Column(
                  children: [],
                ))));
  }

  // 设置服务时长
  Widget _buildDurationService() {
    return PopUpAnimation(
      child: GestureDetector(
        onTap: () {
          _showDurationPicker(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: 20.h),
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
                    Text(
                      selectedDuration, // 显示选择的服务时长
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //日期选择器
  void _showDurationPicker(BuildContext context) {
    print("服务id为${widget.id}");
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 使背景透明
      builder: (BuildContext context) {
        return Container(
          height: 295.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 16, bottom: 0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '选择服务时长',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // 关闭弹出框
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
              Expanded(
                child: ListView(
                  children: [
                    widget.id > 6
                        ? _buildDurationOption("1个月")
                        : _buildDurationOption("1个小时"),
                    widget.id > 6
                        ? _buildDurationOption("2个月")
                        : _buildDurationOption("2个小时"),
                    widget.id > 6
                        ? _buildDurationOption("3个月")
                        : _buildDurationOption("3个小时"),
                    widget.id > 6
                        ? _buildDurationOption("4个月")
                        : _buildDurationOption("4个小时"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// 创建一个方法用于生成选项
  Widget _buildDurationOption(String duration) {
    return GestureDetector(
      onTap: () {
        _updateSelectedDuration(duration);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(Icons.access_time, color: AppColors.appColor), // 使用图标
            SizedBox(width: 10),
            Text(
              duration,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // 更新选择的服务时长
  void _updateSelectedDuration(String duration) {
    setState(() {
      selectedDuration = duration; // 更新状态
    });
    Navigator.pop(context); // 关闭底部弹出框
  }

  //设置服务时间
  Widget _buildTimeService() {
    return PopUpAnimation(
        child: GestureDetector(
            onTap: () {
              Pickers.showDatePicker(
                  context,mode: DateMode.MDHM,onConfirm: (value) {
                    setState(() {
                      selectedTime =  value.month.toString() + value.day.toString() + value.hour.toString() + value.minute.toString();
                      print("还"+ selectedTime);
                    });
                   print('longer >>> 返回数据：${value.toString}');
              });
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20.h),
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
                        Text(
                          "请选择服务时间",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }

  //设置服务地点
  Widget _buildAreaService() {
    return PopUpAnimation(
        child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.h),
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
                Text(
                  "请选择服务地点",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
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
      margin: EdgeInsets.only(top: 20.h),
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
            SizedBox(
              width: 20.w,
            ),
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
                SizedBox(
                  width: 9.w,
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
