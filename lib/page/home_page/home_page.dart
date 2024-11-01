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
            title:
            Row(children: [
              Icon(Icons.location_on, color: Colors.black),
              SizedBox(width: 10),
              Text("石家庄市", style: TextStyle(fontSize: 15.sp))
            ]),
            backgroundColor: AppColors.appColor,
          ),
          body: Column(
            children: [
              //轮播图
              _banner(),
              //滑动的服务业
              _PageViewWidget(),
            ],
          )),
    );
  }

  Widget _banner() {
    return Selector<HomeViewModel, List<String?>?>(
      selector: (context, homeViewModel) => homeViewModel.bannerData,
      builder: (context, bannerData, child) {
        return BannerWidget(
          dotType: BannerDotType.circle,
          bannerData: bannerData,
          height: 181,
          margin: EdgeInsets.only(top: 2, left: 12, right: 12),
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
        children: List.generate(3, (index) {
          return Container(
            margin: EdgeInsets.all(4.0),
            width: _currentPage == index ? 12.0.w : 8.0.w,
            height: 8.0,
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
          height: 200,
          width: double.infinity,
          margin: EdgeInsets.all(16.0),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Container(
                  color: Colors.red,
                  height: 200,
                  width: 200,
                  child: Center(
                      child: Text('第一页',
                          style:
                              TextStyle(fontSize: 30, color: Colors.white)))),
              Container(
                  color: Colors.green,
                  height: 200,
                  width: 200,
                  child: Center(
                      child: Text('第二页',
                          style:
                              TextStyle(fontSize: 30, color: Colors.white)))),
              Container(
                  color: Colors.blue,
                  height: 200,
                  width: 200,
                  child: Center(
                      child: Text('第三页',
                          style:
                              TextStyle(fontSize: 30, color: Colors.white)))),
            ],
          ),
        ),
        _buildIndicator(),
      ],
    );
  }
}
