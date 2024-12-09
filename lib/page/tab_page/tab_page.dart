import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/floating_support_ball/floating_support_ball.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/page/chat_page/conversation_page.dart';
import 'package:jiayuan/page/commission_page/commission_page.dart';
import 'package:jiayuan/page/home_page/home_page.dart';
import 'package:jiayuan/page/user_page/user_page.dart';
import 'package:jiayuan/utils/gaode_map/gaode_map.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/location_data.dart';
import '../loading_page/loading_page.dart';



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

  final List<Widget> _tabItems = [
    LoadingPage(),
    LoadingPage(),
    LoadingPage(),
    LoadingPage(),
  ];
  final List<String> _tabLabels = ["发委托","接委托","消息","我的"];
  final List<String> _tabIcons = [
    "assets/images/icons/commission_publish.png",
    "assets/images/icons/commission_pickup.png",
    "assets/images/icons/chat.png",
    "assets/images/icons/mine.png"
  ];
  final List<String> _tabActiveIcons = [
    "assets/images/icons/commission_publish_active.png",
    "assets/images/icons/commission_pickup_active.png",
    "assets/images/icons/chat_active.png",
    "assets/images/icons/mine_active.png"
  ];

  @override
  void initState() {
    super.initState();
    Global.dbUtil?.open();

    //初始化地图以及tabitem
    _initWithTimeout();
  }

  @override
  void dispose() {
    super.dispose();
    print("=================== tabpage销毁  ====================");
    _disposeGaodeAndDB();
  }

  Future<void> _disposeGaodeAndDB() async {
    //销毁高德及监听器
    await GaodeMap.instance.disposeGaodeMap();
    //关闭数据库
    print("数据库关闭");
    await Global.dbUtil?.close();
    print("已被销毁dispose");
  }

  Future<void> _initWithTimeout() async {
    try {
      // 创建一个5秒超时的Future
      await Future.any([
        _initGaodeMapAndTab(),
        Future.delayed(Duration(seconds: 3)).then((_) {
          throw TimeoutException('高德地图初始化超时');
        }),
      ]);
    } catch (e) {
      print("初始化错误: $e");
      if (e is TimeoutException) {
        showToast("定位服务初始化失败，部分功能可能受限");
      }
      // 无论是否超时，都初始化业务页面
      _initTabItems();
      if (mounted) {
        setState(() {
          GaodeMap.isMapInitialized = true;
        });
      }
    }
  }

  Future<void> _initGaodeMapAndTab() async {
    await GaodeMap.instance.initGaodeMap();
    _initTabItems();
    setState(() {
    });
  }

  void _initTabItems(){
    _tabItems[0] = HomePage();
    _tabItems[1] = CommissionPage();
    _tabItems[2] = ConversationPage();
    _tabItems[3] = UserPage();
  }

  DateTime? _lastPressedAt; // 用于记录上次点击返回键的时间

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
      // 如果距离上次点击返回键超过2秒，更新时间并提示用户
      _lastPressedAt = now;
      showToast("再按一次退出应用");
      return Future.value(false); // 不退出应用，拦截返回键
    }
    // 如果在2秒内再次点击返回键，则退出应用
    SystemNavigator.pop(); // 退出应用
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // 禁止布局被键盘顶掉
          appBar: null,
          body: Stack(
            children: [
              NavigationBarWidget(
                tabItems: _tabItems,
                tabLabels: _tabLabels,
                tabIcons: _tabIcons,
                tabActiveIcons: _tabActiveIcons,
                bottomBarIconHeight: 25.h,
              ),
              FloatingSupportBall(),
            ],
          ),
        ),
        onWillPop: _onWillPop
    );
  }
}
