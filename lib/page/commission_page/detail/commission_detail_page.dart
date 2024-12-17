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
import '../../../im/im_chat_api.dart';

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
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
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
                                          Row(
                                            children: [
                                              Container(
                                                child: CircleAvatar(
                                                  backgroundColor: AppColors.backgroundColor3,
                                                  backgroundImage: vm.commissionData.userAvatar != null ?
                                                  NetworkImage(vm.commissionData.userAvatar!) :
                                                  AssetImage("assets/images/detail_img.png"),
                                                ),
                                                width: 25,
                                                height: 25,
                                              ),
                                              Text(
                                                vm.commissionData.userName,
                                                style: TextStyle(
                                                    color: Colors.black87
                                                ),
                                              )
                                            ],
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
                                            DateFormat('yyyy-MM-dd HH:mm:ss').format(vm.commissionData.createTime ?? DateTime(1999, 1, 1, 12, 0)),
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
                                                  vm.commissionData.county + " " + vm.commissionData.commissionAddress,
                                                  maxLines: null,
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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "发送消息",
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 16.sp
                                            ),
                                          ),
                                          SizedBox(width: 20.w,),
                                          Row(
                                            children: [
                                              Container(
                                                child: CircleAvatar(
                                                  backgroundColor: AppColors.backgroundColor3,
                                                  backgroundImage: vm.commissionData.userAvatar != null ?
                                                  NetworkImage(vm.commissionData.userAvatar!) :
                                                  AssetImage("assets/images/detail_img.png"),
                                                ),
                                                width: 25,
                                                height: 25,
                                              ),
                                              Text(
                                                vm.commissionData.userName,
                                                style: TextStyle(
                                                    color: Colors.black87
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 20.w,),
                                          IconButton(
                                            onPressed: (){
                                              vm.makeChat(
                                                  userId: vm.commissionData.userId.toString(),
                                                  context: context
                                              );
                                            },
                                            icon: Icon(
                                              Icons.chat,
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

                          SizedBox(height: 10,),

                          if(vm.commissionData.commissionStatus == 2)
                            AppButton(
                              onTap: (){
                                _cancelCommission();
                              },
                              type: AppButtonType.main,
                              color: Colors.white,
                              buttonText: "有问题？取消服务",
                              buttonTextStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp
                              ),
                              radius: 8.r,
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

  //获取订单详情底部布局
  Widget _getBottom(int statuId){
    if(statuId == 2){
      return _UnService();
    } else if(statuId < 5){
      return _UnFinish(statuId);
    }else{
      return _Finish();
    }
  }

  //待服务的订单
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
                        size: 16.sp,
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
                  onTap: (){
                    _startCommission();
                  },
                  type: AppButtonType.main,
                  color: CommonData.statusColor[2],
                  buttonText: "开始服务",
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

  //已完成的订单
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

  //服务中，待解取，待支付的订单
  Widget _UnFinish(int statuId){
    String buttonText = "";
    if(statuId == 0){
      buttonText = "我想接";
    } else if(statuId == 1){
      buttonText = "提醒用户";
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
                    _unFinishShowDialog(statuId);
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

  //订单状态文本
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

  //接委托，完成服务，提醒用户，弹窗事件
  void _unFinishShowDialog(int statuId){
    switch(statuId){
      case 0:
        _receiveCommission();
        break;
      case 1:
        _remindConfirm();
        break;
      case 3:
        _finishCommission();
        break;
      case 4:
        _remind();
        break;
    }
  }

  //接委托弹窗事件
  void _receiveCommission(){
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
                        onTap: () async {
                          int result = await _commissionDetailViewModel.changeCommissionStatus(1);
                          if(result == 2){
                            RouteUtils.pop(context);
                            showToast("请先认证！");
                          }else if(result == 1){
                            RouteUtils.pop(context);
                            RouteUtils.pop(context);
                            showToast("接取成功！");
                          }else if(result == 0){
                            RouteUtils.pop(context);
                            showToast("接取失败！");
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
  }

  //完成服务弹窗事件
  void _finishCommission(){
    DialogFactory.instance.showParentDialog(
        context: context,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r)
          ),
          width: 200,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "确认完成委托?",
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
                      "委托完成后，客户验收后即可支付，若对报酬不满意，请与客户进行议价",
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
                        onTap: () async {
                          int result = await _commissionDetailViewModel.changeCommissionStatus(4);
                          if(result == 1){
                            RouteUtils.pop(context);
                            showToast("操作成功，委托已完成！");
                            RouteUtils.pop(context);
                          }else{
                            showToast("操作失败，请稍后再试");
                          }
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "确认",
                        color: CommonData.statusColor[3],
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  //提醒用户弹窗事件
  Future<void> _remind() async {
    //提醒用户
    String remindText = "我已完成订单编号为 ${_commissionDetailViewModel.commissionData.commissionId} 的委托订单，请尽快支付";
    await ImChatApi.getInstance().sendTextMessage(_commissionDetailViewModel.commissionData.userId.toString(), remindText);
    showToast("用户已收到提醒");
  }

  Future<void> _remindConfirm() async {
    //提醒用户
    String remindText = "我已接取订单编号为 ${_commissionDetailViewModel.commissionData.commissionId} 的委托订单，请尽快确认";
    await ImChatApi.getInstance().sendTextMessage(_commissionDetailViewModel.commissionData.userId.toString(), remindText);
    showToast("用户已收到提醒");
  }

  //取消服务
  void _cancelCommission(){
    DialogFactory.instance.showParentDialog(
        context: context,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r)
          ),
          width: 200,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "确认取消委托?",
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
                      "确保与客户沟通后取消委托，无故取消委托易遭客户投诉",
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
                        onTap: () async {
                          int result = await _commissionDetailViewModel.changeCommissionStatus(0);
                          if(result == 1){
                            RouteUtils.pop(context);
                            showToast("操作成功，委托已取消");
                            RouteUtils.pop(context);
                          }else{
                            showToast("操作失败，请稍后再试");
                          }
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "确认",
                        color: CommonData.statusColor[2],
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  //开始服务
  void _startCommission(){
    DialogFactory.instance.showParentDialog(
        context: context,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r)
          ),
          width: 200,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "确认开始委托?",
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
                      _commissionDetailViewModel.commissionData.distance <= 0.5
                          ? "检测到您已到达指定地点附近，是否确认开始委托?"
                          : "检测到您当前位置与指定地点距离过远(1km以外)，是否确认开始委托?",
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
                        onTap: () async {
                          int result = await _commissionDetailViewModel.changeCommissionStatus(3);
                          if(result == 1){
                            RouteUtils.pop(context);
                            showToast("操作成功，委托已开始");
                            RouteUtils.pop(context);
                          }else{
                            showToast("操作失败，请稍后再试");
                          }
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "确认",
                        color: CommonData.statusColor[2],
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}