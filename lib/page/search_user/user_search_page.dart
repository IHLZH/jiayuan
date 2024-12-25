import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/search_user/user_search_vm.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
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
    // _userSearchViewModel = UserSearchViewModel();
  }

  Future<void> _jumpToUserInfoPage(SearchUser user) async {
    await RouteUtils.pushForNamed(context, RoutePath.userInfoPage,
        arguments: {"user": user});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _userSearchViewModel,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 45),
                  child: Row(
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
                        child: TextField(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "输入(昵称/邮箱/手机号)",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: AppColors.searchBgColor,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                _userSearchViewModel
                                    .searchUsers(_searchController.text);
                              },
                            ),
                          ),
                          onSubmitted: (value) {
                            _userSearchViewModel.searchUsers(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: AppColors.backgroundColor5,
            child: Column(
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
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  leading: CircleAvatar(
                                    backgroundImage: searchUser.userAvatar == '默认头像'
                                        ? AssetImage("assets/images/ikun1.png")
                                        : CachedNetworkImageProvider(
                                        searchUser.userAvatar!),
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
                                      // Divider(),
                                    ],
                                  ),
                                  onTap: () {
                                    if (isProduction) print("点击了用户${index}");
                                    FocusScope.of(context).unfocus();

                                    _jumpToUserInfoPage(searchUser);
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
        )
      ),
    );
  }
}
