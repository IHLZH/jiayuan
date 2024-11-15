import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page_vm.dart';
import 'package:jiayuan/repository/model/full_order.dart';
import 'package:jiayuan/utils/constants.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  FullOrder _order = OrderDetailPageVm.nowOrder!;

  Widget _buildIconButton(IconData icon, String title, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: color, width: 1.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 3.0,
        splashFactory: InkRipple.splashFactory,
        overlayColor: color,
      ),
      icon: Icon(icon, color: color),
      label: Text(title,
          style: TextStyle(color: color, fontWeight: FontWeight.normal)),
      onPressed: () {
        print('用户点击了${title}按钮');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 使用 Container 包裹 AppBar 以实现渐变背景
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                AppColors.endDeepColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text('订单详情',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: // 底部操作按钮
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: SizedBox()),
              _buildIconButton(Icons.edit, '修改信息', Colors.green),
              Expanded(child: SizedBox()),
              switch (_order.commissionStatus) {
                0 => Container(child: _buildIconButton(Icons.delete_forever_outlined, '取消订单', Colors.red),),
                1 => Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildIconButton(Icons.check_circle_outline, '同意',
                            Colors.lightGreen),
                        SizedBox(
                          width: 5,
                        ),
                        _buildIconButton(Icons.cancel, '不同意', Colors.red),
                      ],
                    ),
                  ),
                4 => _buildIconButton(
                    Icons.payment, '去支付', AppColors.orangeBtnColor),
                5 => _buildIconButton(
                    Icons.rate_review_outlined, '去评价', AppColors.appColor),
                _ => Container(),
              },
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
