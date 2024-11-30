import 'package:dio/dio.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/http_method.dart';

class KeeperApi {
  static KeeperApi instance = KeeperApi._();

  KeeperApi._();

  //收藏家政员
  Future<void> addFavorite(int? id) async {
    try {
      final Response response = await DioInstance.instance().post(
        path: UrlPath.collectKeeper,
        queryParameters: {"keeperId": id},
        options: Options(headers: {"Authorization": Global.token}),
      );
      print('收藏返回数据:${response.data}');
      if (response.data['code'] == 200) {
        print("收藏成功");
      } else {
        print("收藏失败");
      }
    } catch (e) {
      print("收藏失败：" + e.toString());
    }
  }

  //根据家政员id获取家政员详细信息
  Future<HousekeeperDataDetail> getKeeperDataDetail(int id) async {
    HousekeeperDataDetail housekeeperDataDetail = HousekeeperDataDetail();
    try {
      final Response response =
          await DioInstance.instance().get(path: "/release/keeper", param: {
        "keeperId": id,
      });
      if (response.data['code'] == 200) {
        print('获取到的家政员详细信息:${response.data}');
        if (response.data['data'] == null) response.data['data'] = {};
        housekeeperDataDetail =
            HousekeeperDataDetail.fromJson(response.data['data']);
        print('获取到的家政员详细信息:${response.data['data']}');
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
      housekeeperDataDetail = HousekeeperDataDetail();
    }
    return housekeeperDataDetail;
  }

  //根据委托类型推荐
  Future<List<Housekeeper>> getHousekeeperData(double? lng, double? lat,
      {int? id}) async {
    List<Housekeeper> housekeepers = [];
    try {
      print('推荐的参数${lng},${lat}');
      print('token参数');
      print('${Global.token}');
      final Response response = await DioInstance.instance().get(
          path: "/release/keeper/list",
          param: {"longitude": lng, "latitude": lat, "typeId": id},
          options: Options(headers: {"Authorization": Global.token}));
      if (response.data['data'] != null) {
        housekeepers = (response.data["data"] as List)
            .map((e) => Housekeeper.fromJson(e))
            .toList();
        housekeepers.forEach((item) => print(item.realName));
      }
      print('获取到的推荐数据${response.data["data"]}');
    } catch (e) {
      print("请求失败ss" + e.toString());
    }
    return housekeepers;
  }

  //根据userId来获取家政员信息
  Future<void> getKeeperDataByUserId() async {
    try {
      final Response response = await DioInstance.instance().get(
          path: UrlPath.getKeeperDataByUserId,
          options: Options(
            method: HttpMethod.POST,
            headers: {"Authorization": Global.token},
          ));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          print("获取家政员信息成功" + response.data['data'].toString());
          Global.keeperInfo =
              HousekeeperDataDetail.fromJson(response.data['data']);
        } else {
          print("服务器错误：" +
              response.data['code'].toString() +
              " " +
              response.data['message']);
        }
      } else {
        showToast("网络错误");
      }
    } catch (e) {
      print("获取家政员信息失败：" + e.toString());
    }
  }

  //更新家政员信息
  Future<void> updateKeeperInfo(
      HousekeeperDataDetail housekeeperDataDetail) async {
    try {
      final Response response = await DioInstance.instance().post(
        path: UrlPath.updateKeeperInfo,
        data: housekeeperDataDetail.toJson(),
        options: Options(
          headers: {"Authorization": Global.token},
        ),
      );
      print('更新信息: ${housekeeperDataDetail.toJson()}');
      print('返回数据: ${response.data}');
      if (response.data['code'] == 200) {
        print("更新家政员信息成功");
      } else {
        print("更新家政员信息失败");
      }
    } catch (e) {
      print("更新家政员信息失败：" + e.toString());
    }
  }

  Future<void> releaseHeart() async {
    try {
      final Response response = await DioInstance.instance().get(
          path: "/release/heart",
          options: Options(headers: {"Authorization": Global.token}));
    } catch (e) {
      print("心跳请求失败ss" + e.toString());
    }
  }

  // 根据家政员id获取相关评论
  Future<List<Evaluation>> getComments(int id, int page, int size) async {
    List<Evaluation> evaluations = [];
    try {
      final Response response = await DioInstance.instance().get(
          path: "/keeper/comment",
          param: {"keeperId": id, "page": page, "pageSize":size},
          options: Options(headers: {"Authorization": Global.token}));
      if (response.data['data'] != null) {
        print('获取到的评论数据${response.data["data"]}');
        evaluations.addAll((response.data["data"] as List)
            .map((e) => Evaluation.fromJson(e))
            .toList());
        evaluations.forEach((item) => print(item.nickName));
      }

    } catch (e) {
      print("请求失败ss" + e.toString());
    }
    return evaluations;
  }
}
