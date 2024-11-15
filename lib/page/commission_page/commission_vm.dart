
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';

class CommissionViewModel with ChangeNotifier{

  //委托类型表
  static List<CommissionType> CommissionTypes = [
    CommissionType(icon: Icons.import_contacts, typeText: ""),
    CommissionType(
        icon: Icons.house,
        typeText: "日常保洁"
    ),
    CommissionType(
        icon: Icons.auto_fix_high,
        typeText: "家电维修"
    ),
    CommissionType(
        icon: Icons.car_crash,
        typeText: "搬家搬厂"
    ),
    CommissionType(
        icon: Icons.fastfood,
        typeText: "收纳整理"
    ),
    CommissionType(
        icon: Icons.handyman,
        typeText: "管道疏通"
    ),
    CommissionType(
        icon: Icons.precision_manufacturing,
        typeText: "维修拆装"
    ),
    CommissionType(
        icon: Icons.baby_changing_station,
        typeText: "保姆月嫂"
    ),
    CommissionType(
        icon: Icons.elderly,
        typeText: "居家养老"
    ),
    CommissionType(
        icon: Icons.bedroom_baby,
        typeText: "居家托育"
    ),
    CommissionType(
        icon: Icons.child_care,
        typeText: "专业养护"
    ),
    CommissionType(
        icon: Icons.family_restroom,
        typeText: "家庭保健"
    ),
  ];

  //推荐委托表
  List<CommissionData1> commissionDataList = [];

  //分页请求
  int startPage = 1;
  int endPage = 1;
  int size = 11;
  bool hasMoreData = true;

  double distance = 10;

  Future<void> getRecommendComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.recommendCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      commissionDataList.clear();
      print("数据为空");
    }
  }

  Future<void> refreshComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.recommendCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      startPage = 1;
      param["page"] = startPage;
      await refreshComission(param);
    }
  }

  Future<void> loadingComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.recommendCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList.addAll(commissionData);
    }else{
      endPage = 1;
      param["page"] = endPage;
      await loadingComission(param);
    }
  }
}

//委托类型类，图标加文本
class CommissionType{
  IconData icon;
  String typeText;

  CommissionType({required this.icon, required this.typeText});
}