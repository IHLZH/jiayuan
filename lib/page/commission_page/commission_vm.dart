
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/api/api.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';

class CommissionViewModel with ChangeNotifier{

  //委托类型表
  static List<CommissionType> CommissionTypes = [
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

  List<Commission> testCommissions =  [
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,2,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,3,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,4,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,5,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,2,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,2,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,3,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,4,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,2,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,3,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
    Commission(
        commissionType: 1,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        address: "河北师范大学诚朴园三号楼204",
        userPhone: "19358756689",
        distance: 1.5,
        price: 255.25,
        expectTime: DateTime(2024,11,4,12,30),
        estimatedTime: 2,
        commissionStatus: 0,
        isLong: false
    ),
  ];

  List<Commission> commissions = [];

  List<CommissionData1> commissionDataList = [];

  //模拟网络请求
  void getCommissionData(){
    this.commissions = testCommissions;
  }

  //分页请求
  int startPage = 0;
  int endPage = 0;
  int size = 11;

  Future<void> getRecommendComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getRecommendCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      print("数据为空");
    }
  }
}

//委托类型类，图标加文本
class CommissionType{
  IconData icon;
  String typeText;

  CommissionType({required this.icon, required this.typeText});
}