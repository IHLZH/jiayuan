import 'package:flutter/material.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';

class KeeperViewModel with ChangeNotifier {
  HousekeeperDataDetail? keeperData ;

  Future getKeeperData(int id) async {
    // 模拟数据获取
    keeperData =  HousekeeperDataDetail(
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
        contact: "15233112551",
        evaluations: [
          Evaluation(
            userId: 1,
            avatar:
                'https://ts4.cn.mm.bing.net/th?id=OIP-C.tkf6dOy8a385XvaSTPjccwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
            nickname: "王女士",
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
            nickname: "张先生",
            content: "服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意服务态度很好，态度很好，对商家很满意",
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
    notifyListeners();
  }
}
