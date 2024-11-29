import 'package:dio/dio.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/http_method.dart';
import '../model/certificate.dart';

class KeeperApi {
  static KeeperApi instance = KeeperApi._();

  KeeperApi._();

  //根据家政员id获取家政员详细信息
  Future<HousekeeperDataDetail> getKeeperDataDetail(int id) async {
    HousekeeperDataDetail housekeeperDataDetail = HousekeeperDataDetail();
    try {
      final Response response =
          await DioInstance.instance().get(path: "/release/keeper", param: {
        "keeperId": id,
      });
      if (response.statusCode == 200) {
        housekeeperDataDetail =
            HousekeeperDataDetail.fromJson(response.data['data']);
        print('获取到的家政员详细信息:${response.data['data']}');
      }
    } catch (e) {
      print("网络错误error:" + e.toString());
    }
    housekeeperDataDetail = HousekeeperDataDetail(
        keeperId: id,
        realName: "刘子恒",
        age: 30,
        avatar:
            'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
        workExperience: 10,
        rating: 4.5,
        city: "北京市",
        completedOrders: 20,
        tags: ["日常保洁", "住家保姆"],
        keeperImages: [
          'https://tse1-mm.cn.bing.net/th/id/OIP-C.rl-4Fq8iiNCXDKLUWMMj5wHaHa?w=210&h=210&c=7&r=0&o=5&dpr=1.3&pid=1.7',
          'https://tse1-mm.cn.bing.net/th/id/OIP-C.rl-4Fq8iiNCXDKLUWMMj5wHaHa?w=210&h=210&c=7&r=0&o=5&dpr=1.3&pid=1.7',
          'https://tse1-mm.cn.bing.net/th/id/OIP-C.rl-4Fq8iiNCXDKLUWMMj5wHaHa?w=210&h=210&c=7&r=0&o=5&dpr=1.3&pid=1.7'
        ],
        introduction:
            "我是一个非常 normalization 的人，我的服务非常好，深受顾客好评,我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评",
        certificates: [
          'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
          'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
          'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
          'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
        ],
        contact: "19358097918",
        evaluations: [
          Evaluation(
              userId: 1,
              avatar:
                  'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
              nickName: "王女士",
              content: "服务态度很好，态度很好",
              time: DateTime(2021, 2, 23),
              images: [
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2'
              ],
              rating: 4.5),
          Evaluation(
              userId: 2,
              avatar:
                  'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
              nickName: "张先生",
              content:
                  "服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意",
              time: DateTime(2024, 2, 25),
              images: [
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
              ],
              rating: 3.2),
        ]);
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

}
