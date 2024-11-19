import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page_vm.dart';
import 'package:jiayuan/repository/model/full_order.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../http/url_path.dart';
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

  Future<void> _agreeOrder() async {
    String url = UrlPath.updateOrderStatusUrl;

    try {
      final response =
          await DioInstance.instance().put(path: url, queryParameters: {
        'commissionId': _order.commissionId,
        'new': 2,
      });

      if (response.statusCode == 200) {
        if(response.data['code']==200){
          setState(() {
            _order.commissionStatus=2;
          });
          showToast('已同意',duration: Duration(seconds: 1));
        }
        else{
          if(isProduction)print("error: ${response.data['message']}");
          showToast(response.data['message'],duration: Duration(seconds: 1));
        }
      }
      else{
        if(isProduction)print("error: ${response.data['message']}");
        showToast('无法连接服务器',duration: Duration(seconds: 1));
      }
    } catch (e) {
      if(isProduction)print("error: $e");
    }
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
        switch (title) {
          case '同意':
            _agreeOrder();
        }
      },
    );
  }

  // 构建订单信息前缀
  Widget _buildOrderInfoPrefix(String prefix) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Text(prefix + ':',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp)),
    );
  }

  // 构建订单信息，使用wrap
  Widget _buildOrderInfo(String content, Color color) {
    return Text(content,
        softWrap: true,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 17.sp));
  }

  Widget _buildStatusText(int status) {
    return switch (status) {
      0 => Text("待接取",
          style: TextStyle(
              color: Colors.blue,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      1 => Text("待确认",
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      2 => Text("待服务",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      3 => Text("服务中",
          style: TextStyle(
              color: Colors.orange,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      4 => Text("待支付",
          style: TextStyle(
              color: Colors.red, fontSize: 17.sp, fontWeight: FontWeight.bold)),
      5 => Text("已完成",
          style: TextStyle(
              color: Colors.green,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      6 => Text("已取消",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      _ => Text('未知状态',
          style: TextStyle(
              color: Colors.red, fontSize: 17.sp, fontWeight: FontWeight.bold)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 使 Container 包裹 AppBar 以实现渐变背景
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
      body: Container(
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // height: 300,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1.0),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, -1),
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
                            _order.serviceName == null
                                ? '未确认'
                                : _order.serviceName!,
                            Colors.teal[800]!),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    Row(children: [
                      Container(
                        // constraints: BoxConstraints(
                        //   maxWidth: 300,
                        //   minWidth: 150,
                        //   maxHeight: 300,
                        //   minHeight: 150,
                        // ),
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
                      SafeArea(
                        child: Container(
                            // constraints: BoxConstraints(
                            //   maxWidth: 300,
                            //   minWidth: 140,
                            //   maxHeight: 300,
                            //   minHeight: 150,
                            // ),
                            width: 140,
                            height: 150,
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      children: [
                                        _buildOrderInfoPrefix('订单编号'),
                                        _buildOrderInfo(
                                            _order.commissionId.toString(),
                                            Colors.grey[600]!),
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
                                            _order.downPayment == null
                                                ? '未确定'
                                                : '￥' +
                                                    _order.downPayment
                                                        .toString(),
                                            Colors.redAccent),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ]),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        _buildOrderInfoPrefix('订单状态'),
                        Expanded(child: SizedBox()),
                        _buildStatusText(_order.commissionStatus!),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        _buildOrderInfoPrefix('结算'),
                        Expanded(child: SizedBox()),
                        _buildOrderInfo(
                            _order.commissionBudget == null
                                ? '未确定'
                                : '￥' + _order.commissionBudget.toString(),
                            Colors.red),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                // height: 300,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1.0),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, -1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        _buildOrderInfoPrefix('接单家政员'),
                        Expanded(child: SizedBox()),
                        _buildOrderInfo(
                            _order.keeperName == null
                                ? '未确认'
                                : _order.keeperName!,
                            Colors.purple[600]!),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        _buildOrderInfoPrefix('服务时长'),
                        Expanded(child: SizedBox()),
                        _buildOrderInfo(
                            _order.specifyServiceDuration == null
                                ? '未确认'
                                : _order.specifyServiceDuration! + '小时',
                            Colors.grey[600]!),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        _buildOrderInfoPrefix('服务地址'),
                        Expanded(child: SizedBox()),
                        _buildOrderInfo(
                            _order.province == null ? '未确认' : _order.province!,
                            Colors.grey[600]!),
                        SizedBox(width: 10),
                        _buildOrderInfo(
                            _order.city == null ? '未确认' : _order.city!,
                            Colors.grey[600]!),
                        SizedBox(width: 10),
                        _buildOrderInfo(
                            _order.county == null ? '未确认' : _order.county!,
                            Colors.grey[600]!),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, //垂直对齐
                      children: [
                        Expanded(
                          flex: 2,
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                _buildOrderInfoPrefix('详细地址'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: IntrinsicHeight(
                          child: SizedBox(),
                        )),
                        Expanded(
                          flex: 2,
                          child: IntrinsicHeight(
                            child: _buildOrderInfo(
                                _order.commissionAddress == null
                                    ? '未确认'
                                    : _order.commissionAddress!,
                                Colors.grey[600]!),
                          ),
                        ),
                        // SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                // height: 300,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1.0),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, -1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey, width: 1.w),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "遇到困难？",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, //水平均分
                        children: [
                          TextButton(
                            onPressed: () {
                              // 处理“联系家政员”点击事件
                              print('联系家政员');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent, // 设置背景透明
                              padding: EdgeInsets.all(10), // 添加内边距
                              overlayColor: AppColors.appColor
                                  .withOpacity(0.2), // 设置点击时的颜色
                            ),
                            child: Row(children: [
                              Icon(
                                Icons.phone,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ),
                              SizedBox(width: 5),
                              Text("联系家政员",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                            ]),
                          ),
                          TextButton(
                            onPressed: () {
                              // 处理“联系客服”点击事件
                              print('联系客服');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent, // 设置背景透明
                              padding: EdgeInsets.all(10), // 添加内边距
                              overlayColor: AppColors.appColor
                                  .withOpacity(0.2), // 设置点击时的颜色
                            ),
                            child: Row(children: [
                              Icon(
                                Icons.support_agent_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 35,
                              ),
                              SizedBox(width: 5),
                              Text("联系客服",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor)),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                // height: 300,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(1.0),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(1, -1),
                    ),
                  ],
                  border: Border.all(color: Colors.grey, width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          "订单备注:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _order.commissionDescription ?? '无',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
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
              if (_order.commissionStatus == 0 ||
                  _order.commissionStatus == 1 ||
                  _order.commissionStatus == 4 ||
                  _order.commissionStatus == 5)
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
