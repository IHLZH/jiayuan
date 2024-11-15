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

  //刷新控制器
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    //请求委托数据
    _initData();
  }

  Future<void> _initData() async {
    await _viewModel.getRecommendComission({
      "longitude":Global.location?.longitude ?? 0.0,
      "latitude":Global.location?.latitude ?? 0.0,
      "distance":10,
      "page": _viewModel.startPage,
      "size": _viewModel.size
    });
    setState(() {
    });
  }

  Future<void> _onLoading() async {
    if(_viewModel.hasMoreData){
      _viewModel.endPage++;
      await _viewModel.loadingComission({
        "longitude":Global.location?.longitude ?? 0.0,
        "latitude":Global.location?.latitude ?? 0.0,
        "distance":10,
        "page": _viewModel.endPage,
        "size": _viewModel.size
      });
      if(_viewModel.commissionDataList.length >= 110){
        _viewModel.hasMoreData = false;
        _refreshController.loadNoData();
        setState(() {
        });
      }else{
        setState(() {
        });
        _refreshController.loadComplete();
      }
    }else{
      _refreshController.loadNoData();
    }
  }

  Future<void> _onRefresh() async {
    _viewModel.startPage++;
    await _viewModel.refreshComission({
      "longitude":Global.location?.longitude ?? 0.0,
      "latitude":Global.location?.latitude ?? 0.0,
      "distance":10,
      "page": _viewModel.startPage,
      "size": _viewModel.size
    });
    setState(() {
      _viewModel.hasMoreData = true;
      _refreshController.resetNoData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _viewModel;
        },
        child: SafeArea(
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
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: true,
                    header: ClassicHeader(),
                    footer: ClassicFooter(),
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
                              return SliverToBoxAdapter(
                                child: MasonryGridView.count(
                                  crossAxisCount: 2,
                                  itemCount: vm.commissionDataList.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      height: (index % 2 == 0) ? 250.h : 300.h,
                                      padding: EdgeInsets.all(10),
                                      child: CommissionCard(vm.commissionDataList[index]),
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(), // 禁止内部滚动
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
    );
  }


  Widget CommissionCard(CommissionData1 commission){
    return Material(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (commission.days ?? "今天"),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                      ),
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
                    ],
                  ),

                ],),

              //SizedBox(height: 10.h,),

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
                      CommissionViewModel.CommissionTypes[commission.typeId].typeText,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              ),

              //SizedBox(height: 10.h,),

              Row(
                children: [
                  Text(
                    commission.isLong ? "服务周期: " : "服务时长: ",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Text(
                    commission.specifyServiceDuration.toString() + (commission.isLong ? "月" : "小时"),
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),

              //SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    commission.county,
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Expanded(
                    child: Text(
                      commission.commissionAddress,
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

              //SizedBox(height: 5.h),

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
              CommissionViewModel.CommissionTypes[index].icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          Text(
            CommissionViewModel.CommissionTypes[index].typeText,
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