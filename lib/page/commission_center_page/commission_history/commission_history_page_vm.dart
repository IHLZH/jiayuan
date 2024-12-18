import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../repository/api/commission_api.dart';
import '../../../utils/global.dart';

class CommissionHistoryViewModel with ChangeNotifier{

  List<CommissionData1> commissionHistory = [];

  RefreshController refreshController = RefreshController();

  Future<void> getCommissionHistory() async {
    try{
      final result = await Global.dbUtil?.db.query('commission_browser_history', orderBy : "browerTime DESC",where: 'uid = ?',whereArgs: [Global.userInfo?.userId]);
      result?.forEach((item) {
        CommissionData1 commission = CommissionData1.fromSqData(item);
        commissionHistory.add(commission);
      });
      print("查询委托历史浏览记录成功，共查询到${commissionHistory.length}条");
    }catch(e){
      print("查询委托历史浏览记录失败${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> clearCommissionHistory() async {
    final result = await Global.dbUtil?.db.delete('commission_browser_history');
    if(result != null){
      commissionHistory.clear();
      print("删除委托历史浏览记录成功，共删除${result}条");
    }else{
      print("删除委托历史浏览记录失败");
    }
    notifyListeners();
  }

  Future<void> onRefresh() async {
    commissionHistory.clear();
    await getCommissionHistory();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<CommissionData1> getCommissionDetail(int commissionId) async {
    CommissionData1 commissionData = await CommissionApi.instance.getCommissionById({
      "commissionId" : commissionId,
      "lng" : Global.locationInfo?.longitude ?? "",
      "lat" : Global.locationInfo?.latitude ?? "",
    });
    return commissionData;
  }

  @override
  void dispose() {
    super.dispose();
    commissionHistory.clear();
  }
}