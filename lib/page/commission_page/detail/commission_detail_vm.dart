import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/commission_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CommissionDetailViewModel with ChangeNotifier{

  User? user;

  CommissionData1 commissionData = CommissionData1();

  Future<void> makePhoneCall(String phoneNumber) async {
    var status = await Permission.phone.status;
    if(!status.isGranted){
      status = await Permission.phone.request();
      if (!status.isGranted) {
        throw '需要电话权限才能拨打电话';
      }
    }

    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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