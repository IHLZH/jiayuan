
import 'package:flutter/cupertino.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';

class CommissionTypeViewModel with ChangeNotifier{

  IconData? typeIcon;
  String? typeText;
  List<Commission> commissionList = [];

  void getType(int id){
    this.typeIcon = CommissionViewModel.CommissionTypes[id].icon;
    this.typeText = CommissionViewModel.CommissionTypes[id].typeText;
  }

}