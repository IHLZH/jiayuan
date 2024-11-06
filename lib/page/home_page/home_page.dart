import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/sliver/sliver_header.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/send_commission_page/send_commision_page.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:jiayuan/utils/location_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../common_ui/banner/home_banner_widget.dart';
import '../../repository/model/Housekeeper _data.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  final HomeViewModel homeViewModel = HomeViewModel();

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // 动画持续时间
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    homeViewModel.getBannerData();
    homeViewModel.getHousekeeperData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            backgroundColor: Colors.white,
            body: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                //委托服务类型
                SliverToBoxAdapter(child: _PageViewWidget()),
                //轮播图
                SliverToBoxAdapter(child: _banner()),
                //固定头部
                SliverHeader(children: _buildHeaderList()),
                //推荐
                SliverToBoxAdapter(child: SizedBox(height: 8),),
                _HouseKeeperRecommendedWidget(),
              ],
            )));
  }
  List <Widget> _buildHeaderList() {
    return [
      SizedBox(height: 10),
      Row(
        children: [
          SizedBox(width: 20),
          Text("探索",
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.black87,
              )),
        ],
      ),
      Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 5),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _controller.forward();
              },
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value * 2 * 3.14159, // 旋转角度
                        child: child,
                      );
                    },
                    child: Icon(Icons.refresh, color: Colors.black38, size: 20),
                  ),
                  Text("换一批",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black38,
                      )),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {

              },
              child: Text("更多",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black38,
                  )),
            )
          ],
        ),
      ),
    ];
  }

// 服务图片

  Widget _ServiceViewWidget() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              "https://tse3-mm.cn.bing.net/th/id/OIP-C.bbgILfd3FNOY4F6CG6cs4gHaE8?w=303&h=202&c=7&r=0&o=5&dpr=1.3&pid=1.7"),
          fit: BoxFit.cover, // 可选，根据需要调整图片填充方式
        ),
      ),
    );
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
          onTap: () {},
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
      return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              width: _currentPage == index ? 8.0.w : 4.0.w,
              height: 4.0.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.black : Colors.grey,
              ),
            );
          }),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 15, top: 10),
              child: Text(
                "服务类型",
                style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        Container(
          height: 180.h,
          width: double.infinity,
          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
          margin: EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2),width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
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

                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(3),
                      CType(4),
                      CType(5),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(6),
                      CType(7),
                      CType(8),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CType(9),
                      CType(10),
                      Container(
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        _buildIndicator(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  //委托类型
  Widget CType(int index) => GestureDetector(
        onTap: () {
          // HomeViewModel.CommissionTypes[index].typeText
          //将委托名字作为参数传递给另一个页面
         RouteUtils.push(context, SendCommissionPage(id: index));
        },
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
