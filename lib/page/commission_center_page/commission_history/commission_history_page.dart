import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/commission_center_page/commission_history/commission_history_page_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/dialog/dialog_factory.dart';
import '../../../repository/model/commission_data1.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';

class CommissionHistoryPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionHistoryPageState();
  }
}

class _CommissionHistoryPageState extends State<CommissionHistoryPage>{

  CommissionHistoryViewModel _commissionHistoryVM = CommissionHistoryViewModel();

  @override
  void initState() {
    super.initState();
    _initHistory();
  }

  Future<void> _initHistory() async {
    await _commissionHistoryVM.getCommissionHistory();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        return _commissionHistoryVM;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor3,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                      AppColors.backgroundColor3,      // 渐变结束颜色
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  height: 180.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                RouteUtils.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_new)
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "历史浏览",
                              style: TextStyle(
                                  color: AppColors.textColor2b,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: (){
                            _showClearHistory();
                          },
                          icon: Icon(Icons.delete)
                      ),
                    ],
                  ),
                )
            )
        ),
        body: Selector<CommissionHistoryViewModel, List<CommissionData1>>(
            selector: (context, vm){
              return vm.commissionHistory;
            },
            builder: (context, commissionHistory, child){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SmartRefresher(
                  controller: Provider.of<CommissionHistoryViewModel>(context).refreshController,
                  onRefresh: Provider.of<CommissionHistoryViewModel>(context).onRefresh,
                  child: ListView.builder(
                      itemCount: commissionHistory.length,
                      itemBuilder: (context, index){
                        return CommissionCard(commissionHistory[index]);
                      }
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget CommissionCard(CommissionData1 commission){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () async {
            CommissionData1 commissionDetail = await _commissionHistoryVM.getCommissionDetail(commission.commissionId);
            RouteUtils.pushForNamed(
                context,
                RoutePath.commissionDetail,
                arguments: commissionDetail
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 125.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "浏览时间：" +
                      (commission.browerTime.month.toString() + "/" + commission.browerTime.day.toString() + " ") +
                      (commission.browerTime.hour.toString().length > 1 ? commission.browerTime.hour.toString() : ("0" + commission.browerTime.hour.toString())) +
                          ":" + (commission.browerTime.minute.toString().length > 1 ? commission.browerTime.minute.toString() : ("0" + commission.browerTime.minute.toString())),
                      style: TextStyle(
                          color: AppColors.textColor7d,
                          fontSize: 14.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          commission.commissionBudget.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "元",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.endColor,
                          borderRadius: BorderRadius.circular(16.r)
                      ),
                      child: Text(
                        commission.typeName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                        child: Text(
                          "内容：" + (commission.commissionDescription ?? "家政员招募中~"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 5.w,),
                    Text(
                      commission.county ?? "",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                      child: Text(
                        commission.commissionAddress ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearHistory(){
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
                    "清空历史记录",
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
                      "确认清空历史浏览记录？",
                      style: TextStyle(
                          fontSize: 18.sp,
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
                          await _commissionHistoryVM.clearCommissionHistory();
                          RouteUtils.pop(context);
                          showToast("操作成功！");
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "删除",
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