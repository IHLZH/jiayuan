
import 'package:flutter/cupertino.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';

import '../../../repository/api/commission_api.dart';
import '../../../repository/model/commission_data1.dart';

class CommissionTypeViewModel with ChangeNotifier{

  List<Commission> commissionList = [];

  List<CommissionData1> commissionDataList = [];

  double minPrice = 0.0;
  double maxPrice = 999999;
  double distance = 9999;

  //分页请求
  int startPage = 1;
  int endPage = 1;
  int size = 11;
  bool hasMoreData = true;

  //模拟网络请求，根据类型获取对应委托
  void getCommissionByType(int typeId){
    this.commissionList = [
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,5,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: typeId,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
    ];
  }

  Future<void> getTypeComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      print("数据为空");
    }
  }

  Future<void> refreshComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      startPage = 1;
      param["page"] = startPage;
      await getTypeComission(param);
    }
  }



  Future<void> loadingComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList.addAll(commissionData);
    }else{
      endPage = 1;
      param["page"] = endPage;
      await loadingComission(param);
    }
  }

}