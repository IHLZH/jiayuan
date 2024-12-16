import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/floating_support_ball/floating_support_ball.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page_vm.dart';
import 'package:jiayuan/page/send_commission_page/MapPage.dart';
import 'package:jiayuan/repository/model/full_order.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:oktoast/oktoast.dart';

class OrderChangePage extends StatefulWidget {
  @override
  State<OrderChangePage> createState() => _OrderChangePageState();
}

class _OrderChangePageState extends State<OrderChangePage> {
  final FullOrder _order = OrderDetailPageVm.nowOrder!;

  // 控制器
  final TextEditingController _remarkController = TextEditingController(
      text: OrderDetailPageVm.nowOrder!.commissionDescription); //备注
  final TextEditingController _doorNumberController = TextEditingController(
      text: OrderDetailPageVm.nowOrder!.commissionAddress); //门牌号
  final TextEditingController _customDurationController =
      TextEditingController(); //自定义时长
  // final TextEditingController _downPaymentController = TextEditingController(
  //     text: OrderDetailPageVm.nowOrder!.downPayment?.toString() ?? ''); //预付金
  final TextEditingController _commissionBudgetController =
      TextEditingController(
          text: OrderDetailPageVm.nowOrder!.commissionBudget?.toString() ??
              ''); //结算金额

  // 地址相关数据
  String? _address; // 详细地址
  double? _latitude; // 纬度
  double? _longitude; // 经度
  Map<String, dynamic>? _locationDetail; // 位置详情
  String? _province; // 省
  String? _city; // 市
  String? _district; // 区/县
  DateTime? _selectedDate;
  int _duration = 0;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    _remarkController.text = _order.commissionDescription ?? '';
    _doorNumberController.text = _order.commissionAddress ?? '';
    _selectedDate = _order.expectStartTime;
    _duration = int.tryParse(_order.specifyServiceDuration ?? '0') ?? 0;

