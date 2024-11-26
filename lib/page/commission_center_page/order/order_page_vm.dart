import 'package:flutter/widgets.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/utils/common_data.dart';
import 'package:jiayuan/utils/global.dart';


class OrderPageViewModel with ChangeNotifier{

  //待服务
  List<CommissionData1> unServed = [];
  //服务中
  List<CommissionData1> inService = [];
  //待支付
  List<CommissionData1> unPay = [];
  //已完成
  List<CommissionData1> down = [];

  int? currentIndex;

  List<CommissionData1> getStatusOrder(int id){
    switch(id){
      case 2:
        return unServed;
      case 3:
        return inService;
      case 4:
        return unPay;
      case 5:
        return down;
      default: return [];
    }
  }

  void getOrders(){
    unServed = [
      CommissionData1(
          commissionId: 2,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          commissionAddress: "河北师范大学诚朴园三号楼204",
          userPhoneNumber: "19358756689",
          distance: 1.5,
          commissionBudget: 255.25,
          expectStartTime: DateTime(2024,11,2,12,30),
          commissionStatus: 2,
          typeName: "日常保洁"
      ),
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 2,
          typeName: "日常保洁"
      ),
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 2,
          typeName: "日常保洁"
      ),
    ];

    inService = [
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 3,
          typeName: "日常保洁"
      ),
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 3,
          typeName: "日常保洁"
      ),
    ];

    unPay = [
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 4,
          typeName: "日常保洁"
      ),
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 4,
          typeName: "日常保洁"
      ),
    ];

    down = [
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 5,
          typeName: "日常保洁"
      ),
      CommissionData1(
        commissionId: 2,
        province: "河北省",
        city: "石家庄",
        county: "裕华区",
        commissionAddress: "河北师范大学诚朴园三号楼204",
        userPhoneNumber: "19358756689",
        distance: 1.5,
        commissionBudget: 255.25,
        expectStartTime: DateTime(2024,11,2,12,30),
        commissionStatus: 5,
          typeName: "日常保洁"
      ),
    ];
  }

  Future<void> getUnServedOrders() async {
    unServed = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 2,
          "page" : 1,
          "pageSize" : 10
        }
    );
    notifyListeners();
  }

  String getCountyAddress(CommissionData1 commission){
    return commission.county + " " + commission.commissionAddress + "河北师范大学诚朴园三号楼204";
  }

}