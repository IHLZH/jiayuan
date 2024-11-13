import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/page/commission_center_page/order/order_page_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';

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
                              _orderList(1),
                              _orderList(2),
                              _orderList(3),
                              _orderList(4),
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
    List<Commission> orders = _orderViewModel.getStatusOrder(id);
    return ListView.builder(
      itemCount: orders.length,
        itemBuilder: (context, index){
          return _orderCard(orders[index]);
        }
    );
  }

  Widget _orderCard(Commission commission){
    return Container(
      height: 150.h,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 4,bottom: 4,left: 4),
                child: Text(
                  "开始时间：",
                  style: TextStyle(
                    color: AppColors.textColor2b
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 4,bottom: 4,right: 4),
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(commission.expectTime),
                  style: TextStyle(
                      color: AppColors.textColor2b
                  ),
                ),
              )
            ],
          ),
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
                  Global.CommissionTypes[commission.commissionType].typeText,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600
                  ),
                ),
              )
            ],
          ),
          Row(
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
                      commission.distance.toString() + "km",
                      style: TextStyle(
                          color: AppColors.textColor2b
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 4,bottom: 4,left: 4),
                    child: Text(
                      commission.county + " " + commission.address + "sdmaosdmaosikdm",
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

        ],
      ),
    );
  }
}