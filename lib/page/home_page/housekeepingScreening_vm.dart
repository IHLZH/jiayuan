import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';

class HouseKeepingScreeningVM with ChangeNotifier{
  Map<int,List<Housekeeper>> housekeepersByType = {};
  int currentIndex = 0;

  Future<void> loadHouseKeepers(int typeIndex) async {
    print("开始加载数据: index = $typeIndex");
    if(housekeepersByType[typeIndex] != null){
      print("数据加载完成: ${housekeepersByType[typeIndex]?.length ?? 0}条记录");
      return ;
    }
    
    try {
      //模拟网络请求
      await Future.delayed(Duration(milliseconds: 500)); // 缩短延迟时间
      List<Housekeeper> housekeepersData = List.generate(
          housekeepers.length,
          (index)=> housekeepers[index]
      );
      housekeepersByType[typeIndex] = housekeepersData;
      notifyListeners();
      print('数据加载完毕');
    } catch (e) {
      print("加载数据失败: $e");
    }
  }

  //获取家政员数据
  static List<Housekeeper> housekeepers = [
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
    keeperId: 2,
    avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
    workExperience: 5,
    rating: 4.7,
    highlight: "家事全包，价格便宜，服务态度好"
    ),

    Housekeeper(
    realName: "李小明",
    keeperId: 2,
    age: 18,
    avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
    workExperience: 5,
    rating: 5,
    highlight: "家电维修，，价格实惠"
    ),

    Housekeeper(
    realName: "李小明",
    keeperId: 2,
    age: 18,
    avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
    workExperience: 5,
    rating: 5,
    highlight: "家电维修，，价格实惠"
    ),

    Housekeeper(
    realName: "李小明",
    keeperId: 2,
    age: 18,
    avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
    workExperience: 5,
    rating: 5,
    highlight: "家电维修，，价格实惠"
    ),

    Housekeeper(
    realName: "李小明",
    keeperId: 2,
    age: 18,
    avatar: "https://th.bing.com/th?id=OIP.A_3uAao9gpskoDD1vNDJBAAAAA&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2`",
    workExperience: 5,
    rating: 5,
    highlight: "家电维修，，价格实惠"
    ),
    ];

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}