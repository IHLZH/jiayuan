import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/page/Test.dart';
import 'package:jiayuan/page/commission_page/commission_page.dart';
import 'package:jiayuan/page/home_page/home_page.dart';


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

  final List<Widget> tabItems = [];
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

  @override
  void initState() {
    super.initState();
    initTabItems();
  }

  void initTabItems(){
    tabItems.add(HomePage());
    tabItems.add(CommissionPage());
    tabItems.add(ChatPage());
    tabItems.add(MinePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: NavigationBarWidget(
          tabItems: tabItems,
          tabLabels: tabLabels,
          tabIcons: tabIcons,
          tabActiveIcons: tabActiveIcons
      ),
    );
  }
}