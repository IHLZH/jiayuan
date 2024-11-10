import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/keeper_api.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';

import '../../utils/global.dart';

class HouseKeepingScreeningVM with ChangeNotifier{
  Map<int,List<Housekeeper>> housekeepersByType = {};
  int currentIndex = 0;

  Future<void> loadHouseKeepers(int typeIndex) async {
    print("开始加载数据: index = $typeIndex");
    if(housekeepersByType[typeIndex] != null){
      print("数据加载完成: ${housekeepersByType[typeIndex]?.length ?? 0}条记录");
      return ;
    }
    
    try {
      //模拟网络请求
      await Future.delayed(Duration(milliseconds: 500)); // 缩短延迟时间
      List<Housekeeper>? housekeepers = await KeeperApi.instance.getHousekeeperData(Global.location!.longitude, Global.location!.longitude, id: typeIndex) ;
      housekeepersByType[typeIndex] = housekeepers!;
      notifyListeners();
    } catch (e) {
      print("加载数据失败: $e");
    }
  }



  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}