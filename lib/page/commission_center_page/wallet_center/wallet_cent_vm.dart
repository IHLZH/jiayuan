import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

import '../../../repository/api/commission_api.dart';
import '../../../repository/model/commission_data1.dart';

class WalletCentVm with ChangeNotifier {
  //每个月份的
  Map<OrderTime, List<CommissionData1>> walletCentList = {};
  List<CommissionData1> downByTime = [];

  //最近半年的月份收益
  List<OrderTime> recentHalfYear = [];
  int index = 0;

  CustomPopupMenuController controller = CustomPopupMenuController();

  void init() {
    DateTime now = DateTime.now();
    recentHalfYear = [
      for (int i = 0; i < 6; i++)
        //如果当前月份now.month - i 为0 则减一年
        OrderTime(
            month: now.month - i == 0 ? now.month - i + 12 : now.month - i,
            year: now.month - i == 0 ? now.year - 1 : now.year),
    ];
     getDownOrders(now.year, now.month);
  }

  void changeMonth(int index) {
    this.index = index;
    notifyListeners();
  }

  Future<void> getDownOrders(int year, int month) async {
    if (walletCentList.containsKey(OrderTime(month: month, year: year))) {
      downByTime = walletCentList[OrderTime(month: month, year: year)]!;
    } else {
      List<CommissionData1> down = [];
      down = await CommissionApi.instance.getOrderCompleted(year, month);
      down.sort((a, b) => b.createTime!.compareTo(a.createTime!));
      walletCentList[OrderTime(month: month, year: year)] = down;
      downByTime = down;
    }
    notifyListeners();
  }
}

class OrderTime {
  int? month;
  int? year;

  OrderTime({this.month, this.year});
}
