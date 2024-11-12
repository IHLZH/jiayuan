import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/order_page/order_page_vm.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/Commission.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';

import '../../repository/model/full_order.dart';
import '../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class OrderPage extends StatefulWidget {
  // final String title;
  // final int status;
  // final int userId;
  //
  // OrderPage({Key? key, required this.title, required this.status})
  //     : userId = Global.userInfoNotifier.value!.userId,
  //       super(key: key);

  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<FullOrder> _commissionDataList = [];

  @override
  void initState() {
    // _commissionDataList = CommissionApi.instance.getComissionListWithStatus(widget.status, widget.userId) as List<CommissionData1>;
    _commissionDataList = OrderPageVM.getFullOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _itemBuilder(BuildContext context, int index) {
      final commissionData = _commissionDataList[index];
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10), // 设置圆角
          boxShadow: [
            // 设置阴影
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0), // 阴影偏移量
            ),
          ],
        ),
        padding: EdgeInsets.all(16), // 内边距
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "订单时间: ${commissionData.realStartTime.toString().substring(0, 19)}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("订单编号:",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Container(
                    width: 55,
                    child: Text(
                      "${commissionData.commissionId}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("订单状态: ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  switch (commissionData.commissionStatus) {
                    0 => Text("待接单",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    1 => Text("待服务",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                    2 => Text("服务中",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold)),
                    3 => Text("待支付",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    4 => Text("已完成",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    _ => Text("未知",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                  },
                ],
              ),
            ),
            SizedBox(height: 10),
            SafeArea(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("家政员:",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Container(
                      width: 70, // 设置容器宽度为70
                      child: Text(
                        "${commissionData.keeperName == null ? "无" : commissionData.keeperName == '' ? "无" : commissionData.keeperName}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "委托类型:",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 80,
                      child: Text(
                        "${commissionData.serviceName}",
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
            ),
            SizedBox(height: 10),
            Row(children: [
              Text("服务地址:",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text(
                  "${commissionData.province} ${commissionData.city} ${commissionData.county}"),
            ]),
            SizedBox(height: 10),
            Row(
              children: [
                Text("详细地址:",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text("${commissionData.commissionAddress}"),
              ],
            ),
            SafeArea(
                child: switch (commissionData.commissionStatus) {
              0 => SafeArea(
                  child: Column(),
                ),
              1 => SafeArea(
                  child: Column(),
                ),
              2 => SafeArea(
                  child: Column(),
                ),
              3 => SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // 背景颜色
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                // 圆角
                                side: BorderSide(
                                    color: AppColors.orangeBtnColor,
                                    width: 1.0), // 边框
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              // 内边距
                              elevation: 3.0,
                              // 阴影效果
                              splashFactory: InkRipple.splashFactory,
                              // 水波纹效果
                              overlayColor: AppColors.orangeBtnColor,
                            ),
                            icon: Icon(
                              Icons.monetization_on_outlined,
                              color: AppColors.orangeBtnColor,
                            ), // 图标
                            label: Text(
                              '去支付',
                              style: TextStyle(
                                  color: AppColors.orangeBtnColor,
                                  fontWeight: FontWeight.normal),
                            ), // 按钮文字
                            onPressed: () {
                              // 点击按钮时的处理逻辑
                              //TODO
                              print('用户点击了去支付按钮');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                4 => SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // 背景颜色
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                // 圆角
                                side: BorderSide(
                                    color: AppColors.appColor,
                                    width: 1.0), // 边框
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              // 内边距
                              elevation: 3.0,
                              // 阴影效果
                              splashFactory: InkRipple.splashFactory,
                              // 水波纹效果
                              overlayColor: AppColors.appColor,
                            ),
                            icon: Icon(
                              Icons.rate_review_outlined,
                              color: AppColors.appColor,
                            ), // 图标
                            label: Text(
                              '去评价',
                              style: TextStyle(
                                  color: AppColors.appColor,
                                  fontWeight: FontWeight.normal),
                            ), // 按钮文字
                            onPressed: () {
                              // 点击按钮时的处理逻辑
                              //TODO
                              print('用户点击了去评价按钮');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              _ => Text("记录问题"),
            }),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        // 使用 Container 包裹 AppBar 以实现渐变背景
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                AppColors.endDeepColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text('我的订单',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            RouteUtils.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _commissionDataList.length,
        itemBuilder: _itemBuilder,
      ),
    );
  }
}
