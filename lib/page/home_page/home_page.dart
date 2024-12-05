import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/%20autoHeightPageView/autoHeightPageView.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/send_commission_page/send_commision_page.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';

import '../../common_ui/banner/home_banner_widget.dart';
import '../../repository/model/Housekeeper _data.dart';
import '../../utils/global.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
    homeViewModel.getWeatherData();
    homeViewModel.releaseBuildTimer();
    homeViewModel.getBannerData();
    homeViewModel.getHousekeeperData();
    homeViewModel.loadingStandardPrice();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => homeViewModel,
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor2,
            body: Stack(
              children: [
                Container(
                  height: 260.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(148, 251, 195, 1),
                    //70, 219, 201
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                        AppColors.backgroundColor2, // 渐变结束颜色
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      AppBar(
                          title: Row(children: [
                            Icon(Icons.location_on, color: Colors.black),
                            SizedBox(width: 10.w),
                            ValueListenableBuilder(
                                valueListenable: Global.locationInfoNotifier,
                                builder: (context, location, child) {
                                  return Text("${location?.city}",
                                      style: TextStyle(fontSize: 15.sp));
                                })
                          ]),
                          backgroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                      ),
                      Expanded(child: SmartRefresher(
                          enablePullUp: true,
                          enablePullDown: false,
                          controller: homeViewModel.refreshController,
                          onLoading: () {
                            homeViewModel.getHousekeeperData();
                          },
                          header: MaterialClassicHeader(
                            color: AppColors.appColor,
                            backgroundColor: AppColors.endColor,
                          ),
                          footer: ClassicFooter(
                            canLoadingText: "松开加载更多~",
                            loadingText: "努力加载中~",
                            noDataText: "已经到底了~",
                          ),
                          child: CustomScrollView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            slivers: [
                              //轮播图
                              SliverToBoxAdapter(child: _banner()),
                              // SliverToBoxAdapter(child: Container(
                              //   height: 180,
                              //   child: Container(
                              //     height: 180,
                              //     child: Image(
                              //       image: AssetImage("assets/images/home1.png"),
                              //       fit: BoxFit.cover, // 可选，根据需要调整
                              //     ),
                              //   ),
                              // ),),
                              //委托服务类型
                              SliverToBoxAdapter(child: _PageViewWidget()),
                              //天气卡片
                              // SliverToBoxAdapter(child: _ServiceViewWidget()),
                             // SliverToBoxAdapter(child: SizedBox(height: 8)),
                              //固定头部
                            SliverToBoxAdapter(
                              child:Container(
                                margin: EdgeInsets.only(left: 15),
                                child:  Column(
                                  children: _buildHeaderList(),
                                ),
                              ),
                              ),
                              // _buildHeaderList()
                              //推荐
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 8),
                              ),
                              _HouseKeeperRecommendedWidget(),
                            ],
                          ))
                      )
                    ],
                  ),
                )
              ],
            )
        ));
  }

  List<Widget> _buildHeaderList() {
    return [
      Row(
        children: [
          Text("探索 家缘",
              style: TextStyle(
                fontSize: 17.sp,
                fontFamily: "PingFang SC",
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        ],
      ),
      Container(
        padding: EdgeInsets.only(right: 15, top: 8, bottom: 5),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _controller.forward();
                homeViewModel.refreshData();
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
                RouteUtils.pushForNamed(
                    context, RoutePath.houseKeepingScreeningPage);
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
    return Selector<HomeViewModel, Map<String, dynamic>>(
      selector: (context, homeViewModel) => homeViewModel.weatherData,
      builder: (context, weatherData, child) {
        return Container(
          child: Container(
            margin: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '今日关注',
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    //Response: {status: 1, count: 1, info: OK, infocode: 10000, lives: [{province: 河北, city: 裕华区, adcode: 130108, weather: 小雨, temperature: 11, winddirection: 西北, windpower: ≤3, humidity: 97, reporttime: 2024-11-13 09:02:57, temperature_float: 11.0, humidity_float: 97.0}]
                    // homeViewModel.weatherData != null  ?Text('${DateFormat("MM月dd日EEEE", "zh_CN").format(DateFormat("yyyy-MM-dd").parse(homeViewModel.weatherData['reporttime']))}'
                    //     ' ${homeViewModel.weatherData['weather']}'):Text(''),
                    homeViewModel.weatherData['weather'] != null
                        ? Text(
                            '${weatherData['city']}，${weatherData['weather']}，${weatherData['temperature']}℃',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          )
                        : Text('')
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Material(
                  elevation: 5,
                  borderOnForeground: false,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      height: 120.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/weather2.jpg'),
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

// 家政员推荐
  Widget _HouseKeeperRecommendedWidget() {
    return Consumer<HomeViewModel>(
      // 将 Selector 改为 Consumer
      builder: (context, viewModel, child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildHousekeeperCard(viewModel.housekeepers[index]),
              childCount: viewModel.housekeepers.length),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        borderOnForeground: true,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () async {
            //设置插入策略
            housekeeper.createdTime = DateTime.now();
            housekeeper.userId = Global.userInfo?.userId;
            await Global.dbUtil?.db.insert(
                'browser_history', housekeeper.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
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
                          style: TextStyle(color: Colors.black45, fontSize: 12),
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

  //轮播图
  Widget _banner() {
    return Selector<HomeViewModel, List<String?>?>(
      selector: (context, homeViewModel) => homeViewModel.bannerData,
      builder: (context, bannerData, child) {
        return BannerWidget(
          dotType: BannerDotType.circle,
          bannerData: bannerData,
          height: 160,
          margin: EdgeInsets.only(top: 2, left: 10, right: 10.w),
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
              margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
              width: _currentPage == index ? 8.0.w : 4.0.w,
              height: 5.0.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? AppColors.appColor : Colors.grey,
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
              padding: EdgeInsets.only(left: 20.w, right: 15.w, top: 10),
              child: Text(
                "服务类型",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: "PingFang SC",
                //  fontFamily: "ChanyuZhenyan",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        Container(
          margin:
              EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
          padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 2),
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
          child: Column(
            children: [
              Container(
                child:  AutoHeightPageView(
                  pageController: _pageController,
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
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CType(9),
                            CType(10),
                            Container(
                              width: 50.w,
                              height: 50.h,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 3,),
              _buildIndicator(),
            ],
          ),
        ),

        SizedBox(
          height: 5,
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
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: Color.fromRGBO(60, 205, 200, 1)),
              child: Icon(
                HomeViewModel.CommissionTypes[index].icon,
                size: 30.h,
                color: Colors.white,
              ),
            ),
            Text(HomeViewModel.CommissionTypes[index].typeText)
          ],
        ),
      );
}
