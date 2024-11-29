import 'package:flutter/widgets.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/utils/common_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


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

  RefreshController unServedRefreshController = RefreshController();
  RefreshController inServiceRefreshController = RefreshController();
  RefreshController unPayRefreshController = RefreshController();
  RefreshController downRefreshController = RefreshController();

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

  Future<void> onRefreshUnServed() async {
    await getUnServedOrders();
    unServedRefreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onRefreshInService() async {
    await getInServiceOrders();
    inServiceRefreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onRefreshUnPay() async {
    await getUnPayOrders();
    unPayRefreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onRefreshDown() async {
    await getDownOrders();
    downHasMoreData = true;
    downRefreshController.resetNoData();
    downRefreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onLoadingDown() async {
    if(downHasMoreData){
      downOrderCurrentpage++;
      List<CommissionData1> downData = await CommissionApi.instance.getOrderByStatus(
          {
            "keeperId" : Global.keeperInfo?.keeperId,
            "status" : 5,
            "page" : downOrderCurrentpage,
            "pageSize" : 10
          }
      );
      if(downData.length < 10){
        down.addAll(downData);
        downHasMoreData = false;
        downRefreshController.loadNoData();
        notifyListeners();
      }else{
        down.addAll(downData);
        downRefreshController.loadComplete();
        notifyListeners();
      }
    }else{
      downRefreshController.loadNoData();
      notifyListeners();
    }
  }

  //已完成订单分页请求页码
  int downOrderCurrentpage = 1;

  bool downHasMoreData = true;

  Future<void> initOrders() async {
    await getUnServedOrders();
    await getInServiceOrders();
    await getUnPayOrders();
    await getDownOrders();
    notifyListeners();
  }

  Future<void> getUnServedOrders() async {
    unServed = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 2,
          "page" : 1,
          "pageSize" : 100
        }
    );
  }

  Future<void> getInServiceOrders() async {
    inService = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 3,
          "page" : 1,
          "pageSize" : 100
        }
    );
  }

  Future<void> getUnPayOrders() async {
    unPay = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 4,
          "page" : 1,
          "pageSize" : 100
        }
    );
  }

  Future<void> getDownOrders() async {
    down = await CommissionApi.instance.getOrderByStatus(
        {
          "keeperId" : Global.keeperInfo?.keeperId,
          "status" : 5,
          "page" : downOrderCurrentpage,
          "pageSize" : 10
        }
    );
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

  void clear(){

  }

}