    // 初始化地址信息
    _locationDetail = {
      'address': _order.commissionAddress,
      'latitude': _order.lat,
      'longitude': _order.lng,
      'pname': _order.province,
      'cityname': _order.city,
      'adname': _order.county
    };
    _address = _order.commissionAddress;
    _latitude = double.tryParse(_order.lat ?? '0');
    _longitude = double.tryParse(_order.lng ?? '0');
    _province = _order.province;
    _city = _order.city;
    _district = _order.county;
  }

  @override
  void dispose() {
    _remarkController.dispose();
    _doorNumberController.dispose();
    _customDurationController.dispose();
    // _downPaymentController.dispose();
    _commissionBudgetController.dispose();
    super.dispose();
  }

  // 更新地址信息
  void _updateLocation({
    required String address,
    required String latitude,
    required String longitude,
    required Map<String, dynamic> locationDetail,
  }) {
    setState(() {
      _address = locationDetail['address'].split('+').last;
      _doorNumberController.text = _address!;
      _latitude = double.tryParse(latitude);
      _longitude = double.tryParse(longitude);
      _locationDetail = locationDetail['locationDetail'];

      // 更新省市区信息
      _province = _locationDetail!['pname'];
      _city = _locationDetail!['cityname'];
      _district = _locationDetail!['adname'];

      if (isProduction) print('更新地址信息：$locationDetail');
      if (isProduction)
        print("省：$_province, 市：$_city, 区：$_district 地址$_address");
    });
  }

  // 构建备注输入框
  Widget _buildRemarkField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: _remarkController,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '请输入备注信息',
              contentPadding: EdgeInsets.only(left: 48, top: 16),
            ),
          ),
          Positioned(
            left: 8,
            top: 17,
            child: Icon(Icons.edit, color: AppColors.appColor),
          ),
        ],
      ),
    );
  }

  // 构建地址选择器
  Widget _buildAddressSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // 地址选择
          ListTile(
            leading: Icon(Icons.location_on, color: AppColors.appColor),
            title: Text(
                (_province != null && _city != null && _district != null)
                    ? '$_province $_city $_district'
                    : '选择服务地点'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(
                    initialLatitude: _latitude,
                    initialLongitude: _longitude,
                  ),
                ),
              );

              if (result != null) {
                _updateLocation(
                  address: result['address'],
                  latitude: result['latitude'].toString(),
                  longitude: result['longitude'].toString(),
                  locationDetail: result,
                );
              }
            },
          ),
          Divider(height: 1),
          // 门牌号输入
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _doorNumberController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入详细门牌号',
                icon: Icon(Icons.home, color: AppColors.appColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建时间选择器
  Widget _buildDateTimePicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.access_time, color: AppColors.appColor),
        title: Text(_selectedDate == null
            ? '选择服务时间'
            : '${_selectedDate?.year}年 ${_selectedDate?.month}月${_selectedDate?.day}日 ${_selectedDate?.hour}:${_selectedDate?.minute.toString().padLeft(2, '0')}'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Pickers.showDatePicker(
            context,
            mode: DateMode.YMDHM,
            minDate: PDuration.parse(DateTime.now()),
            maxDate:
                PDuration(year: DateTime.now().year + 1, month: 12, day: 31),
            onConfirm: (value) {
              setState(() {
                _selectedDate = DateTime(
                  value.year ?? 0,
                  value.month ?? 0,
                  value.day ?? 0,
                  value.hour ?? 0,
                  value.minute ?? 0,
                );
              });
            },
          );
        },
      ),
    );
  }

  // 构建时长选择器
  Widget _buildDurationSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.timer, color: AppColors.appColor),
        title: Text(_duration == 0 ? '选择服务时长' : '$_duration 小时'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showDurationPicker(context),
      ),
    );
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            return true;
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: 350.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('选择服务时长'),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ...[1, 2, 3, 4].map((duration) => ListTile(
                        leading:
                            Icon(Icons.access_time, color: AppColors.appColor),
                        title: Text('$duration 小时'),
                        onTap: () {
                          setState(() => _duration = duration);
                          Navigator.pop(context);
                        },
                      )),
                  if (_order.commissionId! > 6) ...[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customDurationController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: '自定义小时数',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: AppColors.appColor),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // 先关闭键盘
                              FocusScope.of(context).unfocus();

                              int? customDuration =
                                  int.tryParse(_customDurationController.text);
                              if (customDuration != null &&
                                  customDuration > 0) {
                                setState(() => _duration = customDuration);
                                Navigator.pop(context);
                              } else {
                                showToast('请输入有效的小时数');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('确定',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 构建结算金额输入框
  Widget _buildCommissionBudgetField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _commissionBudgetController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入结算金额',
          icon: Icon(Icons.attach_money, color: AppColors.appColor),
        ),
      ),
    );
  }

  // 保存修改
  void _saveChanges() {
    if (_doorNumberController.text == '' ||
        _selectedDate == null ||
        _duration == 0) {
      showToast('请完善所有信息');
      return;
    }

    // 创建新的订单对象
    final updatedOrder = FullOrder(
      commissionId: _order.commissionId,
      userId: _order.userId,
      keeperId: _order.keeperId,
      commissionBudget: double.tryParse(_commissionBudgetController.text),
      // downPayment: double.tryParse(_downPaymentController.text),
      commissionDescription: _remarkController.text,
      province: _province,
      city: _city,
      county: _district,
      commissionAddress: _doorNumberController.text,
      lng: _longitude.toString(),
      lat: _latitude.toString(),
      userPhoneNumber: _order.userPhoneNumber,
      expectStartTime: _selectedDate,
      specifyServiceDuration: _duration.toString(),
      commissionStatus: _order.commissionStatus,
      keeperName: _order.keeperName,
      serviceName: _order.serviceName,
      createTime: _order.createTime,
      updatedTime: _order.updatedTime,
      realStartTime: _order.realStartTime,
      endTime: _order.endTime,
    );

    // 更新 OrderDetailPageVm 中的订单
    OrderDetailPageVm.nowOrder = updatedOrder;

    // 返回上一页并传递更新成功的结果
    Navigator.pop(context, true);
    showToast('修改成功');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor5,
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
          title: Text('修改订单信息', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => RouteUtils.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.h),
              _buildRemarkField(),
              _buildAddressSelector(),
              _buildDateTimePicker(),
              _buildDurationSelector(),
              // _buildDownPaymentField(),
              _buildCommissionBudgetField(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => RouteUtils.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text('取消', style: TextStyle(color: Colors.black)),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text('保存', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
