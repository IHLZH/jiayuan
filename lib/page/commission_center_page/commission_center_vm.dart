import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiayuan/utils/global.dart';
import '../../repository/api/commission_api.dart';
import '../../repository/model/commission_data1.dart';

class CommissionCenterViewModel with ChangeNotifier{
  //已完成
  List<CommissionData1> down = [];
  //已完成订单的类型映射为数量
  Map<String, int> downTypeMap = {};

  Map<String,Color>? colorMap = {};

  double sumPrice = 0;
  init() async{
    DateTime now = DateTime.now();
    colorMap = {
      "日常保洁":Colors.red,
      "家电维修":Colors.blue,
      "搬家搬厂":Colors.green,
      "收纳整理":Colors.lightGreenAccent,
      "管道疏通":Colors.greenAccent,
      "维修拆装":Colors.deepPurpleAccent,
      "保姆月嫂":Colors.pinkAccent,
      "居家养老":Colors.brown,
      "专业养护":Colors.amberAccent,
      "家庭保健":Colors.cyanAccent,
      "居家托育":Colors.lightBlueAccent,
    };
    await getDownOrders(now.year, now.month);
  }

  Future<void> getDownOrders(int year , int month) async {
    down = await CommissionApi.instance.getOrderCompleted(year, month);
    downTypeMap = down.fold<Map<String, int>>({
    }, (previousValue, element) {
      if(previousValue.containsKey(element.typeName)){
        previousValue[element.typeName] = previousValue[element.typeName]! + 1;
      }else{
        previousValue[element.typeName] = 1;
      }
      sumPrice += element.commissionBudget;
      return previousValue;
    });
    int sum = 0 ;
    String key1 = "";
    downTypeMap.forEach((key, value) {
      key1 = key;
      downTypeMap[key] = ((value/down.length)*100).toInt();
      sum +=  downTypeMap[key]!;
    });
    if(key1 != "")
    downTypeMap[key1] = 100 - sum +  downTypeMap[key1]!;
    if(down.length != Global.keeperInfo!.completedOrders){
      Global.keeperInfo!.completedOrders = down.length;
    }
    notifyListeners();
  }
}