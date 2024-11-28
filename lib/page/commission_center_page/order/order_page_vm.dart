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

  //已完成订单分页请求页码
  int downOrderCurrentpage = 1;

  Future<void> getServedOrders() async {
    unServed = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 2,
          "page" : 1,
          "pageSize" : 100
        }
    );
    inService = await CommissionApi.instance.getOrderByStatus(
      {
        "keeperId" : Global.keeperInfo?.keeperId,
        "status" : 3,
        "page" : 1,
        "pageSize" : 100
      }
    );
    unPay = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 4,
          "page" : 1,
          "pageSize" : 100
        }
    );
    down = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 5,
          "page" : downOrderCurrentpage,
          "pageSize" : 10
        }
    );
    notifyListeners();
  }

  Future<int> changeCommissionStatus(CommissionData1 commissionData, int newStatu) async {
    if((Global.userInfo?.userType ?? 0) == 1){
      bool result = await CommissionApi.instance.changeOrderStatus({
        "commissionId":commissionData.commissionId,
        "new":newStatu
      });
      if(result) {
        return 1;
      }else{
        return 0;
      }
    }
    return 2;
  }

  String getCountyAddress(CommissionData1 commission){
    return commission.county + " " + commission.commissionAddress + "河北师范大学诚朴园三号楼204";
  }

}