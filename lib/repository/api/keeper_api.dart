import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/utils/global.dart';

import '../../http/dio_instance.dart';

class KeeperApi{
  static KeeperApi  instance = KeeperApi._();
  KeeperApi._();

  //根据家政员id获取家政员详细信息
  Future<HousekeeperDataDetail> getKeeperDataDetail(int id) async{
    HousekeeperDataDetail housekeeperDataDetail = HousekeeperDataDetail();
    try{
      final Response response = await DioInstance.instance().get(
          path: "/release/keeper",
          param: {"keeperId": id,}
      );
      if(response.statusCode == 200){
        housekeeperDataDetail = HousekeeperDataDetail.fromJson(response.data);
      }
    }catch(e){
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
        introduction: "我是一个非常 normalization 的人，我的服务非常好，深受顾客好评,我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评我是一个非常 normalization 的人，我的服务非常好，深受顾客好评",
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
              time: DateTime(2021,2,23),
              images: [
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2'
              ],
              rating: 4.5
          ),
          Evaluation(
              userId: 2,
              avatar:
              'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
              nickName: "张先生",
              content: "服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意",
              time: DateTime(2024,2,25),
              images: [
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.mPGy-QSWMXym-J4zC_MJfwAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
              ],
              rating: 3.2
          ),
        ]);
    return housekeeperDataDetail;
  }

  //根据委托类型推荐
  Future<List<Housekeeper>?> getHousekeeperData(double? lng, double? lat, {int? id}) async{
    List<Housekeeper>  housekeepers = [];
    // try {
    //   print('推荐的参数${lng},${lat}');
    //   final Response response = await DioInstance.instance().get(path: "/release/keeper/list",  param: {"longitude": lng, "latitude": lat, "typeId": id}) ;
    //   housekeepers = (response.data["data"] as List).map((e) => Housekeeper.fromJson(e)).toList();
    //   housekeepers.forEach((item)=>print(item.realName));
    //   print('获取到的推荐数据${response.data["data"]}');
    // }catch(e){
    //   print("请求失败"+e.toString());
    // }
    housekeepers =  [
      Housekeeper(
          realName: "刘子恒",
          keeperId: 1 ,
          age: 20,
          avatar: "https://th.bing.com/th?id=OIP.LO6625C8g41ovz21idvhOgAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2",
          workExperience: 5 ,
          rating: 4.5,
          highlight: "专业通下水道，价格便宜，十年老人"
      ),
      Housekeeper(
          realName: "徐静磊",
          age: 18,
          keeperId: 2,
          avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
          workExperience: 5,
          rating: 4.7,
          highlight: "家事全包，价格便宜，服务态度好"
      ),

      Housekeeper(
          realName: "李小明",
          keeperId: 3,
          age: 18,
          avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
          workExperience: 5,
          rating: 5,
          highlight: "家电维修，，价格实惠"
      ),

      Housekeeper(
          realName: "李小明",
          keeperId: 4,
          age: 18,
          avatar: "https://th.bing.com/th?id=OIP.Lk_V7thpko1MZPfobakoiQAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2",
          workExperience: 5,
          rating: 5,
          highlight: "家电维修，，价格实惠"
      ),

      Housekeeper(
          realName: "李小明",
          keeperId: 5,
          age: 18,
          avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
          workExperience: 5,
          rating: 5,
          highlight: "家电维修，，价格实惠"
      ),

      Housekeeper(
          realName: "李小明",
          keeperId: 6,
          age: 18,
          avatar: "https://th.bing.com/th?id=OIP.yp-D-KHI3e2nN4eMBJcEVAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2",
          workExperience: 5,
          rating: 5,
          highlight: "家电维修，，价格实惠"
      ),
    ];
    return housekeepers;

  }


}
