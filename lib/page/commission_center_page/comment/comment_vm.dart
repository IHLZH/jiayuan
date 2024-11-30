import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../repository/api/keeper_api.dart';

class CommentViewModel with ChangeNotifier {
  List<Evaluation> evaluations = [];
  RefreshController refreshController = RefreshController();
  int keeperId = 0;
  bool isHasMore = true;
  int page = 1;

  Future<void> getComments() async {
    evaluations = await KeeperApi.instance.getComments(keeperId, page, 10);
    notifyListeners();
  }

  Future<void> getMoreComments() async {
    if (isHasMore) {
      List<Evaluation>? list =
          await KeeperApi.instance.getComments(keeperId, page, 10);
      page += 1;
      if (list.length < 10) {
        isHasMore = false;
        refreshController.loadComplete();
        print("qwq");
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      evaluations.addAll(list);
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    evaluations= [];
    isHasMore = true;
    List<Evaluation>? list = await KeeperApi.instance.getComments(keeperId, page, 10);
    if (list.length == 0 && page != 1) {
      page = 1;
      list = await KeeperApi.instance.getComments(keeperId, page, 10);
    }
    page += 1;
    evaluations.addAll(list);
    refreshController.refreshCompleted();
    notifyListeners();
  }
}
