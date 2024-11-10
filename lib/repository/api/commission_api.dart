import 'package:dio/dio.dart';

import '../../http/dio_instance.dart';
import '../model/Commission.dart';
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
  Future<List<CommissionData1>> getCommission({required String path, required Map<String, dynamic> param}) async{
    List<CommissionData1> commissionList = [];

    try{
      final Response response = await DioInstance.instance().get(
          path: path,
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

  //发送委托
  Future<String> sendCommission(Commission commission) async{
      // Response response = await DioInstance.instance().post(path: "/commission/add",data: commission.toJson(), options: Options(headers: {'Content-Type': 'application/json'}),);
    // return response.statusCode.toString();
    return "200";
  }
}