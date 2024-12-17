import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/page/commission_center_page/wallet_center/wallet_cent_vm.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';

class WalletCenterPage extends StatefulWidget {
  const WalletCenterPage({super.key});

  @override
  State<WalletCenterPage> createState() => _WalletCenterPageState();
}

class _WalletCenterPageState extends State<WalletCenterPage> {
  WalletCentVm walletCentVm = WalletCentVm();

  @override
  void initState() {
    super.initState();
    walletCentVm.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.endColor,
        surfaceTintColor: Colors.transparent,
        title: Text("收益中心"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))],
      ),
      body: ChangeNotifierProvider(
        create: (context) => walletCentVm,
        child: Consumer<WalletCentVm>(builder: (context, walletCentVm, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.endColor,
                  padding:
                      EdgeInsets.only(left: 15.w, bottom: 5.h, right: 15.w),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('收益诊断', style: TextStyle(fontSize: 16.sp)),
                          Container(
                            width: 20.w,
                            height: 4.h,
                            color: AppColors.appColor,
                          )
                        ],
                      ),
                      Spacer(),
                      CustomPopupMenu(
                        pressType: PressType.singleClick,
                        showArrow: false,
                        position: PreferredPosition.bottom,
                        controller: walletCentVm.controller,
                        child: Row(
                          children: [
                            Text(
                                '${walletCentVm.recentHalfYear[walletCentVm.index].year}年${walletCentVm.recentHalfYear[walletCentVm.index].month}月'),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        menuBuilder: () {
                          return Container(
                            padding: EdgeInsets.only(top: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            child: Column(
                              children: List.generate(
                                  walletCentVm.recentHalfYear.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    walletCentVm.changeMonth(index);
                                    walletCentVm.controller.hideMenu();
                                    walletCentVm.getDownOrders(
                                        walletCentVm
                                            .recentHalfYear[index].year!,
                                        walletCentVm
                                            .recentHalfYear[index].month!);
                                  },
                                  child: Container(
                                    width: 120.w,
                                    margin: EdgeInsets.only(
                                        left: 10.w, right: 10.w),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.h),
                                    child: Row(
                                      children: [
                                        Text(
                                            '${walletCentVm.recentHalfYear[index].year}年${walletCentVm.recentHalfYear[index].month}月'),
                                        Spacer(),
                                        walletCentVm.index == index
                                            ? Icon(
                                                Icons.check,
                                                size: 15.sp,
                                              )
                                            : SizedBox(
                                                width: 15.sp,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                        barrierColor: Colors.transparent,
                      )
                    ],
                  ),
                ),
                walletCentVm.downByTime.length == 0
                    ? Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(left: 15.w, right: 15.w, top: 13.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 25.h),
                                Container(
                                  width: 280.w,
                                  height:200.w,
                                  child: Image.asset('assets/images/dataNone.png',fit: BoxFit.cover,),
                                ),
                                Text('本月暂无收益诊断，继续努力吧!', style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey)),
                                SizedBox(height: 20.h),
                              ],
                            )),
                      )
                    : Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              walletCentVm.downByTime.length, (index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.w, left: 15.w),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${walletCentVm.downByTime[index].commissionDescription}",
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                      "收入: ${walletCentVm.downByTime[index].commissionBudget}"),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "${walletCentVm.downByTime[index].commissionAddress}",
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                      "开始时间: ${DateFormat("yyyy-MM-dd").format(walletCentVm.downByTime[index].realStartTime!)}",
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.grey)),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "结束时间: ${DateFormat("yyyy-MM-dd").format(walletCentVm.downByTime[index].endTime!)}",
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  //下划线
                                  Divider(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    endIndent: 20.w,
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      )
              ],
            ),
          );
        }),
      ),
    );
  }
}
