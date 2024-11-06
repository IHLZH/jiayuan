import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/common_ui/dialog/loading.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/page/Test.dart';
import 'package:jiayuan/page/commission_page/commission_page.dart';
import 'package:jiayuan/page/home_page/home_page.dart';
import 'package:jiayuan/page/user_page/user_page.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/location_data.dart';
import '../loading_page/LoadingPage.dart';


/*
底部导航栏页面
 */
class TabPage extends StatefulWidget{

  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage>{

  final List<Widget> tabItems = [
    LoadingPage(),
    LoadingPage(),
    LoadingPage(),
    LoadingPage(),
  ];
  final List<String> tabLabels = ["发委托","接委托","消息","我的"];
  final List<String> tabIcons = [
    "assets/images/icons/commission_publish.png",
    "assets/images/icons/commission_pickup.png",
    "assets/images/icons/chat.png",
    "assets/images/icons/mine.png"
  ];
  final List<String> tabActiveIcons = [
    "assets/images/icons/commission_publish_active.png",
    "assets/images/icons/commission_pickup_active.png",
    "assets/images/icons/chat_active.png",
    "assets/images/icons/mine_active.png"
  ];

  //高德地图sdk
  // 实例化
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  // 监听定位
  late StreamSubscription<Map<String, Object>> _locationListener;

  @override
  void initState() {
    super.initState();

    //获取定位权限
    getPermission();

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      print(result);

      setState(() {
        Global.location = LocationData(
            latitude: result["latitude"].toString(),
            longitude: result["longitude"].toString(),
            country: result['country'].toString(),
            province: result['province'].toString(),
            city: result['city'].toString(),
            district: result['district'].toString(),
            street: result['street'].toString(),
            adCode: result['adCode'].toString(),
            address: result['address'].toString(),
            cityCode: result['cityCode'].toString()
        );

        print("定位信息为：" + Global.location.toString());
        initTabItems();
      });
    });

    //开始定位
    _startLocation();
  }

  void getPermission(){
    /// 动态申请定位权限
    requestPermission();

    /// 设置Android和iOS的apikey，
    AMapFlutterLocation.setApiKey("deec9d608ddc51b91c745ba02af59a96", "");

    ///设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作,这里传true
    AMapFlutterLocation.updatePrivacyShow(true, true);

    ///iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    //iOS 14中系统的定位类型信息
    AMapAccuracyAuthorization currentAccuracyAuthorization =
    await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }

  ///设置定位参数
  void _setLocationOption() {
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = AMapLocationOption();

      ///是否单次定位
      locationOption.onceLocation = false;

      ///是否需要返回逆地理信息
      locationOption.needAddress = true;

      ///逆地理信息的语言类型
      locationOption.geoLanguage = GeoLanguage.DEFAULT;

      locationOption.desiredLocationAccuracyAuthorizationMode =
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

      locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

      ///设置Android端连续定位的定位间隔
      locationOption.locationInterval = 2000;

      ///设置Android端的定位模式<br>
      ///可选值：<br>
      ///<li>[AMapLocationMode.Battery_Saving]</li>
      ///<li>[AMapLocationMode.Device_Sensors]</li>
      ///<li>[AMapLocationMode.Hight_Accuracy]</li>
      locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

      ///设置iOS端的定位最小更新距离<br>
      locationOption.distanceFilter = -1;

      ///设置iOS端期望的定位精度
      /// 可选值：<br>
      /// <li>[DesiredAccuracy.Best] 最高精度</li>
      /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
      /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
      /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
      /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
      locationOption.desiredAccuracy = DesiredAccuracy.Best;

      ///设置iOS端是否允许系统暂停定位
      locationOption.pausesLocationUpdatesAutomatically = false;

      ///将定位参数设置给定位插件
      _locationPlugin.setLocationOption(locationOption);
    }
  }

  ///开始定位
  void _startLocation() {
    if (null != _locationPlugin) {
      ///开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
    }
  }

  ///停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  void initTabItems(){
    tabItems[0] = HomePage();
    tabItems[1] = CommissionPage();
    tabItems[2] = ChatPage();
    tabItems[3] = UserPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: NavigationBarWidget(
          tabItems: tabItems,
          tabLabels: tabLabels,
          tabIcons: tabIcons,
          tabActiveIcons: tabActiveIcons,
        bottomBarIconHeight: 25.h,
      ),
    );
  }
}