
import 'package:flutter/cupertino.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../repository/api/commission_api.dart';
import '../../../repository/model/commission_data1.dart';
import '../../../utils/global.dart';

class CommissionTypeViewModel with ChangeNotifier{

  List<CommissionData1> commissionDataList = [];

  //刷新控制器
  RefreshController refreshController = RefreshController();

  double minPrice = 0.0;
  double maxPrice = 999999;
  double distance = 9999;

  //分页请求
  int startPage = 1;
  int endPage = 1;
  int size = 11;
  bool hasMoreData = true;

  int? typeId;

  bool isLoading = false;

  Future<void> initData() async {
    await getTypeComission({
      "typeId": typeId,
      "distance":distance,
      "latitude":Global.locationInfo?.latitude ?? 39.906217,
      "longitude":Global.locationInfo?.longitude ?? 116.3912757,
      "page": startPage,
      "size": size,
    });
   notifyListeners();
  }

  Future<void> onLoading() async {
    if(hasMoreData){
      endPage++;
      await loadingComission({
        "typeId":typeId,
        "distance":distance,
        "latitude":Global.locationInfo?.latitude ?? 39.906217,
        "longitude":Global.locationInfo?.longitude ?? 116.3912757,
        "page": endPage,
        "size": size,
        "min": minPrice,
        "max":maxPrice,
      });
      if(commissionDataList.length >= 110){
        hasMoreData = false;
        refreshController.loadNoData();
        notifyListeners();
      }else{
        refreshController.loadComplete();
        notifyListeners();
      }
    }else{
      refreshController.loadNoData();
    }
  }

  Future<void> onRefresh() async {
    startPage++;
    await refreshComission({
      "typeId":typeId,
      "distance":distance,
      "latitude":Global.locationInfo?.latitude ?? 39.906217,
      "longitude":Global.locationInfo?.longitude ?? 116.3912757,
      "page": startPage,
      "size": size,
      "min": minPrice,
      "max":maxPrice,
    });
    print("界面刷新");
    hasMoreData = true;
    refreshController.resetNoData();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> siftCommission() async {
    startPage = 1;
    endPage = 1;

    isLoading = true;

    notifyListeners();

    await getTypeComission({
      "typeId":typeId,
      "distance":distance,
      "latitude":Global.locationInfo?.latitude ?? 39.906217,
      "longitude":Global.locationInfo?.longitude ?? 116.3912757,
      "page": startPage,
      "size": size,
      "min": minPrice,
      "max":maxPrice,
    });

    isLoading = false;

    notifyListeners();
  }

  Future<void> getTypeComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList = commissionData;
    }else{
      commissionDataList.clear();
      print("数据为空");
    }
  }

  Future<void> refreshComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty && commissionData.length >= 3){
      this.commissionDataList = commissionData;
    }else{
      if(startPage == 1)return;
      startPage = 1;
      param["page"] = startPage;
      await refreshComission(param);
    }
  }

  Future<void> loadingComission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.getCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList.addAll(commissionData);
    }else{
      if(endPage == 1)return;
      endPage = 1;
      param["page"] = endPage;
      await loadingComission(param);
    }
  }

}