import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_pay/model/ali_pay_result.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page_vm.dart';
import 'package:jiayuan/repository/api/keeper_api.dart';
import 'package:jiayuan/repository/model/full_order.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../http/url_path.dart';
import '../../../im/im_chat_api.dart';
import '../../../repository/model/HouseKeeper_data_detail.dart';
import '../../../route/route_utils.dart';
import '../../../utils/global.dart';

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

  // 去评价
  Future<void> _jumpToEvaluatePage() async {
    final res = await RouteUtils.pushForNamed(
        context, RoutePath.evalutationPage,
        arguments: _order);
    if (res == true) {
      setState(() {
        _order.commissionStatus = 7;
      });
    }
  }

  // 同意操作
  Future<void> _agreeOrder() async {
    String url = UrlPath.updateOrderStatusUrl;

    try {
      final response = await DioInstance.instance().put(
          path: url,
          queryParameters: {
            'commissionId': _order.commissionId,
            'new': 2,
          },
          options: Options(headers: {"Authorization": Global.token}));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          setState(() {
            _order.commissionStatus = 2;
          });
          showToast('已同意', duration: Duration(seconds: 1));
        } else {
          if (isProduction) print("error: ${response.data['message']}");
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) print("error: ${response.data['message']}");
        showToast('无法连接服务器', duration: Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }
  }

  // 不同意操作
  Future<void> _disagreeOrder() async {
    String url = UrlPath.updateOrderStatusUrl;

    try {
      final response = await DioInstance.instance().put(
          path: url,
          queryParameters: {
            'commissionId': _order.commissionId,
            'new': 0,
          },
          options: Options(headers: {
            'Authorization': Global.token!,
          }));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          setState(() {
            _order.commissionStatus = 0;
          });
          showToast('已拒绝', duration: Duration(seconds: 1));
        } else {
          if (isProduction) print("error: ${response.data['message']}");
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }
  }

  // 取消订单
  Future<void> _cancelOrder() async {
    String url = UrlPath.updateOrderStatusUrl;

    try {
      final response = await DioInstance.instance().put(
          path: url,
          queryParameters: {
            'commissionId': _order.commissionId,
            'new': 6,
          },
          options: Options(headers: {
            'Authorization': Global.token!,
          }));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          setState(() {
            _order.commissionStatus = 6;
          });
          showToast('已取消', duration: Duration(seconds: 1));
        } else {
          if (isProduction) print("error: ${response.data['message']}");
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }
  }

  // 修改订单信息
  Future<void> _changeOrderInfo() async {
    // 在 OrderDetailPage 中调用
    RouteUtils.pushForNamed(context, RoutePath.orderChangePage).then((updated) {
      if (updated == true) {
        _order = OrderDetailPageVm.nowOrder!;
        setState(() {}); // 刷新页面显示
      }
    });
  }

  // 跳转客服聊天
  Future<void> _jumpToCustomerService(int userId) async {
    V2TimConversation? conversation =
        await ImChatApi.getInstance().getConversation("c2c_${userId}");
    RouteUtils.pushForNamed(context, RoutePath.chatPage,
        arguments: conversation);
  }

  Future<void> _jumpToKeeperChatPage(int id) async {
    int userId = -1;

    userId = await KeeperApi.instance.getUserId(id);

    if (userId != -1) {
      V2TimConversation? conversation =
          await ImChatApi.getInstance().getConversation("c2c_${userId}");

      RouteUtils.pushForNamed(context, RoutePath.chatPage,
          arguments: conversation);
    }
  }

  //创建订单
  Future<int> createOrder() async {
    String url = UrlPath.createOrderUrl;
    try {
      final response = await DioInstance.instance().post(
        path: url,
        queryParameters: {
          'userId': _order.userId,
          'housekeeperId': _order.keeperId,
          'amount': _order.commissionBudget,
          'commissionId': _order.commissionId,
        },
      );
      if (response.statusCode == 200) {
        return response.data['id'];
      } else {
        showToast("网络请求常", duration: const Duration(seconds: 1));
        return -1;
      }
    } catch (e) {
      showToast("服务器异常", duration: const Duration(seconds: 1));
      return -1;
    }
  }

  //获取orderStr
  Future<String> getOrderInfo(int orderId) async {
    String url = UrlPath.getOrderStr;
    try {
      final response = await DioInstance.instance().get(
        path: url,
        param: {
          'orderId': orderId,
        },
      );
      if(isProduction)print('获取到的orderStr数据${response.data}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        showToast("服务器异常", duration: const Duration(seconds: 1));
        return "";
      }
    } catch (e) {
      // 处理错误
      if (isProduction) print('Error: $e');
      showToast("服务器异常", duration: const Duration(seconds: 1));
      return "";
    }
  }

  //支付
  Future<AliPayResult> payWithAliPay(String payInfo, {bool? isSandbox}) {
    return FlutterPay.payWithAliPay(payInfo, isSandbox: isSandbox);
  }

  Future<void> _payOrder() async {
    int orderId = await createOrder();
    if (orderId == -1) {
      showToast('订单创建失败');
      return;
    }
    String orderStr = await getOrderInfo(orderId);
    if (orderStr == "") {
      showToast('获取orderStr失败');
      return;
    }
    AliPayResult aliPayResult = await payWithAliPay(orderStr, isSandbox: true);
    if (aliPayResult.resultStatus == "9000") {
      showToast("支付成功", duration: const Duration(seconds: 1));

      //  EasyLoading.showProgress();

      //刷新界面
    } else {
      if(isProduction)print(
          "支付失败 ${aliPayResult.result} + ${aliPayResult.resultStatus} + ${aliPayResult.memo}");
      //支付失败
      showToast("支付失败", duration: const Duration(seconds: 1));
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
          case '不同意':
            _disagreeOrder();
          case '去评价':
            _jumpToEvaluatePage();
          case '取消订单':
            _cancelOrder();
          case '修改信息':
            _changeOrderInfo();
          case '去支付':
            _payOrder();
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

  //构建带边框的信息块
  Widget _buildInfoBlock(Widget content) {
    return Container(
      // height: 300,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5.w),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, -1),
          ),
        ],
        border: Border.all(color: Colors.grey, width: 0.1.w),
      ),
      child: content,
    );
  }

  //构建带边框的信息块(审核)
  Widget _errorBlock(Widget content) {
    return Container(
      // height: 300,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5.w),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, -1),
          ),
        ],
        border: Border.all(color: Colors.grey, width: 0.1.w),
      ),
      child: content,
    );
  }

  // 构建订单信息1
  Widget _buildOrderInfo1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            SizedBox(
              width: 10,
            ),
            _buildOrderInfoPrefix('订单类型'),
            _buildOrderInfo(
                _order.serviceName == null ? '未确认' : _order.serviceName!,
                Colors.teal[800]!),
          ],
        ),
        SizedBox(height: 5),
        Divider(),
        SizedBox(height: 5),
        Row(children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage(switch (_order.serviceName) {
                  '日常保洁' => 'assets/images/type_1.jpg',
                  '家电维修' => 'assets/images/type_2.jpg',
                  '搬家搬厂' => 'assets/images/type_3.jpg',
                  '收纳整理' => 'assets/images/type_4.jpg',
                  '管道疏通' => 'assets/images/type_5.jpg',
                  '维修拆装' => 'assets/images/type_6.jpg',
                  '保姆月嫂' => 'assets/images/type_7.jpg',
                  '居家养老' => 'assets/images/type_8.jpg',
                  '居家托育' => 'assets/images/type_9.jpg',
                  '专业养护' => 'assets/images/type_10.jpg',
                  '家庭保健' => 'assets/images/type_11.jpg',
                  _ => 'assets/images/imageTmp.jpg',
                }),
                // 替换成你的图片路径
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 30),
          SafeArea(
            child: Container(
                width: 140,
                height: 150,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            _buildOrderInfoPrefix('订单编号'),
                            _buildOrderInfo(_order.commissionId.toString(),
                                Colors.grey[600]!),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildOrderInfoPrefix('创建时间'),
                        SizedBox(height: 5),
                        Wrap(
                          children: [
                            _buildOrderInfo(
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(_order.createTime!),
                                Colors.blueAccent),
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
    );
  }

  // 构建订单信息2
  Widget _buildOrderInfo2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            _buildOrderInfoPrefix('接单家政员'),
            Expanded(child: SizedBox()),
            Icon(Icons.person,color: Colors.blue,),
            GestureDetector(
              onTap: () {
                if (_order.keeperId != null) {
                  _jumpToKeeperChatPage(_order.keeperId!);
                }
              },
              child: _buildOrderInfo(
                  _order.keeperName == null ? '未确认' : _order.keeperName!,
                  Colors.blue),
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 10),
            _buildOrderInfoPrefix('期望开始时间'),
            Expanded(child: SizedBox()),
            _buildOrderInfo(
                _order.expectStartTime == null
                    ? '未确认'
                    : DateFormat('yyyy-MM-dd HH:mm')
                        .format(_order.expectStartTime!),
                Colors.grey[600]!),
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
            _buildOrderInfo(_order.province == null ? '未确认' : _order.province!,
                Colors.grey[600]!),
            SizedBox(width: 10),
            _buildOrderInfo(
                _order.city == null ? '未确认' : _order.city!, Colors.grey[600]!),
            SizedBox(width: 10),
            _buildOrderInfo(_order.county == null ? '未确认' : _order.county!,
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
    );
  }

  // 构建订单信息3
  Widget _buildOrderInfo3() {
    return Column(
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
        SizedBox(height: 5),
        Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, //水平均分
            children: [
              TextButton(
                onPressed: () {
                  // 处理“联系家政员”点击事件
                  if (_order.keeperId == null)
                    showToast("还没有家政员接单", duration: Duration(seconds: 1));
                  else {
                    String phoneNumber = OrderDetailPageVm.keeperPhone!;

                    if (phoneNumber != "未确认")
                      OrderDetailPageVm.makePhoneCall(phoneNumber);
                    else
                      showToast("该家政员未绑定电话", duration: Duration(seconds: 1));
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // 设置背景透明
                  padding: EdgeInsets.all(10), // 添加内边距
                  overlayColor: AppColors.appColor.withOpacity(0.2), // 设置点击时的颜色
                ),
                child: Row(children: [
                  Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Text("联系家政员",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ]),
              ),
              TextButton(
                onPressed: () {
                  // 处理“联系客服”点击事件
                  _jumpToCustomerService(Constants.KF_ID);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // 设置背景透明
                  padding: EdgeInsets.all(10), // 添加内边距
                  overlayColor: AppColors.appColor.withOpacity(0.2), // 设置点击时的颜色
                ),
                child: Row(children: [
                  Icon(
                    Icons.support_agent_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Text("联系客服",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ]),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  // 构建订单信息4
  Widget _buildOrderInfo4() {
    return Column(
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
        // Divider(),
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
    );
  }

  // 未过审原因
  Widget _buildOrderInfo5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 10),
            Text(
              "未过审原因:",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        // SizedBox(height: 5),
        Divider(
          color: AppColors.backgroundColor,
        ),
        // SizedBox(height: 5),
        Container(
          child: Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  OrderDetailPageVm.rejectReason!,
                  style: TextStyle(
                      fontSize: 17,
                      color: AppColors.backgroundColor,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // 构建订单状态
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
      7 => Text("已完成(已评价)",
          style: TextStyle(
              color: Colors.green,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold)),
      8 => Text("未通过审核",
          style: TextStyle(
              color: Colors.red, fontSize: 17.sp, fontWeight: FontWeight.bold)),
      _ => Text('未知状态',
          style: TextStyle(
              color: Colors.red, fontSize: 17.sp, fontWeight: FontWeight.bold)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor6,
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
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
          color: AppColors.backgroundColor5,
          padding: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_order.commissionStatus == 8) ...[
                  _errorBlock(_buildOrderInfo5()),
                  SizedBox(height: 15),
                ],
                _buildInfoBlock(_buildOrderInfo1()),
                SizedBox(height: 15),
                _buildInfoBlock(_buildOrderInfo2()),
                SizedBox(height: 15),
                _buildInfoBlock(_buildOrderInfo3()),
                SizedBox(height: 15),
                _buildInfoBlock(_buildOrderInfo4()),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
        bottomNavigationBar: switch (_order.commissionStatus) {
          6 => null,
          2 => null,
          3 => null,
          7 => null,
          8 => null,
          _ => Container(
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
                    Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 10),
                        child: SizedBox(),
                      ),
                    ),
                    if (_order.commissionStatus == 0 ||
                        _order.commissionStatus == 1) ...[
                      _buildIconButton(Icons.edit, '修改信息', Colors.green),
                    ],
                    if (_order.commissionStatus == 0 ||
                        _order.commissionStatus == 1 ||
                        _order.commissionStatus == 4 ||
                        _order.commissionStatus == 5 ||
                        _order.commissionStatus == 7)
                      Expanded(child: SizedBox()),
                    switch (_order.commissionStatus) {
                      0 => Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 90),
                              _buildIconButton(Icons.delete_forever_outlined,
                                  '取消订单', Colors.red),
                            ],
                          ),
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
                      4 => Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildIconButton(Icons.payment, '去支付',
                                  AppColors.orangeBtnColor),
                              SizedBox(
                                width: 10,
                              ),
                              _buildIconButton(Icons.cancel, '不验收', Colors.red),
                            ],
                          ),
                        ),
                      5 => _buildIconButton(Icons.rate_review_outlined, '去评价',
                          AppColors.appColor),
                      // 7 => _buildIconButton(Icons.rate_review_outlined, '我的评价',
                      //     AppColors.appColor),
                      _ => Container(),
                    },
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
        });
  }
}
