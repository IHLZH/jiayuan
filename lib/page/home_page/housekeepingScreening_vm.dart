import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/keeper_api.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/global.dart';
import 'home_vm.dart';

class HouseKeepingScreeningVM with ChangeNotifier {
  static HouseKeepingScreeningVM instance = HouseKeepingScreeningVM._();

  HouseKeepingScreeningVM._() {
    loadMoreHouseKeepers(0);
  }

  Map<int, List<Housekeeper>> housekeepersByType = Map.fromIterable(
    HomeViewModel.CommissionTypes.asMap().keys,
    key: (index) => index,
    value: (index) => <Housekeeper>[],
  );
  int currentIndex = 0;
  List<bool> hasMoreData =
      List.generate(HomeViewModel.CommissionTypes.length, (index) => true);

  List<RefreshController> refreshControllers = List.generate(
      HomeViewModel.CommissionTypes.length, (index) => RefreshController());

  //上拉加载更多
  Future<void> loadMoreHouseKeepers(int typeIndex) async {
    print("开始加载更多数据: index = $typeIndex");
    if (hasMoreData[typeIndex]) {
      try {
        List<Housekeeper> housekeepers =
            await KeeperApi.instance.getHousekeeperData(
          Global.locationInfo!.longitude,
          Global.locationInfo!.latitude,
          id: typeIndex+1,
        );
        housekeepersByType[typeIndex]!.addAll(housekeepers);
        if (housekeepers.length < 10) {
          hasMoreData[typeIndex] = false;
          refreshControllers[typeIndex].loadNoData();
        } else {
          refreshControllers[typeIndex].loadComplete();
        }
      } catch (e) {
        print("加载更多数据失败: $e");
      }
    }
    notifyListeners();
  }

  //下拉刷新
  Future<void> refreshHouseKeepers(int typeIndex) async {
    print("开始刷新数据: index = $typeIndex");
    if (hasMoreData[typeIndex]) {
      try {
        //模拟网络请求
        await Future.delayed(Duration(milliseconds: 500)); // 缩短延迟时间
        List<Housekeeper> housekeepers =
            await KeeperApi.instance.getHousekeeperData(
          Global.locationInfo!.longitude,
          Global.locationInfo!.longitude,
          id: typeIndex+1,
        );
        housekeepersByType[typeIndex] = housekeepers;
        if (housekeepers.length < 10) {
          hasMoreData[typeIndex] = false;
          refreshControllers[typeIndex].loadNoData();
        }
      } catch (e) {
        print("刷新数据失败: $e");
      }
    }
    refreshControllers[typeIndex].refreshCompleted();
    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void dispose() {
    print("被销毁了");
    for (var controller in refreshControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
