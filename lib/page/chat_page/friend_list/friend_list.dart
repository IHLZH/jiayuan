import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/sliver/sliver_header.dart';
import 'package:jiayuan/page/chat_page/friend_list/friend_list_vm.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_path.dart';
class FriendList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendListState();
  }
}
class FriendListState extends State<FriendList> with TickerProviderStateMixin{
  FriendListViewModel _friendListVM = FriendListViewModel.instance;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this
    );
    _friendListVM.getFriendList();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _friendListVM,
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor3,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                        Colors.white,      // 渐变结束颜色
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    height: 250.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: (){
                                  RouteUtils.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              child: Text(
                                "好友/群组",
                                style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                        Builder(
                            builder: (context) =>GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.more_horiz),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              )
          ),
          body: Consumer<FriendListViewModel>(
              builder: (context, vm, child){
                return NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      // 搜索框
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          height: 50,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(child: SearchTopBar()),
                            ],
                          ),
                        ),
                      ),
                      // 间距
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 15),
                      ),
                      // TabBar 吸顶
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverTabBarDelegate(
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: "好友"),
                              Tab(text: "群组"),
                            ],
                            indicatorColor: AppColors.appColor,
                            labelColor: AppColors.appColor,
                            unselectedLabelColor: Colors.grey,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _friendList(),
                      _groupList(),
                    ],
                  ),
                );
              }
          )
      ),
    );
  }


  Widget _friendList(){
    return SmartRefresher(
        controller: _friendListVM.refreshController,
        enablePullDown: true,
        header: MaterialClassicHeader(
          color: AppColors.appColor,
          backgroundColor: AppColors.endColor,
        ),
        onRefresh: _friendListVM.onRefresh,
        child: ListView.builder(
            itemCount: _friendListVM.friendList.length,
            itemBuilder: (context, index){
              return _friendListItem(_friendListVM.friendList[index]);
            }
        )
    );
  }

  Widget _groupList(){
    return Container(

    );
  }


  Widget _friendListItem(V2TimFriendInfo friendInfo){
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: (){
          _friendListVM.gotoChatPage(context, friendInfo.userID);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 60,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.backgroundColor3,
                backgroundImage: friendInfo.userProfile?.faceUrl != null ? NetworkImage(friendInfo.userProfile!.faceUrl!) : null,
              ),
              SizedBox(width: 10,),
              Text(
                (friendInfo.friendRemark != null && friendInfo.friendRemark != "") ? friendInfo.friendRemark! : (friendInfo.userProfile?.nickName ?? "用户111"),
                style: TextStyle(
                    color: AppColors.textColor2b,
                    fontSize: 16.sp
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget SearchTopBar(){
    return GestureDetector(
      onTap: (){
        //RouteUtils.pushForNamed(context, RoutePath.commissionSearch);
        RouteUtils.pushForNamed(context, RoutePath.userSearchPage);
      },
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.searchBgColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 将图标对齐到右侧
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w), // 添加右侧内边距
              child: Icon(Icons.search),
            ),
            Text(
              "搜索",
              style: TextStyle(
                  color: Colors.black
              ),
            )
          ],
        ),
      ),
    );
  }
}
// 自定义 SliverPersistentHeader 的委托类
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}