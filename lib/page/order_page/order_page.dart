import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/order_page/order_page_vm.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/Commission.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';

import '../../repository/model/full_order.dart';

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
          borderRadius: BorderRadius.circular(10), // 设置圆角
          boxShadow: [ // 设置阴影
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
                  "订单时间: ${commissionData.realStartTime.toString()
                      .substring(0, 19)}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 10),

            SafeArea(child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("订单编号:", style: TextStyle(
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
                SizedBox(width: 5,),
                Text("订单状态: ", style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                switch (commissionData.commissionStatus) {
                  0 => Text("待接单", style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
                  1 => Text("待服务", style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold)),
                  2 => Text("服务中", style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold)),
                  3 => Text("已完成", style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
                  _ => Text("未知", style: TextStyle(color: Colors.redAccent,
                      fontWeight: FontWeight.bold)),
                },
              ],
            ),),

            SizedBox(height: 10),

            SafeArea(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("家政员:", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Container(
                    width: 70, // 设置容器宽度为70
                    child: Text(
                      "${commissionData.keeperName}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("委托类型:", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
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
                ]
            ),),

            SizedBox(height: 10),
            Row(
              children: [
                Text("服务地址:", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text("${commissionData.province} ${commissionData.city} ${commissionData.county}"),
              ]
            ),
            SizedBox(height: 10),
            Row(children: [
              Text("详细地址:", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("${commissionData.commissionAddress}"),
            ],),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        title:  Text(
          // "${widget.title}",
          "我的订单",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
