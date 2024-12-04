import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/config.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/repository/api/keeper_api.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../repository/api/commission_api.dart';
import '../../utils/global.dart';
import '../commission_page/commission_vm.dart';

class HomeViewModel with ChangeNotifier {
  Timer? _timer;
  Timer? _timer1;

  // 轮播图数据
  List<String?> bannerData = [];

  Map<String, dynamic> weatherData = {};

  //家政员表
  List<Housekeeper> housekeepers = [];

  //刷新控制器
  RefreshController refreshController = RefreshController();

  //是否有更多数据
  bool hasMoreData = true;

  //委托类型表
  static List<CommissionType> CommissionTypes = [
    CommissionType(icon: Icons.house, typeText: "日常保洁"),
    CommissionType(icon: Icons.auto_fix_high, typeText: "家电维修"),
    CommissionType(icon: Icons.car_crash, typeText: "搬家搬厂"),
    CommissionType(icon: Icons.fastfood, typeText: "收纳整理"),
    CommissionType(icon: Icons.handyman, typeText: "管道疏通"),
    CommissionType(icon: Icons.precision_manufacturing, typeText: "维修拆装"),
    CommissionType(icon: Icons.baby_changing_station, typeText: "保姆月嫂"),
    CommissionType(icon: Icons.elderly, typeText: "居家养老"),
    CommissionType(icon: Icons.bedroom_baby, typeText: "居家托育"),
    CommissionType(icon: Icons.child_care, typeText: "专业养护"),
    CommissionType(icon: Icons.family_restroom, typeText: "家庭保健"),
  ];

  void loadingStandardPrice() async {
    Global.standPrices = await CommissionApi.instance.getAllPrice();
  }
  // try {
  //   final Response response =
  //       await DioInstance.instance().get(path: '/release/carousel');
  //   if (response.data['code'] != 200) {
  //     print('获取轮播图数据失败${response.data['message']}');
  //   } else
  //     bannerData = response.data['data'].cast<String?>();
  //   print('获取轮播图数据response: ${response.data}');
  // } catch (e) {
  //   print(e.toString());
  // }
  //获取首页banner数据
  Future<void> getBannerData() async {

    bannerData= [
      "assets/images/home2.png",
      "assets/images/home1.png",
      "assets/images/home3.png"
    ];
    //实际上是从网络获取首页轮播图的 url 数据
    notifyListeners();
  }

  Future<void> getHousekeeperData() async {
    //获取家政员数据
    if (hasMoreData) {
      List<Housekeeper> temp;
      temp = await KeeperApi.instance.getHousekeeperData(
          Global.locationInfo!.longitude!, Global.locationInfo!.latitude!);
      if (temp.length < 10) {
        hasMoreData = false;
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      housekeepers.addAll(temp);
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    if (hasMoreData) {
      List<Housekeeper> temp;
      temp = await KeeperApi.instance.getHousekeeperData(
          Global.locationInfo!.longitude!, Global.locationInfo!.latitude!);
      if (temp.length < 1) {
        showToast('附近没有更多的家政员了');
      } else if (temp.length < 10) {
        hasMoreData = false;
        refreshController.loadNoData();
        housekeepers.clear();
        print('清空后的长度${housekeepers.length}');
        housekeepers.addAll(temp);
        notifyListeners();
      } else {
        housekeepers.clear();
        housekeepers.addAll(temp);
        notifyListeners();
      }
    }else{
      showToast('附近没有更多的家政员了');
    }
  }

  Future<void> getWeatherData() async {
    weatherTask();
    _timer = Timer.periodic(Duration(minutes: 10), (timer) async {
      weatherTask();
    });
  }

  //建立定时任务
  Future<void> releaseBuildTimer() async {
    _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
      await KeeperApi.instance.releaseHeart();
    });
  }

  void weatherTask() async {
    //获取天气数据
    print('市区状态码 ${Global.locationInfo?.adCode}');
    try {
      final response = await Dio().get(
        UrlPath.weatherUrl,
        queryParameters: {
          'key': ConstConfig.webKey,
          'city': Global.locationInfo?.adCode,
          'extensions': 'base'
        },
      );
      weatherData = response.data['lives'][0];
      print('Response: ${response.data}');
    } catch (e) {
      if (e is DioError) {
        // 处理DioError
        if (e.response != null) {
          print(
              'Error Response: ${e.response!.statusCode} - ${e.response!.data}');
        } else {
          print('Error Message: ${e.message}');
        }
      } else {
        // 处理其他类型的错误
        print('Unexpected Error: $e');
      }
    }
    notifyListeners();
  }

  void dispose() {
    _timer?.cancel();
    _timer1?.cancel();
    refreshController.dispose();
    super.dispose();
  }
}
