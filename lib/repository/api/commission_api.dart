import 'package:dio/dio.dart';
import 'package:jiayuan/http/url_path.dart';

import '../../http/dio_instance.dart';
import '../model/Commission.dart';
import '../model/standardPrice.dart';
import '../model/commission_data1.dart';

class CommissionApi{
  static CommissionApi instance = CommissionApi._();

  CommissionApi._();

  //委托接取首页推荐委托
  Future<List<CommissionData1>> getRecommendCommission(Map<String, dynamic>? param) async {
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: "/search_by_distance",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['data'][i]));
        }
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //搜索委托
  Future<List<CommissionData1>> getSearchCommission(Map<String, dynamic>? param) async{
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: "/search",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['results'][i]));
        }
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //请求委托
  Future<List<CommissionData1>> getCommission(Map<String, dynamic> param) async{
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: "/searchList_by_money_distance",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['results'][i]));
        }
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  Future<String> sendCommission(Commission commission, int serviceType) async {
    Response response = await DioInstance.instance().post(
        path: UrlPath.sendCommissionUrl,
        data: commission.toJson(),
        queryParameters: {"serviceId": serviceType});
    return response.data['code'].toString();
  }

  //获取所有委托的价格
  Future<List<StandardPrice>> getAllPrice() async {
    List<StandardPrice> priceList = [];
    Response response = await DioInstance.instance().get(path: UrlPath.getAllPriceUrl);
    print('获取价格数据${response.data['data']}');
    if (response.data['code'] == 200) {
      priceList = response.data['data'].map<StandardPrice>((e) => StandardPrice.fromJson(e)).toList();
    }
    // 检查 typeId 的数据类型
    priceList.sort((a,b) =>  a.typeId!.compareTo(b.typeId as num));
    priceList.forEach((item) => print('${item.typeId} ${item.referencePrice}'));
    return priceList;
  }


}