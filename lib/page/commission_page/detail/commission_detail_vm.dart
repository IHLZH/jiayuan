import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/repository/model/user.dart';

class CommissionDetailViewModel with ChangeNotifier{

  User? user;

  Commission commission = Commission(
      commissionType: 0,
      province: "未知",
      city: "未知",
      county: "未知",
      address: "未知",
      userPhone: "未知",
      price: 0.0,
      expectTime: DateTime(2000),
      estimatedTime: 0.0,
      commissionStatus: 0,
      isLong: false
  );

  CommissionData1 commissionData = CommissionData1();

  void getUserById(int id){
    user = User(
        userId: id,
        userName: "userName",
        nickName: "用户114514号",
        userPassword: "",
        userAvatar: "https://i1.hdslb.com/bfs/face/ff445d09efe51be21b6d8170e746699899fb9c52.jpg@92w_92h.avif",
        userSex: 0,
        userPhoneNumber: "11451419198",
        createdTime: "createdTime",
        updatedTime: "updatedTime",
        loginIp: "loginIp",
        loginTime: "loginTime",
        userType: 0,
        userStatus: 0
    );
  }

}