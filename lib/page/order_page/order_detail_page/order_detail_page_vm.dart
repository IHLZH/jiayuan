import 'package:jiayuan/repository/model/full_order.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPageVm {
  static FullOrder? nowOrder;

  static String? rejectReason;

  static String? keeperPhone;

  static Future<void> makePhoneCall(String phoneNumber) async {
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
}