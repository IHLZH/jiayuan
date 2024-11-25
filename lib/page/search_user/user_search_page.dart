import 'package:flutter/material.dart';
import 'package:jiayuan/page/search_user/user_search_vm.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

bool isProduction = Constants.IS_Production;

class UserSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserSearchPageState();
  }
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  UserSearchViewModel _userSearchViewModel = UserSearchViewModel();

  @override
  void initState() {
    super.initState();
    _userSearchViewModel = UserSearchViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _userSearchViewModel,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "搜索用户",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "输入搜索信息",
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                _userSearchViewModel
                                    .searchUsers(_searchController.text);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<UserSearchViewModel>(
                builder: (context, vm, child) {
                  return SmartRefresher(
                    controller: vm.refreshController,
                    enablePullUp: true, //允许上拉加载更多
                    enablePullDown: true, //允许下拉刷新
                    onLoading: () async {
                      if (vm.hasMoreData) {
                        await vm.loadMoreUsers();
                      }
                      vm.refreshController.loadComplete(); //完成加载更多
                    },
                    onRefresh: () async {
                      await vm.refreshUsers();
                      vm.refreshController.refreshCompleted();
                    },
                    header: ClassicHeader(
                      idleText: "下拉刷新",
                      refreshingText: "刷新中",
                      completeText: "刷新完成",
                      failedText: "刷新失败",
                      idleIcon: Icon(Icons.arrow_downward),
                    ),
                    footer: ClassicFooter(
                      idleText: "上拉加载更多",
                      canLoadingText: "上拉加载更多",
                      noDataText: "没有更多数据",
                    ),
                    child: ListView.builder(
                      itemCount: vm.userList.length,
                      itemBuilder: (context, index) {
                        SearchUser searchUser = vm.userList[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              leading: CircleAvatar(
                                backgroundImage: searchUser.userAvatar == '默认头像'
                                    ? AssetImage("assets/images/ikun1.png")
                                    : NetworkImage(searchUser.userAvatar +
                                        '?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
                                radius: 30,
                              ),
                              title: Text(
                                searchUser.nickName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    searchUser.userPhoneNumber,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    searchUser.email ?? "无邮箱",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Divider(),
                                ],
                              ),
                              onTap: () {
                                // TODO: 点击用户的操作
                                if (isProduction) print("点击了用户${index}");
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
