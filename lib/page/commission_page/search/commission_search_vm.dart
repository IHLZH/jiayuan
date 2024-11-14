import 'package:flutter/widgets.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommissionSearchViewModel with ChangeNotifier{

  List<String> searchHistory = [];

  List<Commission> searchResult = [];

  List<CommissionData1> searchCommissionList = [];

  //刷新控制器
  RefreshController refreshController = RefreshController();

  double minPrice = 0.0;
  double maxPrice = 999999;
  double distance = 10;

  bool isSearch = false;
  String? searchMessage;

  bool? synthesisCheck; //选择综合排序
  bool? priceCheck; //选择价格排序
  bool? distanceCheck; //选择距离排序

  bool? priceHigh; //价格是否从高到低

  int order = 0;

  //分页请求
  int startPage = 1;
  int endPage = 1;
  int size = 11;
  bool hasMoreData = true;


  Future<void> search(String searchMessage) async {
    isSearch = true;
    synthesisCheck = true;
    priceCheck = false;
    distanceCheck = false;
    this.searchMessage = searchMessage;
    order = 0;
    if(searchMessage != "")saveSearchHistory(searchMessage);
    await getSearchCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order":order
    });
    notifyListeners();
  }

  Future<void> getHisory() async {
    await getSearchHistory();
    notifyListeners();
  }

  Future<void> deleteHistory() async {
    await deleteSearchHistory();
    await getHisory();
    notifyListeners();
  }

  //点击综合排序
  Future<void> checkSynthesis() async {
    if(synthesisCheck!)return;
    synthesisCheck = true;
    priceCheck = false;
    distanceCheck = false;
    order = 0;

    await getSearchCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order":order
    });

    notifyListeners();
  }

  Future<void> checkPrice() async {
    if(priceCheck!){
      priceHigh = !(priceHigh!);
    }else{
      priceCheck = true;
      priceHigh = false;
      synthesisCheck = false;
      distanceCheck = false;
    }

    order = priceHigh! ? 2 : 1;

    await getSearchCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order": order,
    });

    notifyListeners();
  }

  Future<void> checkDistance() async {
    if(distanceCheck!)return;
    distanceCheck = true;
    priceCheck = false;
    synthesisCheck = false;

    order = 3;

    await getSearchCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order": order,
    });

    notifyListeners();
  }

  Future<void> getSearchCommission(Map<String, dynamic> param) async {
    List<CommissionData1> searchCommissionData = await CommissionApi.instance.searchCommission(param);
    if(!searchCommissionData.isEmpty){
      searchCommissionList = searchCommissionData;
      print("接收到" + searchCommissionList.length.toString() + "条数据");
    }else{
      searchCommissionList.clear();
      print("数据为空");
    }
  }

  Future<void> refreshCommission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.searchCommission(param);
    if(!commissionData.isEmpty){
      searchCommissionList = commissionData;
    }else{
      if(startPage == 1)return;
      startPage = 1;
      param["page"] = startPage;
      await refreshCommission(param);
    }
  }

  Future<void> loadingCommission(Map<String, dynamic> param) async {
    List<CommissionData1> commissionData = await CommissionApi.instance.searchCommission(param);
    if(!commissionData.isEmpty){
      searchCommissionList.addAll(commissionData);
    }else{
      if(endPage == 1)return;
      endPage = 1;
      param["page"] = endPage;
      await loadingCommission(param);
    }
  }

  Future<void> onLoading() async {
    if(hasMoreData){
      endPage++;
      await loadingCommission({
        "search":searchMessage,
        "page":endPage,
        "size":size,
        "min":minPrice,
        "max":maxPrice,
        "distance":distance,
        "order": order,
      });
      if(searchCommissionList.length >= 110){
        hasMoreData = false;
        refreshController.loadNoData();
        notifyListeners();
      }else{
        refreshController.loadComplete();
        notifyListeners();
      }
    }else{
      refreshController.loadNoData();
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    startPage++;
    endPage = startPage;
    await refreshCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order": order,
    });
    hasMoreData = true;
    refreshController.resetNoData();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> siftCommission() async {
    startPage = 1;
    endPage = 1;
    await getSearchCommission({
      "search":searchMessage,
      "page":startPage,
      "size":size,
      "min":minPrice,
      "max":maxPrice,
      "distance":distance,
      "order": order,
    });
    notifyListeners();
  }

  Future<void> deleteSearchHistory() async {

    int row = await Global.dbUtil?.delete("delete from search_history", []) ?? -1;
    if(row >= 0){
      print("历史搜索删除成功");
    }else{
      print("历史搜索删除失败");
    }

  }


  Future<void> getSearchHistory() async {

    searchHistory = [

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
  }

  Future<void> saveSearchHistory(String searchMsg) async {
    Map<String, String> msg = Map<String, String>();
    msg["search_msg"] = searchMsg;
    int row = await Global.dbUtil?.insertByHelper("search_history", msg) ?? 0;
    if(row > 0){
      print("历史搜索：" + searchMsg + " 插入成功");
    }else{
      print("历史搜索：" + searchMsg + " 插入失败");
    }
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