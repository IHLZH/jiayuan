import 'package:flutter/material.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

bool isProduction = Constants.IS_Production;

class UserSearchViewModel with ChangeNotifier {
  List<SearchUser> userList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int currentPage = 1;
  bool hasMoreData = true;
  int totalCount = 1000;
  String _query = '';

  Future<void> searchUsers(String query) async {
    currentPage = 1;
    _query = query;
    hasMoreData = true;
    userList.clear();
    await fetchUsers(_query);
  }

  Future<void> loadMoreUsers() async {
    if (hasMoreData) {
      currentPage++;
      if (isProduction) {
        print("search: $_query page: $currentPage");
      }
      await fetchUsers(_query);
    } else {
      refreshController.loadNoData();
      return;
    }
  }

  Future<void> refreshUsers() async {
    currentPage = 1;
    userList.clear();
    hasMoreData = true;
    await fetchUsers(_query);
    refreshController.refreshCompleted();
  }

  Future<void> fetchUsers(String? query) async {
    if (query == null || query == '') {
      return;
    }

    if (isProduction) {
      print("search: $query page: $currentPage");
    }

    SearchUserResult result =
        await UserApi.instance.searchUsers(query, currentPage);

    if (userList.length + result.users.length >= totalCount) {
      hasMoreData = false;
    }

    if (result.users.isNotEmpty) {
      userList.addAll(result.users);
      totalCount = result.total;
      notifyListeners();
    }

    refreshController.loadComplete();
    refreshController.refreshCompleted();
  }
}
