import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:jiayuan/page/send_commission_page/send_commission_vm.dart';
import 'package:provider/provider.dart';

import '../../animation/PopUpAnimation.dart';
import '../../common_ui/dialog/loading.dart';
import '../../common_ui/keyboard/customer_keyboard.dart';
import '../../common_ui/styles/app_colors.dart';
import '../commission_page/commission_vm.dart';
import 'MapPage.dart';


class SendCommissionPage extends StatefulWidget {
  final int id;

  SendCommissionPage({required this.id});

  @override
  State<SendCommissionPage> createState() => _SendCommissionPageState();
}

class _SendCommissionPageState extends State<SendCommissionPage> {
  late CommissionType commissionType;

  SendCommissionViewModel _sendCommissionViewModel = SendCommissionViewModel();

  TextEditingController _phoneController = TextEditingController();

  FocusNode _focusNodePhone = FocusNode();
  FocusNode _focusNodeRemark = FocusNode();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _tempPriceController = TextEditingController();

  final int _maxLength = 100; // 最大字数限制

  final FocusNode _focusNodePrice = FocusNode();

  String? _selectedAddress;
  Map<String, dynamic>? _locationDetail;

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
    commissionType = HomeViewModel.CommissionTypes[widget.id];
    print(commissionType.typeText);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      Loading.dismissAll();
    });

    return ChangeNotifierProvider<SendCommissionViewModel>(
        create: (context) => _sendCommissionViewModel,
        child: Scaffold(
          body: TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: Colors.green, //选中文字背景颜色
                selectionHandleColor: Colors.greenAccent,
                cursorColor: Colors.greenAccent, //光标颜色
              ),
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.appColor,
                            Colors.white,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: AppBar(
                              title: Text("需求发布"),
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                              // 使 AppBar 背景透明
                              elevation: 0, // 取消阴影
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(left: 30.w, right: 30.w),
                              child: Column(
                                children: [
                                  //委托类型
                                  _buildTypeService(),
                                  //备注
                                  _buildRemarkService(),
                                  //联系方式
                                  _buildContactService(),
                                  //地区
                                  _buildAreaService(),
                                  //服务时间
                                  _buildTimeService(),
                                  //服务时长
                                  _buildDurationService(),
                                  //价格
                                  _buildPriceService(),
                                ],
                              ),
                            ),
                          ))
                        ],
                      )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: _buildPostService())
                ],
              )),
        ));
  }

  Widget _buildPostService() {
    return Container(
      margin: EdgeInsets.only(right: 30.w, bottom: 10.h),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          colors: [
            AppColors.endColor,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: () {
            // 你点击后的操作
          },
          child: Container(
            child: Center(
              child: Text(
                '发布',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceService() {
    return PopUpAnimation(
        child: Container(
      margin: EdgeInsets.only(top: 20.h),
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            _showCustomKeyboard();
          },
          child: Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Row(
              children: [
                SizedBox(width: 20.w),
                Text(
                  "价格:      ",
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Row(
                  children: [
                    SizedBox(width: 10.w),
                    Text(
                        "¥ ${_sendCommissionViewModel.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16)),
                    Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  //显示自定义键盘
  void _showCustomKeyboard() {
    if (_sendCommissionViewModel.price.toStringAsFixed(2) != '0.00')
      _priceController.text = _sendCommissionViewModel.price.toStringAsFixed(2);
    print('价格:_priceController.text:${_priceController.text}');
    _tempPriceController.text = _priceController.text; // 初始化临时输入框内容
    print('临时价格_tempPriceController.text:${_tempPriceController.text}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CustomKeyboard(
          tempPriceController: _tempPriceController,
          onKeyboardTap: _onKeyboardTap,
          onBackspace: _onBackspace,
          onConfirm: _onConfirm,
          onSwitchKeyboard: _onSwitchKeyboard,
          priceController: _priceController,
          id: widget.id,
        );
      },
    );
  }

  // 键盘点击事件
  void _onKeyboardTap(String value) {
    setState(() {
      String text = _tempPriceController.text;
      print('临时价格_tempPriceController.text:${_tempPriceController.text}');
      TextSelection selection = _tempPriceController.selection;
      // print('光标位置 ${selection.baseOffset}');
      // 限制小数点输入和保留两位小数
      if (value == ".") {
        if (text.contains(".")) return;
      } else {
        // 限制输入两位小数  当光标位置在小数点后面时，不允许输入
        if (text.contains(".") &&
            text.split(".")[1].length >= 2 &&
            selection.baseOffset >= text.length) return;
        //不允许在前面输入0
        if (selection.baseOffset == 0 && value == '0') {
          return;
        }
        //如果小数点前长度大于9，则不允许输入
        print('小数点前长度:${text.split(".")[0].length}');
        if (text.split(".")[0].length >= 9) {
          return;
        }
      }
      // 更新输入框内容和光标位置
      int newOffset = selection.baseOffset + value.length;
      _tempPriceController.text = text.substring(0, selection.baseOffset) +
          value +
          text.substring(selection.baseOffset);
      _tempPriceController.selection =
          TextSelection.collapsed(offset: newOffset);
    });
  }

  // 退格键删除最后一个字符
  void _onBackspace() {
    setState(() {
      String text = _tempPriceController.text;
      TextSelection selection = _tempPriceController.selection;
      if (selection.baseOffset > 0) {
        int newOffset = selection.baseOffset - 1;

        _tempPriceController.text =
            text.substring(0, newOffset) + text.substring(newOffset + 1);
        _tempPriceController.selection =
            TextSelection.collapsed(offset: newOffset);
      }
    });
  }

  // 确认按钮点击事件
  void _onConfirm() {
    setState(() {
      _priceController.text = _tempPriceController.text;
      _sendCommissionViewModel.price = double.parse(_priceController.text);
    });
    Navigator.of(context).pop();
  }

  // 切换键盘按钮事件
  void _onSwitchKeyboard() {
    Navigator.of(context).pop();
  }

  //填写备注
  Widget _buildRemarkService() {
    return PopUpAnimation(
        child: Container(
      margin: EdgeInsets.only(top: 20.h),
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    maxLines: 4,
                    focusNode: _focusNodeRemark,
                    onTapOutside: (event) {
                      _focusNodeRemark.unfocus();
                    },
                    onChanged: (text) {
                      setState(() {
                        _sendCommissionViewModel.remark = text;
                      });
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.edit,
                        color: AppColors.appColor,
                      ),
                      hintText: "请输入备注",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      counterText:
                          '${_sendCommissionViewModel.remark?.length} / $_maxLength', // 显示字数
                    ),
                  ),
                )
              ],
            ),
          )),
    ));
  }

  //填写联系方式
  Widget _buildContactService() {
    return PopUpAnimation(
        child: Container(
            margin: EdgeInsets.only(top: 20.h),
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          '手机号',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 95.w,
                        ),
                        Icon(
                          Icons.phone,
                          color: AppColors.appColor,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _focusNodePhone,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // 过滤非数字字符
                              LengthLimitingTextInputFormatter(11),
                            ],
                            onTapOutside: (e) => {_focusNodePhone.unfocus()},
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintText: "请输入手机号",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ))));
  }

  // 设置服务时长--------------------------------------------------------------------
  Widget _buildDurationService() {
    return Selector<SendCommissionViewModel, int?>(
      selector: (context, _sendCommissionViewModel) =>
          _sendCommissionViewModel.selectedDuration,
      builder: (context, selectedDuration, child) {
        return PopUpAnimation(
          child: GestureDetector(
            onTap: () {
              _showDurationPicker(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 20.h),
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    SizedBox(width: 20.w),
                    Text(
                      "服务时长:      ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(width: 10.w),
                        selectedDuration == null
                            ? Text(
                                '请选择服务时长', // 显示选择的服务时长
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              )
                            : widget.id > 6
                                ? Text('${selectedDuration}个月')
                                : Text('${selectedDuration}个小时'),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //时长选择器
  void _showDurationPicker(BuildContext context) {
    print("服务id为${widget.id}");
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 使背景透明
      builder: (BuildContext context) {
        return Container(
          height: 295.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 16.h, bottom: 0.h, left: 20.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '选择服务时长',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // 关闭弹出框
                      },
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
              Expanded(
                child: ListView(
                  children: [
                    widget.id > 6
                        ? _buildDurationOption("1个月")
                        : _buildDurationOption("1个小时"),
                    widget.id > 6
                        ? _buildDurationOption("2个月")
                        : _buildDurationOption("2个小时"),
                    widget.id > 6
                        ? _buildDurationOption("3个月")
                        : _buildDurationOption("3个小时"),
                    widget.id > 6
                        ? _buildDurationOption("4个月")
                        : _buildDurationOption("4个小时"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// 创建一个方法用于生成选项
  Widget _buildDurationOption(String duration) {
    return GestureDetector(
      onTap: () {
        _updateSelectedDuration(duration);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(Icons.access_time, color: AppColors.appColor), // 使用图标
            SizedBox(width: 10.w),
            Text(
              duration,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // 更新选择的服务时长
  void _updateSelectedDuration(String duration) {
    _sendCommissionViewModel
        .updateSelectedDuration(int.parse(duration[0])); // 更新状态
    Navigator.pop(context); // 关闭底部弹出框
  }

  //设置服务时间-----------------------------------------------------------------------------------------------------
  Widget _buildTimeService() {
    return Selector<SendCommissionViewModel, DateTime?>(
      selector: (context, _sendCommissionViewModel) =>
          _sendCommissionViewModel.selectedDate,
      builder: (context, selectedTime, child) {
        return PopUpAnimation(
            child: GestureDetector(
                onTap: () {
                  Pickers.showDatePicker(context, mode: DateMode.MDHM,
                      onConfirm: (value) {
                    _sendCommissionViewModel.updateSelectedDate(DateTime(
                        value.year ?? 0,
                        value.month ?? 0,
                        value.day ?? 0,
                        value.hour ?? 0,
                        value.minute ?? 0));

                    print(
                        'longer >>> 返回数据：${_sendCommissionViewModel.selectedDate}');
                  });
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20.h),
                  height: 60.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        SizedBox(width: 20.w),
                        Text(
                          "服务时间:      ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            SizedBox(width: 10.w),
                            _sendCommissionViewModel.selectedDate == null
                                ? Text('请选择服务时间',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey))
                                : Text(
                                    '${_sendCommissionViewModel.selectedDate?.month}月 ${_sendCommissionViewModel.selectedDate?.day}日 ${_sendCommissionViewModel.selectedDate?.hour}:${_sendCommissionViewModel.selectedDate?.minute}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          ],
                        )
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  //设置服务地点
  Widget _buildAreaService() {
    return PopUpAnimation(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20.h),
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () async {
              // 获取当前已选择的坐标（如果有的话）
              final double? currentLat = _sendCommissionViewModel.latitude;
              final double? currentLng = _sendCommissionViewModel.longitude;

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MapPage(
                        initialLatitude: currentLat,
                        initialLongitude: currentLng,
                      ),
                ),
              );
              if (result != null && mounted) {
                setState(() {
                  _selectedAddress = result['address'];
                  _locationDetail = result['locationDetail'];
                  // 更新 ViewModel 中的位置信息
                  _sendCommissionViewModel.updateLocation(
                      address: result['address'],
                      latitude: result['latitude'].toString(),
                      longitude: result['longitude'].toString(),
                      locationDetail: result['locationDetail']
                  );
                });
                // 打印详细信息
                print('完整地址: ${_selectedAddress}');
                print('位置详情: ');
                print('  - 省份: ${_sendCommissionViewModel.province}');
                print('  - 城市: ${_sendCommissionViewModel.city}');
                print('  - 区/县: ${_sendCommissionViewModel.district}');
                print('  - 经度: ${_sendCommissionViewModel.longitude}');
                print('  - 纬度: ${_sendCommissionViewModel.latitude}');
                print('原始位置信息: ${_locationDetail}');
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    "服务地点:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      _locationDetail?['address'] ?? "请选择服务地点",
                      style: TextStyle(
                        fontSize: 13,
                        color: _locationDetail?['address'] == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.location_on_outlined, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //服务类型
  Widget _buildTypeService() {
    return PopUpAnimation(
        child: Container(
      margin: EdgeInsets.only(top: 20.h),
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Text(
              "服务类型:      ",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              children: [
                Icon(commissionType.icon,
                    size: 30.w, color: AppColors.appColor),
                SizedBox(width: 10.w),
                Text(commissionType.typeText),
                SizedBox(
                  width: 9.w,
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  // 打开地图选择位置
  void _openLocationPicker() async {
    // 获取当前已选择的坐标（如果有的话）
    final double? currentLat = _sendCommissionViewModel.latitude;
    final double? currentLng = _sendCommissionViewModel.longitude;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          initialLatitude: currentLat,
          initialLongitude: currentLng,
        ),
      ),
    );

    if (result != null) {
      // 处理选择的位置结果
      _sendCommissionViewModel.updateLocation(
        address: result['address'],
        latitude: result['latitude'],
        longitude: result['longitude'],
        locationDetail: result['locationDetail'],
      );
    }
  }
}
