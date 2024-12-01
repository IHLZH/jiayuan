import 'package:flutter/cupertino.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../repository/api/commission_api.dart';
import '../../repository/model/commission_data1.dart';
import '../../repository/model/standardPrice.dart';

class SendCommissionViewModel with ChangeNotifier{
  CommissionData1? commission ;
  //手机号格式验证
  RegExp reg_tel = RegExp(r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
  int? selectedDuration ; //服务时长
  int? id ;
  DateTime? selectedDate ;//日期

  String _phoneNumber = ""; // 手机号sd
  String remark = ""; // 备注

  double price = 0.00 ; //价格

  StandardPrice? standardPrice ;
  //门牌号
  String? _doorNumber;

  String? _address;
  double? _latitude;
  double?  _longitude;
  Map<String, dynamic>? _locationDetail;

  String? _province;  // 省
  String? _city;     // 市
  String? _district; // 区/县

  String get phoneNumber => _phoneNumber;

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  Map<String, dynamic>? get locationDetail => _locationDetail;

  String? get province => _province;
  String? get city => _city;
  String? get district => _district;

  String? get doorNumber => _doorNumber;

   //发布委托
  Future<bool> sendCommission() async{
    try{
      commission = CommissionData1(
          commissionBudget: price,
          downPayment: price/10.0,
          commissionDescription: remark,
          commissionAddress: _address!+doorNumber.toString(),
          lng: _longitude,
          lat: _latitude,
          province: _province,
          city: _city,
          county: _district,
          userPhoneNumber: _phoneNumber,
          specifyServiceDuration: selectedDuration?.toString(),
          expectStartTime: selectedDate
      );
     // print(commission?.toJson());
      var res = await CommissionApi.instance.sendCommission(commission!,id!+1);
      if(res == "200"){
        return true;
      }else{
        return false;
      }
    }catch(e){

    }
    return false;
  }

  void initData(int id ){
     standardPrice = Global.standPrices?[id];
  }

  bool checkCommisssion() {
    if (selectedDuration != null && 
        selectedDate != null && 
        _phoneNumber.length == 11 &&  // 确保手机号长度为11位
        _address != null  // 确保已选择地址
        || price != 0.00) {
      return true;
    }
    return false;
  }

  // 验证委托信息并返回错误信息
  String? validateCommission() {
    if (_phoneNumber.isEmpty) {
      return "请输入手机号";
    }
    if (_phoneNumber.length != 11 || !reg_tel.hasMatch(_phoneNumber)) {
      return "手机号格式不正确";
    }
    if (_address == null || _address!.isEmpty) {
      return "请选择服务地点";
    }
    if (_doorNumber == null || _doorNumber!.isEmpty) {
      return "请输入门牌号";
    }
    if (selectedDuration == null) {
      return "请选择服务时长";
    }
    if (selectedDate == null) {
      return "请选择服务日期";
    }
    if(price == 0.00){
      return "请输入价格";
    }
    return null;
  }


  //更新选择的服务时长
  void updateSelectedDuration(int duration){
    selectedDuration = duration;
    notifyListeners();
  }
  //更新选择的日期
  void updateSelectedDate(DateTime date){
    selectedDate = date;
    notifyListeners();
  }


  //更新地址
  void updateLocation({
    required String address,
    required String latitude,
    required String longitude,
    required Map<String, dynamic> locationDetail,
  }) {
    _address = locationDetail['address'] ;
    _latitude = double.tryParse(latitude);
    _longitude = double.tryParse(longitude);
    _locationDetail = locationDetail;

    // 更新省市区信息
    _province = locationDetail['pname'];
    _city = locationDetail['cityname'];
    _district = locationDetail['adname'];

    notifyListeners();
  }

  // 更新手机号
  void updatePhoneNumber(String number) {
    _phoneNumber = number;
    notifyListeners();
  }

  // 更新备注
  void updateRemark(String text) {
    remark = text;
    notifyListeners();
  }

  void updateDoorNumber(String number) {
    _doorNumber = number;
    notifyListeners();
  }

}