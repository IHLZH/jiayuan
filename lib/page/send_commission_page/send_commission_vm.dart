          import 'package:flutter/cupertino.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../repository/model/commission_data1.dart';
import '../../repository/model/standardPrice.dart';

class SendCommissionViewModel with ChangeNotifier{

  CommissionData1? commissionData1 ;

  int? selectedDuration ; //服务时长

  DateTime? selectedDate ;//日期

  String? phoneNumber; //手机号

  String? remark = ""; // 备注

  double price = 0.00 ; //价格

  StandardPrice? standardPrice ;

  String? _address;
  double? _latitude;
  double? _longitude;
  Map<String, dynamic>? _locationDetail;

  String? _province;  // 省
  String? _city;     // 市
  String? _district; // 区/县

  String? get address => _address;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  Map<String, dynamic>? get locationDetail => _locationDetail;

  String? get province => _province;
  String? get city => _city;
  String? get district => _district;

  void initData(int id ){
    // standardPrice = Global.standPrices?[id];
    standardPrice = StandardPrice(lowestPrice:  100, referencePrice: 300 , typeId: id);
  }

  bool checkCommisssion() {
    if(selectedDuration != null && selectedDate != null && phoneNumber != null){

      return true ;
    }
    return false ;
  }


  void updateSelectedDuration(int duration){
    selectedDuration = duration;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date){
    selectedDate = date;
    notifyListeners();
  }

  void updateLocation({
    required String address,
    required String latitude,
    required String longitude,
    required Map<String, dynamic> locationDetail,
  }) {
    _address = locationDetail['address'];
    _latitude = double.tryParse(latitude);
    _longitude = double.tryParse(longitude);
    _locationDetail = locationDetail;

    // 更新省市区信息
    _province = locationDetail['pname'];
    _city = locationDetail['cityname'];
    _district = locationDetail['adname'];

    notifyListeners();
  }

}