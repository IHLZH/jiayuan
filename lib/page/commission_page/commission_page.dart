import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/page/Test.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:provider/provider.dart';
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
    _viewModel.getCommissionData();
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
                    _Position(),
                    Expanded(child: _SearchTopBar()),
                    SizedBox(width: 10.w)
                  ],
                ),
                Expanded(
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
                          flexibleSpace: FlexibleSpaceBar(
                            title: Row(
                              children: [
                                Center(
                                  child: Text(
                                    "为您推荐:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            titlePadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),

                        Consumer<CommissionViewModel>(
                            builder: (context, vm, child){
                              return SliverGrid.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.9,
                                  ),
                                  itemCount: vm.commissions.length,
                                  itemBuilder: (context, index){
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      child: CommissionCard(vm.commissions[index]),
                                    );
                                  }
                              );
                            }
                        ),
                      ],
                    ),
                )
              ],
            )
        )
    );
  }



  Widget CommissionCard(Commission commission){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 阴影颜色
            offset: Offset(0, 4), // 阴影偏移量
            blurRadius: 8, // 模糊半径
            spreadRadius: 1,
          )// 扩展半径)
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  Text(
                    commission.distance.toString() + "km",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            Text(
                commission.expectTime.hour.toString() + ":" + commission.expectTime.minute.toString(),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],),

          //SizedBox(height: 10.h,),

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.circular(16.r)
                ),
                child: Text(
                  CommissionViewModel.CommissionTypes[commission.commissionType].typeText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
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
                commission.isLong ? "服务周期: " : "服务时长: " + commission.estimatedTime.toString() + (commission.isLong ? "月" : "小时"),
                style: TextStyle(
                  color: AppColors.textColor2b,
                    fontSize: 18.sp,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(width: 5.w,),
              Expanded(
                  child: Text(
                    commission.address + "诚朴园三号楼204",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 14.sp,
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
                commission.price.toString(),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
              Text(
                "元",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget CType({
    required int index,
}){
    return GestureDetector(
      onTap: (){

      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.appColor
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

  Widget _Position(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "石家庄",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600
            ),
          ),
          Icon(
              Icons.keyboard_arrow_down,
            weight: 3,
          )
        ],
      ),
    );
  }

  Widget _SearchTopBar(){
    return GestureDetector(
      onTap: (){
        print("AppBar");
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