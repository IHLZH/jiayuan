import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/common_ui/dialog/dialog_factory.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/page/commission_page/detail/commission_detail_vm.dart';
import 'package:jiayuan/page/tab_page/tab_page_vm.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/common_data.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';

class CommissionDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionDetailPageState();
  }
}

class _CommissionDetailPageState extends State<CommissionDetailPage>{
  CommissionDetailViewModel _commissionDetailViewModel = CommissionDetailViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _commissionDetailViewModel.commissionData = ModalRoute.of(context)?.settings.arguments as CommissionData1;

    return ChangeNotifierProvider(
        create: (context){
          return _commissionDetailViewModel;
        },
        child: Consumer<CommissionDetailViewModel>(
            builder: (context, vm, child){
              return Scaffold(
                resizeToAvoidBottomInset: false, // 禁止布局被键盘顶掉
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(45.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                          // gradient: LinearGradient(
                          //   colors: [
                          //     AppColors.appColor, // 渐变起始颜色
                          //     Colors.white,      // 渐变结束颜色
                          //   ],
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          // ),
                        ),
                        child: Container(
                          height: 200.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  RouteUtils.pop(context);
                                },
                              ),
                              Text(
                               "委托详情" ,
                                style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        )
                    )
                ),
                body: SingleChildScrollView(
                  child: Container(
                    //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor3
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 120.h,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: _Status(vm.commissionData.commissionStatus)
                          ),

                          SizedBox(height: 10.h,),

                          Container(
                            //height: 120.h,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "订单信息",
                                      style: TextStyle(
                                          color: AppColors.textColor2b,
                                          fontSize: 18.sp,
                                      ),
                                    )
                                  ],
                                ),

                                Divider(
                                  color: Colors.grey[250],
                                  height: 1,
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "委托用户",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            vm.commissionData.userName,
                                            style: TextStyle(
                                              color: Colors.black87
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.h,),
                                      Row(
                                        children: [
                                          Text(
                                            "委托编号",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            vm.commissionData.commissionId.toString(),
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.h,),
                                      Row(
                                        children: [
                                          Text(
                                            "委托类型",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            vm.commissionData.typeName.toString(),
                                            style: TextStyle(
                                                //color: Colors.black87
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.h,),
                                      Row(
                                        children: [
                                          Text(
                                            "下单时间",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm:ss').format(vm.commissionData.createTime),
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.h,),
                                      Row(
                                        children: [
                                          Text(
                                            "服务时间",
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm:ss').format(vm.commissionData.expectStartTime),
                                            style: TextStyle(
                                                color: Colors.black87
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8.h,),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.backgroundColor2,
                                            borderRadius: BorderRadius.circular(8.r)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 18,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(top: 4,bottom: 4),
                                                  child: Text(
                                                    vm.commissionData.distance < 1
                                                        ? "${(vm.commissionData.distance * 1000).round()}m . "
                                                        : "${vm.commissionData.distance.toStringAsFixed(1)}km . ",
                                                    style: TextStyle(
                                                        color: AppColors.textColor2b
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(top: 4,bottom: 4),
                                                child: Text(
                                                  vm.commissionData.commissionAddress,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: AppColors.textColor2b
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 10.h,),

                          Container (
                            //height: 120.h,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "联系方式",
                                      style: TextStyle(
                                          color: AppColors.textColor2b,
                                          fontSize: 18.sp,
                                      ),
                                    )
                                  ],
                                ),

                                Divider(
                                  color: Colors.grey[250],
                                  height: 1,
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "电话联系",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16.sp
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Text(
                                            vm.obfuscatePhoneNumber(vm.commissionData.userPhoneNumber),
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          IconButton(
                                              onPressed: (){
                                                vm.makePhoneCall(vm.commissionData.userPhoneNumber);
                                              },
                                              icon: Icon(
                                                  Icons.phone,
                                              ),
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 10.h,),

                          Container(
                            //height: 120.h,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "委托内容",
                                      style: TextStyle(
                                          color: AppColors.textColor2b,
                                          fontSize: 18.sp,
                                      ),
                                    )
                                  ],
                                ),

                                Divider(
                                  color: Colors.grey[250],
                                  height: 1,
                                ),

                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        vm.commissionData.commissionDescription,
                                        style: TextStyle(
                                          color: AppColors.textColor7d,
                                          fontSize: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 20.h,),

                          Container(
                            //height: 120.h,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "平台保障，单独推送，效率更高",
                                      style: TextStyle(
                                          color: AppColors.textColor2b,
                                          fontSize: 18.sp,
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: 10.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          height:45.h,
                                          width: 45.h,
                                          "assets/images/detail_process_1.png",
                                        ),
                                        Text(
                                          "1.接取委托",
                                          style: TextStyle(
                                              color: AppColors.textColor2b,
                                              fontSize: 12.sp
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          height:45.h,
                                          width: 45.h,
                                          "assets/images/detail_process_2.png",
                                        ),
                                        Text(
                                          "2.等待确认",
                                          style: TextStyle(
                                              color: AppColors.textColor2b,
                                            fontSize: 12.sp
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          height:45.h,
                                          width: 45.h,
                                          "assets/images/detail_process_3.png",
                                        ),
                                        Text(
                                          "3.完成服务",
                                          style: TextStyle(
                                            color: AppColors.textColor2b,
                                              fontSize: 12.sp
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          height:45.h,
                                          width: 45.h,
                                          "assets/images/detail_process_4.png",
                                        ),
                                        Text(
                                          "4.收取报酬",
                                          style: TextStyle(
                                              color: AppColors.textColor2b,
                                              fontSize: 12.sp
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),

                                SizedBox(height: 10.h,),
                              ],
                            ),
                          ),

                          SizedBox(height: 50.h,),
                        ],
                      )
                  ),
                ),
                bottomNavigationBar: _getBottom(vm.commissionData.commissionStatus),
              );
            }
        ),
    );
  }

  Widget _getBottom(int statuId){
    if(statuId == 2){
      return _UnService();
    } else if(statuId < 5){
      return _UnFinish(statuId);
    }else{
      return _Finish();
    }
  }
  Widget _UnService(){
    return Container(
        height: 60.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration:BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "￥" + _commissionDetailViewModel.commissionData.commissionBudget.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                      Icon(
                        Icons.help_outline,
                        color: Colors.black26,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "预估收入",
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 14.sp
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: AppButton(
                  onTap: (){},
                  type: AppButtonType.main,
                  color: CommonData.statusColor[2],
                  buttonText: "取消服务",
                  buttonTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp
                  ),
                  radius: 8.r,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                )
            ),
            Expanded(
                child: AppButton(
                  onTap: (){},
                  type: AppButtonType.main,
                  color: CommonData.statusColor[2],
                  buttonText: "开始服务",
                  buttonTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp
                  ),
                  radius: 8.r,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                )
            ),
          ],
        )
    );
  }

