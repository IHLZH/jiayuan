
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/sqlite/dbutil.dart';
import 'package:jiayuan/utils/gaode_map/gaode_map.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/global.dart';

class CommissionViewModel with ChangeNotifier{

  //推荐委托表
  List<CommissionData1> commissionDataList = [];

  //刷新控制器
  RefreshController refreshController = RefreshController();

  //分页请求
  int startPage = 1;
  int endPage = 1;
  int size = 11;
  bool hasMoreData = true;

  double distance = 10;

  bool isLoading = false;

  Future<void> initData() async {
    isLoading = true;
    await getRecommendComission({
      "longitude":Global.locationInfo?.longitude ?? 0.0,
      "latitude":Global.locationInfo?.latitude ?? 0.0,
      "distance":10,
      "page": startPage,
      "size": size
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> onLoading() async {
    if(hasMoreData){
      endPage++;
      await loadingComission({
        "longitude":Global.locationInfo?.longitude ?? 0.0,
        "latitude":Global.locationInfo?.latitude ?? 0.0,
        "distance":10,
        "page": endPage,
        "size": size
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
      "longitude":Global.locationInfo?.longitude ?? 0.0,
      "latitude":Global.locationInfo?.latitude ?? 0.0,
      "distance":10,
      "page": startPage,
      "size": size
    });
    hasMoreData = true;
    refreshController.resetNoData();
    refreshController.refreshCompleted();
    notifyListeners();
  }

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
    refreshLocation();
    List<CommissionData1> commissionData = await CommissionApi.instance.recommendCommission(param);
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
    List<CommissionData1> commissionData = await CommissionApi.instance.recommendCommission(param);
    if(!commissionData.isEmpty){
      this.commissionDataList.addAll(commissionData);
    }else{
      if(endPage == 1)return;
      endPage = 1;
      param["page"] = endPage;
      await loadingComission(param);
    }
  }

  Future<void> refreshLocation() async {
    await GaodeMap.instance.doSingleLocation();
    notifyListeners();
  }

  Future<void> addToHistory(CommissionData1 commission) async {
    await Global.dbUtil?.db.insert("commission_browser_history", commission.toSqData(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("委托历史${commission.commissionId}记录插入成功");
  }
}

//委托类型类，图标加文本
class CommissionType{
  IconData icon;
  String typeText;

  CommissionType({required this.icon, required this.typeText});
}