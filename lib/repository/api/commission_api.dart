import 'package:dio/dio.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../model/Commission.dart';
import '../model/standardPrice.dart';
import '../model/commission_data1.dart';

class CommissionApi{
  static CommissionApi instance = CommissionApi._();

  CommissionApi._();

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
        print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['results'][i]));
        }
      }else{
        showToast(
          "网络错误，请检查网络连接"
        );
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //请求委托
  Future<List<CommissionData1>> searchCommission(Map<String, dynamic> param) async{
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: "/search_list_by_order",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['results'][i]));
        }
      }else{
        showToast(
            "网络错误，请检查网络连接"
        );
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //请求委托
  Future<List<CommissionData1>> recommendCommission(Map<String, dynamic> param) async{
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: "/search_by_distance",
          param: param
      );

      if(response.statusCode == 200){
        int total = response.data['total'];
        print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for(int i = 0; i < total; i++){
          commissionList.add(CommissionData1.fromJson(response.data['results'][i]));
        }
      }else{
        showToast(
            "网络错误，请检查网络连接"
        );
      }
    }catch(e){
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //发布委托
  Future<String> sendCommission(Commission commission, int serviceType) async {
    Response response = await DioInstance.instance().post(
        path: UrlPath.sendCommissionUrl,
        data: commission.toJson(),
        queryParameters: {"serviceId": serviceType},
       options: Options(headers: {"token":Global.token})
    );
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