  Widget _Finish(){
    return Container(
        height: 60.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration:BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "总收入：",
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 22.sp
                        ),
                      ),
                      Text(
                        "￥" + _commissionDetailViewModel.commissionData.commissionBudget.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                      Icon(
                        Icons.help_outline,
                        color: Colors.black26,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _UnFinish(int statuId){
    String buttonText = "";
    if(statuId == 0){
      buttonText = "我想接";
    }else if(statuId == 2){
      buttonText = "开始服务";
    }else if(statuId == 3){
      buttonText = "完成服务";
    }else if(statuId == 4){
      buttonText = "提醒用户";
    }
    return Container(
        height: 60.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration:BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "￥" + _commissionDetailViewModel.commissionData.commissionBudget.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                      Icon(
                        Icons.help_outline,
                        color: Colors.black26,
                        size: 20.sp,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "预估收入",
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 14.sp
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
                child: AppButton(
                  onTap: (){
                    DialogFactory.instance.showParentDialog(
                        touchOutsideDismiss: true,
                        context: context,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r)
                          ),
                          width: 200,
                          height: 180,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "确认接取委托?",
                                    style: TextStyle(
                                        color: AppColors.textColor2b,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Wrap(
                                  children: [
                                    Text(
                                      "接取委托后，需等待委托用户确认，即可开始服务",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.textColor7d
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      onTap: (){
                                        RouteUtils.pop(context);
                                      },
                                      type: AppButtonType.minor,
                                      radius: 8.r,
                                      buttonText: "取消",
                                      buttonTextStyle: TextStyle(
                                          color: AppColors.textColor2b
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: AppButton(
                                        onTap: (){
                                          int result = _commissionDetailViewModel.receiveCommission();
                                          if(result == 0){
                                            TabPageViewModel.currentIndex = 3;
                                            RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
                                            showToast("请先认证！");
                                          }else if(result == 1){
                                            TabPageViewModel.currentIndex = 3;
                                            RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
                                            showToast("接取成功！");
                                          }
                                        },
                                        type: AppButtonType.main,
                                        radius: 8.r,
                                        buttonText: "确认",
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    );
                  },
                  type: AppButtonType.main,
                  color: CommonData.statusColor[statuId],
                  buttonText: buttonText,
                  buttonTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp
                  ),
                  radius: 8.r,
                )
            ),
          ],
        )
    );
  }

  Widget _Status(int statuId){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: CommonData.statusColor[statuId]
      ),
      child: Center(
        child: Text(
          CommonData.orderStatus[statuId],
          style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp
          ),
        ),
      ),
    );
  }
}