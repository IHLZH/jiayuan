import 'package:dio/dio.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../model/commission_data1.dart';
import '../model/standardPrice.dart';

class CommissionApi {
  static CommissionApi instance = CommissionApi._();

  CommissionApi._();

  //分类请求委托
  Future<List<CommissionData1>> getCommission(
      Map<String, dynamic> param) async {
    List<CommissionData1> commissionList = [];

    try {
      final Response response = await DioInstance.instance()
          .get(path: UrlPath.getTypeCommission, param: param);

      if (response.statusCode == 200) {
        int total = response.data['total'];
        // print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for (int i = 0; i < total; i++) {
          commissionList
              .add(CommissionData1.fromJson(response.data['results'][i]));
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //搜索请求委托
  Future<List<CommissionData1>> searchCommission(
      Map<String, dynamic> param) async {
    List<CommissionData1> commissionList = [];

    try {
      final Response response = await DioInstance.instance()
          .get(path: UrlPath.searchCommission, param: param);

      if (response.statusCode == 200) {
        int total = response.data['total'];
        // print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for (int i = 0; i < total; i++) {
          commissionList
              .add(CommissionData1.fromJson(response.data['results'][i]));
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  //推荐请求委托
  Future<List<CommissionData1>> recommendCommission(
      Map<String, dynamic> param) async {
    List<CommissionData1> commissionList = [];

    try {
      final Response response = await DioInstance.instance()
          .get(path: UrlPath.getRecommendCommission, param: param);

      if (response.statusCode == 200) {
        int total = response.data['total'];
        //   print("第" + param["page"].toString() + "页" + " " + "共请求到" + total.toString() + "条数据");
        for (int i = 0; i < total; i++) {
          commissionList
              .add(CommissionData1.fromJson(response.data['results'][i]));
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }

    return commissionList;
  }

  Future<CommissionData1> getCommissionById(Map<String, dynamic> param) async {

    late CommissionData1 commissionData;

    try {
      final Response response = await DioInstance.instance()
          .get(path: UrlPath.getCommissionById, param: param, options: Options(headers: {"Authorization": Global.token}));

      if (response.statusCode == 200) {
        if(response.data['code'] == 200){
          commissionData = CommissionData1.fromJson(response.data['data']);
        }else{
          showToast("请求失败 ${response.data['message']}");
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }

    return commissionData;
  }

  //更改订单状态
  Future<bool> changeOrderStatus(Map<String, dynamic> param) async {
    try {
      final Response response = await DioInstance.instance().put(
          path: UrlPath.changeOrderStatus,
          queryParameters: param,
          options: Options(headers: {"Authorization": Global.token}));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }
    return false;
  }

  Future<List<CommissionData1>> getOrderByStatus(
      Map<String, dynamic> param) async {
    List<CommissionData1> orderList = [];
    try {
      final Response response = await DioInstance.instance().get(
        path: UrlPath.getOrderByStatus,
        param: param,
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          final data = response.data['data'] as List;
          //   print("请求成功" + data.toString() + data.length.toString());
          for (int i = 0; i < data.length; i++) {
            orderList.add(CommissionData1.fromJson(data[i]));
          }
        } else {
          print("服务器错误：" +
              response.data['code'].toString() +
              " " +
              response.data['message']);
        }
      } else {
        showToast("网络错误，请检查网络连接");
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }
    return orderList;
  }

  //发布委托
  Future<String> sendCommission(
      CommissionData1 commission, int serviceType) async {
    Response response = await DioInstance.instance().post(
        path: UrlPath.sendCommissionUrl,
        data: commission.toJsonForSend(),
        queryParameters: {"serviceId": serviceType},
        options: Options(headers: {"Authorization": Global.token}));
    return response.data['code'].toString();
  }

  //获取所有委托的价格
  Future<List<StandardPrice>> getAllPrice() async {
    List<StandardPrice> priceList = [];
    Response response =
        await DioInstance.instance().get(path: UrlPath.getAllPriceUrl);
    // print('获取价格数据${response.data['data']}');
    if (response.data['code'] == 200) {
      priceList = response.data['data']
          .map<StandardPrice>((e) => StandardPrice.fromJson(e))
          .toList();
    }
    // 检查 typeId 的数据类型
    priceList.sort((a, b) => a.typeId!.compareTo(b.typeId as num));
    priceList.forEach((item) => print('${item.typeId} ${item.referencePrice}'));
    return priceList;
  }

  Future<List<CommissionData1>> getOrderCompleted(int year, int month) async {
    List<CommissionData1> orderList = [];
    Response response = await DioInstance.instance().get(
        path: UrlPath.getOrderCompleted,
        param: {"month": month, "year": year, "keeperId": Global.keeperInfo?.keeperId});
    print('获取已完成订单参数：${{"month": month, "year": year, "keeperId": Global.keeperInfo!.keeperId}}');
    print('${response.data}');
    if (response.data['code'] == 200) {
      print('获取已完成订单数据${response.data['data'].toList().length}');
      orderList = response.data['data'].map<CommissionData1>((e) => CommissionData1.fromJson(e)).toList();
    }
    return orderList;
  }
}
