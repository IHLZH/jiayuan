import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CommissionDetailViewModel with ChangeNotifier{

  User? user;

  CommissionData1 commissionData = CommissionData1();

  //委托接取
  Future<int> changeCommissionStatus(int newStatu) async {
    if((Global.userInfo?.userType ?? 0) == 1){
      bool result = await CommissionApi.instance.changeOrderStatus({
        "commissionId":commissionData.commissionId,
        "new":newStatu
      });
      if(result) {
        return 1;
      }
    }
    return 0;
  }

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

  String obfuscatePhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 7) {
      return phoneNumber.replaceRange(3, 7, "****");
    }
    return phoneNumber; // 如果号码长度不足，不处理
  }

}