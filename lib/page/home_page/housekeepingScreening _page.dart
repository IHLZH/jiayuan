import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:jiayuan/page/home_page/housekeepingScreening_vm.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';

import '../../repository/model/Housekeeper _data.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/global.dart';

class HouseKeepingScreeningPage extends StatefulWidget {
  const HouseKeepingScreeningPage({super.key});

  @override
  State<HouseKeepingScreeningPage> createState() =>
      _HouseKeepingScreeningPageState();
}

class _HouseKeepingScreeningPageState extends State<HouseKeepingScreeningPage> {
  PageController _pageController = PageController(initialPage: 0);
  HouseKeepingScreeningVM _houseKeepingScreeningVM = HouseKeepingScreeningVM();
  List<RefreshController> _refreshControllers = List.generate(HomeViewModel.CommissionTypes.length, (index)=> RefreshController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _houseKeepingScreeningVM.loadHouseKeepers(0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget _houseKeepingType(int index) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        color: _houseKeepingScreeningVM.currentIndex == index
            ? AppColors.endColor
            : Theme
            .of(context)
            .colorScheme
            .background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (!mounted) return;
            _pageController.jumpToPage(index);
            _houseKeepingScreeningVM.updateCurrentIndex(index);
            setState(() {

            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(HomeViewModel.CommissionTypes[index].icon),
                Text(
                  HomeViewModel.CommissionTypes[index].typeText,
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HouseKeepingScreeningVM>(
      create: (context) => _houseKeepingScreeningVM,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.appColor,
            title: Text(
              '服务分类',
              style: TextStyle(fontSize: 20),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.home_outlined,
                size: 40,
              ),
            ),
          ),
          body: Row(
            children: [
              Column(
                  children: List.generate(HomeViewModel.CommissionTypes.length,
                          (index) {
                        return _houseKeepingType(index);
                      })),
              Expanded(
                  child: Consumer<HouseKeepingScreeningVM>(
                      builder: (context, vm, child) {
                        return PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: HomeViewModel.CommissionTypes.length,
                            onPageChanged: (index) async {
                              await _houseKeepingScreeningVM.loadHouseKeepers(index);
                            },
                            itemBuilder: (context, index) {
                              List housekeepers = _houseKeepingScreeningVM
                                  .housekeepersByType[index] ?? [];
                              if (housekeepers.isEmpty) {
                                //返回一个圆形的进度条指示器
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Container(
                                color: Colors.white,
                                child: SmartRefresher(
                                  controller: _refreshControllers[index],
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  header: MaterialClassicHeader(),
                                  footer:ClassicFooter(),
                                  onRefresh: () async {
                                    await _houseKeepingScreeningVM.refreshHouseKeepers(index);
                                    _refreshControllers[index].refreshCompleted();
                                  },
                                  onLoading: () async {
                                    await _houseKeepingScreeningVM.loadMoreHouseKeepers(index);
                                    _refreshControllers[index].loadComplete();
                                  },
                                  child: ListView.builder(
                                      itemCount: housekeepers.length,
                                      itemBuilder: (context, _) =>
                                          _buildHousekeeperCard(housekeepers[_])),
                                ),
                              );
                            });
                      }))
            ],
          )),
    );
  }

  //家政员推荐卡片
  Widget _buildHousekeeperCard(Housekeeper housekeeper) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3,
        borderOnForeground: true,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () async{
            housekeeper.createdTime = DateTime.now();
            housekeeper.userId = Global.userInfo?.userId;
            await Global.dbUtil?.db.insert('browser_history', housekeeper.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
            RouteUtils.pushForNamed(context, RoutePath.KeeperPage,
                arguments: housekeeper.keeperId);
          },
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      height: 70,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(housekeeper.avatar!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(housekeeper.realName!,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            SizedBox(
                              height: 3,
                            ),
                            Text("工作经验：${housekeeper.workExperience}年",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                            Text(
                              "服务评分：${housekeeper.rating}分",
                              style:
                              TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ],
                        ))
                  ]),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(233, 247, 237, 1), // 起始颜色
                          Color.fromRGBO(233, 247, 237, 0.3), // 结束颜色，透明度较低
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "亮点: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(87, 191, 169, 1),
                              fontSize: 12),
                        ),
                        Expanded(
                            child: Text(
                              " ${housekeeper.highlight}",
                              style: TextStyle(color: Colors.black45,
                                  fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
