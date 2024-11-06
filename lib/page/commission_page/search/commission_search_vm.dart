import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/utils/global.dart';

class CommissionSearchViewModel with ChangeNotifier{

  List<String> searchHistory = [];

  List<Commission> searchResult = [];

  double? minPrice;
  double? maxPrice;
  double? distance;

  Future<void> deleteSearchHistory() async {
    await Global.dbUtil?.open();
    int row = await Global.dbUtil?.delete("delete from search_history", []) ?? -1;
    if(row >= 0){
      print("历史搜索删除成功");
    }else{
      print("历史搜索删除失败");
    }
    await Global.dbUtil?.close();
  }


  Future<void> getSearchHistory() async {
    await Global.dbUtil?.open();
    searchHistory = [
      "保姆","月嫂","日常保洁","修管道"
    ];
    List<Map> history = await Global.dbUtil?.queryList("select * from search_history") ?? [];
    if(history.length > 0){
      for (var value in history) {
        searchHistory.add(value["search_msg"]);
      }
      print(history.length.toString() + "条" + "历史搜索" + "查询成功");
    }else{
      print("历史搜索" + "查询失败");
    }
    await Global.dbUtil?.close();
  }

  Future<void> saveSearchHistory(String searchMsg) async {
    await Global.dbUtil?.open();
    Map<String, String> msg = Map<String, String>();
    msg["search_msg"] = searchMsg;
    int row = await Global.dbUtil?.insertByHelper("search_history", msg) ?? 0;
    if(row > 0){
      print("历史搜索：" + searchMsg + " 插入成功");
    }else{
      print("历史搜索：" + searchMsg + " 插入失败");
    }
    await Global.dbUtil?.close();
  }

  void searchCommission(String searchMessage){
    searchResult = [
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,5,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,2,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,3,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
      Commission(
          commissionType: 1,
          province: "河北省",
          city: "石家庄",
          county: "裕华区",
          address: "河北师范大学",
          userPhone: "19358756689",
          distance: 1.5,
          price: 255.25,
          expectTime: DateTime(2024,11,4,12,30),
          estimatedTime: 2,
          commissionStatus: 0,
          isLong: false
      ),
    ];
  }

}