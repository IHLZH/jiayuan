import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:jiayuan/page/send_commission_page/send_commission_vm.dart';
import 'package:oktoast/oktoast.dart';
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
  bool _isProcessing = false;

  late CommissionType commissionType;

  SendCommissionViewModel _sendCommissionViewModel = SendCommissionViewModel();

  FocusNode _focusNodePhone = FocusNode();
  FocusNode _focusNodeRemark = FocusNode();
  FocusNode _focusNodeDoorNumber = FocusNode();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _tempPriceController = TextEditingController();

  final int _maxLength = 100; // 最大字数限制

  @override
  void initState() {
    _sendCommissionViewModel.id = widget.id;
    super.initState();
    commissionType = HomeViewModel.CommissionTypes[widget.id];
    print(commissionType.typeText);
  }

  @override
  void dispose() {
    _focusNodePhone.dispose();
    _focusNodeRemark.dispose();
    _focusNodeDoorNumber.dispose();
    _priceController.dispose();
    _tempPriceController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SendCommissionViewModel>(
      create: (context) => _sendCommissionViewModel,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: Colors.green,
            selectionHandleColor: Colors.greenAccent,
            cursorColor: Colors.greenAccent,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
            child: Stack(
              children: [
                Column(
                  children: [
                    // AppBar
                    Container(
                      child: AppBar(
                        title: Text("需求发布"),
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                    // 主要内容区域
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: 30.w,
                          right: 30.w,
                          bottom: 100.h,
                        ),
                        child: Column(
                          children: [
                            //服务类型
                            _buildTypeService(),
                            //备注
                            _buildRemarkService(),
                            // 联系方式
                            _buildContactService(),
                            // 地点
                            _buildAreaService(),
                            //时间
                            _buildTimeService(),
                            // 服务时长
                            _buildDurationService(),
                            // 价格
                            _buildPriceService(),
                            // 在最底部添加一个额外的间距
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // 发布按钮 - 固定在底部
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 30.w, bottom: 20.h),
                    child: _buildPostService(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostService() {
    return Selector<SendCommissionViewModel, bool>(
      selector: (_, viewModel) => viewModel.checkCommisssion(),
      builder: (context, canSubmit, child) {
        return Container(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(35),
              onTap: () async{
                // 获取验证结果
              if(_isProcessing )
                return ;
              setState(() {
                _isProcessing = true;
              });
              try{
                String? errorMessage = context
                    .read<SendCommissionViewModel>()
                    .validateCommission();
                if (errorMessage != null) {
                  // 显示错误提示
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('提示'),
                      content: Text(errorMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('确定'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // 验证通过，执行发布操作
                  if(await _sendCommissionViewModel.sendCommission()){
                    showToast('发布成功');
                    Navigator.pop(context);
                  }else{
                    showToast("发布失败");
                  }
                }
              }finally{
                setState(() {
                  _isProcessing = false;
                });
              }



              },
              child: Center(
                child: Text(
                  '发布',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
    return Selector<SendCommissionViewModel, int>(
      selector: (_, viewModel) => viewModel.remark.length,
      builder: (context, remarkLength, child) {
        return PopUpAnimation(
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            width: double.infinity,
            height: 90.h,
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
                            fontWeight: FontWeight.w400
                        ),
                        maxLines: 2,
                        focusNode: _focusNodeRemark,
                        onTapOutside: (event) {
                          _focusNodeRemark.unfocus();
                        },
                        onChanged: (text) {
                          context.read<SendCommissionViewModel>().updateRemark(text);
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
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          counterText: '$remarkLength / $_maxLength',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //填写联系方式
  Widget _buildContactService() {
    return Selector<SendCommissionViewModel, String>(
      selector: (_, viewModel) => viewModel.phoneNumber,
      builder: (context, phoneNumber, child) {
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
                      SizedBox(width: 20.w),
                      Text('手机号', style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Icon(Icons.phone, color: AppColors.appColor),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNodePhone,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          onTapOutside: (e) => _focusNodePhone.unfocus(),
                          onChanged: (value) {
                            context.read<SendCommissionViewModel>().updatePhoneNumber(value);
                          },
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
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
              ),
            ),
          ),
        );
      },
    );
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
                  Pickers.showDatePicker(context, mode: DateMode.YMDHM,
                      onConfirm: (value) {
                        _sendCommissionViewModel.updateSelectedDate(DateTime(
                            value.year ?? 0,
                            value.month ?? 0,
                            value.day ?? 0,
                            value.hour ?? 0,
                            value.minute ?? 0));
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
                              '${_sendCommissionViewModel.selectedDate?.month}月 ${_sendCommissionViewModel.selectedDate?.day}日 ${_sendCommissionViewModel.selectedDate?.hour}:${_sendCommissionViewModel.selectedDate?.minute.toString().padLeft(2, '0')}',
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
    return Selector<SendCommissionViewModel, Map<String, dynamic>?>(
      selector: (_, viewModel) => viewModel.locationDetail,
      builder: (context, locationDetail, child) {
        return PopUpAnimation(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: [
                  // 服务地点选择
                  GestureDetector(
                    onTap: () async {
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
                        _sendCommissionViewModel.updateLocation(
                            address: result['address'],
                            latitude: result['latitude'].toString(),
                            longitude: result['longitude'].toString(),
                            locationDetail: result['locationDetail']
                        );
                      }
                    },
                    child: Container(
                      height: 60.h,
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
                              locationDetail?['address'] ?? "请选择服务地点",
                              style: TextStyle(
                                fontSize: 13,
                                color: locationDetail?['address'] == null
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
                  // 分割线
                  Divider(height: 1, color: Colors.grey.shade300),
                  // 门牌号输入框
                  Container(
                    height: 50.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          "门牌号:",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 35.w),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              context.read<SendCommissionViewModel>().updateDoorNumber(value);
                            },
                            focusNode: _focusNodeDoorNumber,
                            onTapOutside: (_) {
                              _focusNodeDoorNumber.unfocus();
                            },
                            style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              hintText: "请输入详细门牌号",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    // 获取当前已选择的坐（如果有的话）
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
