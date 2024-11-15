import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  String safeSubstring(String str, int start, int end) {
    if (start < 0 || end > str.length || start > end) {
      return str; // 或者返回一个默认值
    }
    return str.substring(start, end);
  }

  // 构建图标按钮
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

  // 构建订单信息前缀
  Widget _buildOrderInfoPrefix(String prefix) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Text(prefix + ' : ',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp)),
    );
  }

  // 构建订单信息，使用wrap
  Widget _buildOrderInfo(String content, Color color) {
    return Text(content,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 17.sp));
  }

  Widget _buildStatusText(int status) {
    return switch (status) {
      _ => Text('未知状态', style: TextStyle(color: Colors.red,fontSize: 17.sp,fontWeight: FontWeight.bold)),
    };
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
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  // height: 150,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    border: Border.all(color: Colors.grey, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          _buildOrderInfoPrefix('订单类型'),
                          _buildOrderInfo(
                              _order.serviceName!, Colors.teal[800]!),
                        ],
                      ),
                      Divider(),
                      Row(children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage('assets/images/imageTmp.jpg'),
                              // 替换成你的图片路径
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                            width: 140,
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: [
                                    _buildOrderInfoPrefix('订单编号'),
                                    _buildOrderInfo(
                                        _order.commissionId.toString(),
                                        Colors.grey),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    _buildOrderInfoPrefix('创建时间'),
                                    _buildOrderInfo(
                                        safeSubstring(
                                            _order.createTime.toString(),
                                            0,
                                            19),
                                        Colors.blueAccent),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    _buildOrderInfoPrefix('预付金'),
                                    _buildOrderInfo(
                                        _order.downPayment == null ? '无' : '￥' + _order.downPayment.toString(),
                                        Colors.redAccent),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                      Divider(),
                      Row(children: [
                        _buildOrderInfoPrefix('订单状态'),
                        Expanded(child: SizedBox()),
                        _buildStatusText(_order.commissionStatus!),
                      ],),
                    ],
                  ),
                ),
              ],
            ),
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
                0 => Container(
                    child: _buildIconButton(
                        Icons.delete_forever_outlined, '取消订单', Colors.red),
                  ),
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
