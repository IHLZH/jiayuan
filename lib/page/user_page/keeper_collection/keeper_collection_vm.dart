import 'package:flutter/cupertino.dart';

import '../../../repository/api/keeper_api.dart';
import '../../../repository/model/Housekeeper _data.dart';


class KeeperCollectionVm extends ChangeNotifier {
  List<Housekeeper> housekeepers = [];

  Future<void> getKeeperCollection() async {
    housekeepers = await KeeperApi.instance.getCollectKeeper();
    print('获取到的收藏数据${housekeepers}');
    notifyListeners();
  }
}
