import 'package:flutter/material.dart';

import '../page/commission_page/commission_vm.dart';

//公共数据类
class CommonData{
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

  //订单状态表
  static List<String> orderStatus = [
    "待接取",
    "待确认",
    "待服务",
    "服务中",
    "待支付",
    "已完成",
    "已取消"
  ];
}