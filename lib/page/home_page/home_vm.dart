import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commission_page/commission_vm.dart';

class HomeViewModel with ChangeNotifier{
   // 轮播图数据
  List<String?>? bannerData = [];

  //委托类型表
  static List<CommissionType> CommissionTypes = [
    CommissionType(
        icon: Icons.house,
        typeText: "日常保洁"
    ),
    CommissionType(
        icon: Icons.auto_fix_high,
        typeText: "家电维修"
    ),
    CommissionType(
        icon: Icons.car_crash,
        typeText: "搬家搬厂"
    ),
    CommissionType(
        icon: Icons.fastfood,
        typeText: "收纳整理"
    ),
    CommissionType(
        icon: Icons.handyman,
        typeText: "管道疏通"
    ),
    CommissionType(
        icon: Icons.precision_manufacturing,
        typeText: "维修拆装"
    ),
    CommissionType(
        icon: Icons.baby_changing_station,
        typeText: "保姆月嫂"
    ),
    CommissionType(
        icon: Icons.elderly,
        typeText: "居家养老"
    ),
    CommissionType(
        icon: Icons.bedroom_baby,
        typeText: "居家托育"
    ),
    CommissionType(
        icon: Icons.child_care,
        typeText: "专业养护"
    ),
    CommissionType(
        icon: Icons.family_restroom,
        typeText: "家庭保健"
    ),
  ];

  //家政员表





  //获取首页banner数据
  Future<void> getBannerData() async{
    //实际上是从网络获取首页轮播图的 url 数据
    bannerData = [
      "https://ts1.cn.mm.bing.net/th?id=OIP-C.B7s9EVvW1IdSZjrCyuO-UQHaE7&w=306&h=204&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2",
      "https://tse2-mm.cn.bing.net/th/id/OIP-C.2jppo4FREzcAspyReKeM_QHaE7?w=270&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
      "https://tse1-mm.cn.bing.net/th/id/OIP-C.uR2QXJ9hccoOwwcRWr0KgQHaE8?w=246&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
      "https://tse1-mm.cn.bing.net/th/id/OIP-C.xRabqwQsw4kwkby5S7Uy_wHaE9?w=252&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7"
    ];
    notifyListeners();
  }
}
