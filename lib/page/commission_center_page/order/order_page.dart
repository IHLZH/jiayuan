import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/page/commission_center_page/order/order_page_vm.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/dialog/dialog_factory.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';
import '../../../utils/common_data.dart';

class CenterOrderPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _OrderPageState();
  }
}

class _OrderPageState extends State<CenterOrderPage> with TickerProviderStateMixin{
  OrderPageViewModel _orderViewModel = OrderPageViewModel();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _orderViewModel.getOrders();
    _tabController = TabController(
        length: 4,
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {

    if(_orderViewModel.currentIndex == null)_orderViewModel.currentIndex = (ModalRoute.of(context)?.settings.arguments ?? 0) as int;
    setState(() {
      _tabController.index = _orderViewModel.currentIndex!;
    });

    return ChangeNotifierProvider(
        create: (context){
          return _orderViewModel;
        },
        child: Consumer(
            builder: (context, vm, child){
              return Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.appColor, // 渐变起始颜色
                              AppColors.backgroundColor2,      // 渐变结束颜色
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp),
                          height: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  RouteUtils.pop(context);
                                },
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "全部订单",
                                  style: TextStyle(
                                      color: AppColors.textColor2b,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        )
                    ),
                ),
                body: Container(
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor2
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        onTap: (index){
                          _orderViewModel.currentIndex = index;
                        },
                        tabs: [
                          Tab(text: "待服务"),
                          Tab(text: "服务中"),
                          Tab(text: "待支付"),
                          Tab(text: "已完成"),
                        ],
                        //isScrollable: true,
                        indicatorColor: AppColors.appColor,
                        labelColor: AppColors.appColor,
                        physics: ClampingScrollPhysics(), // 自定义滑动物理效果
                      ),
                      Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _orderList(2),
                              _orderList(3),
                              _orderList(4),
                              _orderList(5),
                            ]
                          )
                      )
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

  Widget _orderList(int id){
    List<CommissionData1> orders = _orderViewModel.getStatusOrder(id);
    return ListView.builder(
      itemCount: orders.length,
        itemBuilder: (context, index){
          return _orderCard(orders[index]);
        }
    );
  }

  Widget _orderCard(CommissionData1 commission){
    return InkWell(
      onTap: (){
        RouteUtils.pushForNamed(
            context,
            RoutePath.commissionDetail,
          arguments: commission
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 4,bottom: 4,left: 4),
                      child: Text(
                        commission.commissionStatus == 2 ? "指定时间：" : "开始时间：",
                        style: TextStyle(
                            color: AppColors.textColor2b
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4,bottom: 4,right: 4),
                      child: Text(
                        commission.commissionStatus == 2 ?
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(commission.expectStartTime) :
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(commission.realStartTime),
                        style: TextStyle(
                            color: AppColors.textColor2b
                        ),
                      ),
                    )
                  ],
                ),

                Container(
                  child: Text(
                    CommonData.orderStatus[commission.commissionStatus],
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 5.h,),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 4,bottom: 4,left: 4),
                  child: Text(
                    "订单类型：",
                    style: TextStyle(
                        color: AppColors.textColor2b
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.appColor, // 渐变起始颜色
                          AppColors.endColor,      // 渐变结束颜色
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Text(
                    Global.CommissionTypes[1].typeText,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 5.h,),

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
                          commission.distance.toString() + "km.",
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
                        _orderViewModel.getCountyAddress(commission),
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

            SizedBox(height: 10.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    print("object");
                  },
                  child: getOrderButton(commission),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getOrderButton(CommissionData1 commission){
    if(commission.commissionStatus == 2){
      return Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              splashColor: AppColors.endColor,
              borderRadius: BorderRadius.circular(16.r),
              onTap: (){
                _cancelCommission(commission);
              },
              child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.appColor,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Text("取消服务")
              ),
            ),
          ),
          SizedBox(width: 5,),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              splashColor: AppColors.endColor,
              borderRadius: BorderRadius.circular(16.r),
              onTap: (){
                _startCommission(commission);
              },
              child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.appColor,
                          width: 1
                      ),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Text("开始服务")
              ),
            ),
          ),
        ],
      );
    }else if(commission.commissionStatus == 3){
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          splashColor: AppColors.endColor,
          borderRadius: BorderRadius.circular(16.r),
          onTap: (){
            _finishCommission(commission);
          },
          child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.appColor,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(16.r)
              ),
              child: Text("完成服务")
          ),
        ),
      );
    }else if(commission.commissionStatus == 4){
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          splashColor: AppColors.endColor,
          borderRadius: BorderRadius.circular(16.r),
          onTap: (){
            _remind(commission);
          },
          child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.appColor,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(16.r)
              ),
              child: Text("提醒用户")
          ),
        ),
      );
    }else{
      return Container(
          padding: EdgeInsets.all(4),
          child: Text(
              "收入 ￥" + commission.commissionBudget.toString(),
            style: TextStyle(
              color: Colors.red
            ),
          )
      );
    }
  }

  //完成服务弹窗事件
  void _finishCommission(CommissionData1 commission){
    DialogFactory.instance.showParentDialog(
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
                        onTap: (){
                          RouteUtils.pop(context);
                          showToast("操作成功，委托已完成！");
                          RouteUtils.pop(context);
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

  //提醒用户弹窗事件
  void _remind(CommissionData1 commission){
    //提醒用户
  }

  //取消服务
  void _cancelCommission(CommissionData1 commission){
    DialogFactory.instance.showParentDialog(
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
                        onTap: (){
                          RouteUtils.pop(context);
                          showToast("操作成功，委托已取消");
                          RouteUtils.pop(context);
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

  //开始服务
  void _startCommission(CommissionData1 commission){
    DialogFactory.instance.showParentDialog(
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
                      commission.distance <= 0.5
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
                        onTap: (){
                          RouteUtils.pop(context);
                          showToast("操作成功，委托已开始");
                          RouteUtils.pop(context);
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
}