import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:provider/provider.dart';

import '../../common_ui/banner/home_banner_widget.dart';
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
            body: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverToBoxAdapter(child: _banner()),
                SliverToBoxAdapter(child: _PageViewWidget()),
                SliverAppBar(
                    title: Row(
                  children: [
                    Text("家政服务", style: TextStyle(fontSize: 15.sp)),
                    Spacer(),
                    Text("更多", style: TextStyle(fontSize: 13.sp)),
                  ],
                )),
                _HouseKeeperRecommendedWidget(),
              ],
            )));
  }

  // 家政员推荐
  Widget _HouseKeeperRecommendedWidget() {
    return Selector<HomeViewModel, List<String?>?>(
      selector: (context, homeViewModel) => homeViewModel.bannerData,
      builder: (context, serviceData, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => _buildHousekeeperCard(),
              childCount: 10),
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
                      CType(index: 0),
                      CType(index: 1),
                      CType(index: 2),
                      CType(index: 3),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(index: 4),
                      CType(index: 5),
                      CType(index: 6),
                      CType(index: 7),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(index: 8),
                      CType(index: 9),
                      CType(index: 10),
                      CType(index: 1),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(index: 2),
                      CType(index: 3),
                      CType(index: 4),
                      CType(index: 5),
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
  Widget CType({
    required int index,
  }) {
    return GestureDetector(
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
  }

  Widget _buildHousekeeperCard() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60), color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text("王小虎",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("服务评分：4.8", style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text("服务次数：100+", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
