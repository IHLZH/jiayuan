import 'package:flutter/cupertino.dart';

class HomeViewModel with ChangeNotifier{
   // 轮播图数据
  List<String?>? bannerData = [];


  //存放小图标及委托类型，用于显示委托类型
  final List<Map<String,dynamic>> _commissionTypeList = [
    {"icon":"assets/images/icons/commission_type_1.png","name":"快递"},
    {"icon":"assets/images/icons/commission_type_2.png","name":"外卖"},
    {"icon":"assets/images/icons/commission_type_3.png","name":"快递"},
    {"icon":"assets/images/icons/commission_type_4.png","name":"快递"},
  ];

  List<Map<String,dynamic>> get commissionTypeList => _commissionTypeList;


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