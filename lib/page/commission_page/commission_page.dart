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
                    _SearchTopBar()
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
        color: AppColors.appColor,
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Text(commission.county),
          Text(CommissionViewModel.CommissionTypes[commission.commissionType].typeText),
          Text(commission.expectTime.hour.toString()),
          Text(commission.distance.toString()),
          Text(commission.price.toString())
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
          Text(CommissionViewModel.CommissionTypes[index].typeText)
        ],
      ),
    );
  }

  Widget _Position(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "石家庄",
            style: TextStyle(
              fontSize: 18,
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
        height: 30.w,
        width: 280.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.searchBgColor
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // 将图标对齐到右侧
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0), // 添加右侧内边距
              child: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}