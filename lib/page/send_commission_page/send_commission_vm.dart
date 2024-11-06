import 'package:flutter/cupertino.dart';
import 'package:jiayuan/utils/global.dart';

import '../../repository/model/StandardPrice.dart';

class SendCommissionViewModel with ChangeNotifier{

  int? selectedDuration ; //服务时长

  DateTime? selectedDate ;//日期

  String? phoneNumber; //手机号

  String? remark ; // 备注

  double?  longitude ; // 经度

  double? latitude ; //纬度

  double price = 0.00 ; //价格

  StandardPrice? standardPrice ;

  void initData(int id ){
    // standardPrice = Global.standPrices?[id];
    standardPrice = StandardPrice(lowestPrice:  100, referencePrice: 300 , typeId: id);
  }

  bool checkCommisssion(){
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

}