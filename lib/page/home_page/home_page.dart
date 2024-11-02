import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:provider/provider.dart';

import '../../common_ui/banner/home_banner_widget.dart';
import '../../repository/model/Housekeeper _data.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel homeViewModel = HomeViewModel();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    homeViewModel.getBannerData();
    homeViewModel.getHousekeeperData();
    print("你刚好撒旦阿斯顿打撒");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => homeViewModel,
        child: Scaffold(
            appBar: AppBar(
              title: Row(children: [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 10.w),
                Text("石家庄市", style: TextStyle(fontSize: 15.sp))
              ]),
              backgroundColor: AppColors.appColor,
            ),
            backgroundColor: Colors.grey[200],
            body: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverToBoxAdapter(child: _banner()),
                SliverToBoxAdapter(child: _PageViewWidget()),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.grey[200],
                  title: Container(
                    child: Row(
                      children: [
                        Text(
                          "推荐:",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  flexibleSpace: Container(
                    color: Colors.white,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 5)),
                _HouseKeeperRecommendedWidget(),
              ],
            )));
  }

  // 家政员推荐
  Widget _HouseKeeperRecommendedWidget() {
    return Selector<HomeViewModel, List<Housekeeper>?>(
      selector: (context, homeViewModel) => homeViewModel.housekeepers,
      builder: (context, serviceData, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildHousekeeperCard(homeViewModel.housekeepers[index]),
              childCount: homeViewModel.housekeepers.length),
        );
      },
    );
  }

  //轮播图
  Widget _banner() {
    return Selector<HomeViewModel, List<String?>?>(
      selector: (context, homeViewModel) => homeViewModel.bannerData,
      builder: (context, bannerData, child) {
        return BannerWidget(
          dotType: BannerDotType.circle,
          bannerData: bannerData,
          height: 181.h,
          margin: EdgeInsets.only(top: 2.h, left: 12.w, right: 12.w),
        );
      },
    );
  }

  //服务滑动页
  Widget _PageViewWidget() {
    //指示器
    Widget _buildIndicator() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return Container(
            margin: EdgeInsets.all(4.0.w),
            width: _currentPage == index ? 8.0.w : 4.0.w,
            height: 4.0.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.black : Colors.grey,
            ),
          );
        }),
      );
    }

    return Column(
      children: [
        Container(
          height: 180.h,
          width: double.infinity,
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(0),
                      CType(1),
                      CType(2),
                      CType(3),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(4),
                      CType(5),
                      CType(6),
                      CType(7),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(8),
                      CType(9),
                      CType(10),
                      CType(1),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(2),
                      CType(3),
                      CType(4),
                      CType(5),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        _buildIndicator(),
      ],
    );
  }

  //委托类型
  Widget CType(int index) => GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.appColor),
              child: Icon(
                HomeViewModel.CommissionTypes[index].icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text(HomeViewModel.CommissionTypes[index].typeText)
          ],
        ),
      );

//家政员推荐卡片
  Widget _buildHousekeeperCard(Housekeeper housekeeper) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(10),
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
                    Expanded(
                        child: Container(
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
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ],
                            )))
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
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "亮点:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(87, 191, 169, 1),
                              fontSize: 12),
                        ),
                        Text(
                          " ${housekeeper.highlight}",
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        )
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
