import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/Test.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/page/commission_page/type/commission_type_page.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/common_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//委托页面
import 'commission_vm.dart';

/*
委托接取页面
 */
class CommissionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionPageState();
  }
}

class _CommissionPageState extends State<CommissionPage>{
  final PageController _pageController = PageController();
  int _currentPage = 0;

  //指示器
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: EdgeInsets.all(4.0),
          width: _currentPage == index ? 8.0.w : 4.0.w,
          height: 4.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.black : Colors.grey,
          ),
        );
      }),
    );
  }

  final CommissionViewModel _viewModel = CommissionViewModel();


  @override
  void initState() {
    super.initState();
    //请求委托数据
    _initData();
  }

  Future<void> _initData() async {
    await _viewModel.initData();
  }

  Future<void> _onLoading() async {
    await _viewModel.onLoading();
  }

  Future<void> _onRefresh() async {
    await _viewModel.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _viewModel;
        },
        child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                //color: AppColors.backgroundColor2
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Position(),
                      Expanded(child: SearchTopBar()),
                      SizedBox(width: 10.w)
                    ],
                  ),
                  Expanded(
                    child: SmartRefresher(
                      controller: _viewModel.refreshController,
                      enablePullUp: true,
                      enablePullDown: true,
                      header: MaterialClassicHeader(
                        color: AppColors.appColor,
                        backgroundColor: AppColors.endColor,
                      ),
                      footer: ClassicFooter(
                        canLoadingText: "松开加载更多~",
                        loadingText: "努力加载中~",
                        noDataText: "已经到底了~",
                      ),
                      onLoading: _onLoading,
                      onRefresh: _onRefresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                      height: 180,
                                      padding: EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 10),
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
                                                  CType(index: 1),
                                                  CType(index: 2),
                                                  CType(index: 3),
                                                  CType(index: 4),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  CType(index: 5),
                                                  CType(index: 6),
                                                  CType(index: 7),
                                                  CType(index: 8),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  CType(index: 9),
                                                  CType(index: 10),
                                                  CType(index: 11),
                                                  CType(index: 2),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  CType(index: 3),
                                                  CType(index: 4),
                                                  CType(index: 5),
                                                  CType(index: 6),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  ),
                                  _buildIndicator(),
                                ],
                              )
                          ),

                          SliverAppBar(
                              automaticallyImplyLeading: false,
                              floating: false,
                              pinned: true,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              title: Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "为您推荐:",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              flexibleSpace: Container(
                                color: Colors.white,
                              )
                          ),

                          Consumer<CommissionViewModel>(
                              builder: (context, vm, child){
                                return vm.isLoading ? SliverToBoxAdapter(
                                  child: Center(
                                    heightFactor: 10.h,
                                    child: CircularProgressIndicator(
                                      backgroundColor: AppColors.appColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.endColor),
                                    ),
                                  ),
                                ) : vm.commissionDataList.isEmpty ? SliverToBoxAdapter(
                                  child: Center(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              height: 200.h,
                                              width: 200.w,
                                              "assets/images/search_no_result.png",
                                            ),
                                            Text(
                                              "您周围没有合适的委托/(ㄒoㄒ)/~~",
                                              style: TextStyle(
                                                  color: AppColors.appColor,
                                                  fontSize: 16.sp
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                ) : SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context, index){
                                          return CommissionCard(vm.commissionDataList[index]);
                                        },
                                        childCount: vm.commissionDataList.length
                                    )
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
    );
  }


  Widget CommissionCard(CommissionData1 commission){
    return Container(
      padding: EdgeInsets.all(10),
      child: Material(
        elevation: 5,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: (){
            RouteUtils.pushForNamed(
                context,
                RoutePath.commissionDetail,
                arguments: commission
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 125.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (commission.days ?? "今天") +
                          (commission.expectStartTime.hour.toString().length > 1 ? commission.expectStartTime.hour.toString() : ("0" + commission.expectStartTime.hour.toString())) +
                          ":" + (commission.expectStartTime.minute.toString().length > 1 ? commission.expectStartTime.minute.toString() : ("0" + commission.expectStartTime.minute.toString())),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          commission.commissionBudget.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "元",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.appColor, // 渐变起始颜色
                              AppColors.endColor,      // 渐变结束颜色
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r)
                      ),
                      child: Text(
                        commission.typeName,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                        child: Text(
                          "内容：" + (commission.commissionDescription ?? "家政员招募中~"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      commission.distance < 1
                          ? "${(commission.distance * 1000).round()}m"
                          : "${commission.distance.toStringAsFixed(1)}km",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Text(
                      commission.county ?? "",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                      child: Text(
                        commission.commissionAddress ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CType({
    required int index,
  }){
    return GestureDetector(
      onTap: (){
        RouteUtils.push(context, CommissionTypePage(id: index,));
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  AppColors.appColor, // 渐变起始颜色
                  AppColors.endColor,      // 渐变结束颜色
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
            child: Icon(
              CommonData.CommissionTypes[index].icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          Text(
            CommonData.CommissionTypes[index].typeText,
            style: TextStyle(color: AppColors.textColor2b),
          )
        ],
      ),
    );
  }

  Widget Position(){
    return GestureDetector(
      onTap: (){
        //RouteUtils.push(context, MapPage());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              weight: 3,
              color: AppColors.appColor,
            ),
            Text(
              Global.location?.city ?? "定位中..",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchTopBar(){
    return GestureDetector(
      onTap: (){
        RouteUtils.pushForNamed(context, RoutePath.commissionSearch);
      },
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.searchBgColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // 将图标对齐到右侧
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.w), // 添加右侧内边距
              child: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}