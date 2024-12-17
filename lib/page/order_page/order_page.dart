import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_pay/model/ali_pay_result.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page_vm.dart';
import 'package:jiayuan/repository/model/full_order.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../route/route_utils.dart';

bool isProduction = Constants.IS_Production;

class OrderPage extends StatefulWidget {
  final int status;

  const OrderPage({Key? key, required this.status}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<FullOrder> _orderDataList = [];
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 10;
  int _pageSize = 5;
  int nowOrderStatus = -1;

  void sortByDate() {
    _orderDataList.sort((a, b) => b.createTime!.compareTo(a.createTime!));
  }

  @override
  void initState() {
    _fetchOrders();
    super.initState();
  }

  //创建订单
  Future<int> createOrder(int index) async {
    String url = UrlPath.createOrderUrl;
    try {
      final response = await DioInstance.instance().post(
        path: url,
        queryParameters: {
          'userId': _orderDataList[index].userId,
          'housekeeperId': _orderDataList[index].keeperId,
          'amount': _orderDataList[index].commissionBudget,
          'commissionId': _orderDataList[index].commissionId,
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
      print('获取到的orderStr数据${response.data}');
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

  Future<void> _payOrder(int index) async {
    int orderId = await createOrder(index);
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
      _refreshOrders();
      //刷新界面
    } else {
      print(
          "支付失败 ${aliPayResult.result} + ${aliPayResult.resultStatus} + ${aliPayResult.memo}");
      //支付失败
      showToast("支付失败", duration: const Duration(seconds: 1));
    }
  }

  Future<void> _jumpToOrderDetailPage(int index) async {
    OrderDetailPageVm.nowOrder = _orderDataList[index];
    await RouteUtils.pushForNamed(context, RoutePath.orderDetailPage);
    _refreshOrders();
  }

  Future<void> _jumpToEvaluatePage(int index) async {
    OrderDetailPageVm.nowOrder = _orderDataList[index];
    await RouteUtils.pushForNamed(context, RoutePath.evalutationPage,
        arguments: _orderDataList[index]);
    _refreshOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isRefreshing = true;
    });

    print("================ nowOrderStatus: $nowOrderStatus ==============");

    String url = widget.status != -1
        ? UrlPath.getOrderInfoByUserIdAndStatusUrl +
            "?userId=${Global.userInfoNotifier.value!.userId}&status=${widget.status}&page=${_currentPage}&size=${_pageSize}"
        : nowOrderStatus != -1
            ? UrlPath.getOrderInfoByUserIdAndStatusUrl +
                "?userId=${Global.userInfoNotifier.value!.userId}&status=${nowOrderStatus}&page=${_currentPage}&size=${_pageSize}"
            : UrlPath.getOrderInfoByUserIdUrl +
                "?userId=${Global.userInfoNotifier.value!.userId}&page=${_currentPage}&size=${_pageSize}";

    try {
      final response = await DioInstance.instance().get(
          path: url,
          options: Options(headers: {
            'Authorization': Global.token!,
          }));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          List<FullOrder> newOrders =
              FullOrder.fromJsonList(response.data['data']['items']);
          if (_currentPage == 1) {
            _orderDataList = newOrders;
          } else {
            _orderDataList.addAll(newOrders);
          }
          _totalPages = response.data['data']['total'];
          // sortByDate();
        } else {
          showToast("${response.data['message']}",
              duration: const Duration(seconds: 1));
          return;
        }
      } else {
        showToast("服务器异常", duration: const Duration(seconds: 1));
        return;
      }
    } catch (e) {
      // 处理错误
      if (isProduction) print('Error: $e');
      showToast("服务器异常", duration: const Duration(seconds: 1));
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshOrders() async {
    _currentPage = 1;
    _isLoadingMore = false;
    if (isProduction) print("page refresh !");
    await _fetchOrders();
  }

  Future<void> _loadMoreOrders() async {
    if (isProduction) print("page load more !");

    if (_currentPage + _pageSize - 1 < _totalPages && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      _currentPage++;
      await _fetchOrders();

      setState(() {
        _isLoadingMore = false;
      });
    } else {
      _isLoadingMore = true;
      if (isProduction) print("没有更多数据");
    }
  }

  String safeSubstring(String str, int start, int end) {
    if (start < 0 || end > str.length || start > end) {
      return str; // 或者返回一个默认值
    }
    return str.substring(start, end);
  }

  @override
  Widget build(BuildContext context) {
    Widget _itemBuilder(BuildContext context, int index) {
      if (index >= _orderDataList.length) {
        return Center(
            child:
                // _isLoadingMore ? CircularProgressIndicator() : SizedBox.shrink(),
                switch (_isLoadingMore) {
          true => CircularProgressIndicator(),
          false => Text("没有更多数据"),
        });
      }

      final commissionData = _orderDataList[index];
      return GestureDetector(
        onTap: () => _jumpToOrderDetailPage(index),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 0.1.w),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "订单时间: ${safeSubstring(commissionData.createTime.toString(), 0, 19)}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                child: Divider(),
              ),
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
                            color: Colors.black, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text("订单状态:",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    switch (commissionData.commissionStatus) {
                      0 => Text("待接取",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      1 => Text("待确认",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                      2 => Text("待服务",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      3 => Text("服务中",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      4 => Text("待支付",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                      5 => Text("已完成",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                      6 => Text("已取消",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      7 => Text("已评价",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Container(
                        width: 70,
                        child: Text(
                          "${commissionData.keeperName == null ? "无" : commissionData.keeperName == '' ? "无" : commissionData.keeperName}",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text("委托类型:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Container(
                        width: 80,
                        child: Text(
                          "${commissionData.serviceName}",
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold),
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
                  "${commissionData.province} ${commissionData.city} ${commissionData.county}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("详细地址:",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Container(
                    width: 200,
                    child: Text(
                      "${commissionData.commissionAddress}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SafeArea(
                  child: switch (commissionData.commissionStatus) {
                0 => SafeArea(child: Column()),
                1 => SafeArea(child: Column()),
                2 => SafeArea(child: Column()),
                3 => SafeArea(child: Column()),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: AppColors.orangeBtnColor,
                                      width: 1.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 3.0,
                                splashFactory: InkRipple.splashFactory,
                                overlayColor: AppColors.orangeBtnColor,
                              ),
                              icon: Icon(Icons.monetization_on_outlined,
                                  color: AppColors.orangeBtnColor),
                              label: Text('去支付',
                                  style: TextStyle(
                                      color: AppColors.orangeBtnColor,
                                      fontWeight: FontWeight.normal)),
                              onPressed: () async {
                                await _payOrder(index);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                5 => SafeArea(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: SizedBox()),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: AppColors.appColor, width: 1.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                elevation: 3.0,
                                splashFactory: InkRipple.splashFactory,
                                overlayColor: AppColors.appColor,
                              ),
                              icon: Icon(Icons.rate_review_outlined,
                                  color: AppColors.appColor),
                              label: Text('去评价',
                                  style: TextStyle(
                                      color: AppColors.appColor,
                                      fontWeight: FontWeight.normal)),
                              onPressed: () {
                                if (isProduction) print('用户点击了去评价按钮');
                                _jumpToEvaluatePage(index);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                //TODO:其他状态的下方按钮
                6 => SafeArea(child: Column()),
                7 => SafeArea(child: Column()),
                8 => SafeArea(child: Column()),
                _ => Text("记录问题"),
              }),
            ],
          ),
        ),
      );
    }

    // 构建单选框选项
    Widget _buildRadioOption(String title, int value) {
      return ListTile(
        title: Text(title),
        leading: Radio<int>(
          value: value,
          groupValue: nowOrderStatus,
          activeColor: AppColors.appColor, // 设置选中时的颜色
          onChanged: (int? newValue) async {
            setState(() {
              nowOrderStatus = newValue!;
            });
            await _refreshOrders();
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.appColor, AppColors.endDeepColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
            widget.status == -1
                ? '我的订单'
                : widget.status == 0
                    ? '待接取'
                    : widget.status == 1
                        ? '待确认'
                        : widget.status == 2
                            ? '待服务'
                            : widget.status == 3
                                ? '服务中'
                                : widget.status == 4
                                    ? '待支付'
                                    : widget.status == 5
                                        ? '已完成'
                                        : widget.status == 6
                                            ? '已取消'
                                            : '已完成(已评价)',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            RouteUtils.pop(context);
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return widget.status == -1
                  ? IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // 设置高度
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                ),
                child: Text(
                  '订单类型',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            _buildRadioOption('全部', -1), // 添加“全部”状态
            _buildRadioOption('待接取', 0),
            _buildRadioOption('待确认', 1),
            _buildRadioOption('待服务', 2),
            _buildRadioOption('服务中', 3),
            _buildRadioOption('待支付', 4),
            _buildRadioOption('已完成', 5),
            _buildRadioOption('已取消', 6),
            _buildRadioOption('已评价', 7),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders, //下拉刷新
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 20) {
              // 修改这里
              _loadMoreOrders(); // 上拉加载更多
            }
            return false;
          },
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: _orderDataList.length + 1,
            itemBuilder: (context, index) {
              return _itemBuilder(context, index);
            },
          ),
        ),
      ),
    );
  }
}
