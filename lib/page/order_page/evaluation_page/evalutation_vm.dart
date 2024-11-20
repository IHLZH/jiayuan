import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../repository/model/full_order.dart';

class EvalutationViewModel with ChangeNotifier{
  // 评价图片
  List<String>? imageUrls;
  //评论内容
  String? evaluationContent ;
  //总评分
  double? totalRating ;
  //评价时间
  DateTime? evaluationTime ;
  //三个评分
  List<int> rating = [5,5,5];
  FullOrder? order ;

  bool isChanged = true;

  updateRating(int index,int value){
    rating[index] = value;
    notifyListeners();
  }

  updateEvaluationContent(String value){
    evaluationContent = value;
    notifyListeners();
  }


  updateIsChanged() {
    isChanged = !isChanged;
    notifyListeners();
  }

    //拨打电话
  Future<void> makePhoneCall(String phone) async {
    try {
      if (phone == null) {
        throw '电话号码不能为空';
      }
      var status = await Permission.phone.status;
      if(!status.isGranted){
        status = await Permission.phone.request();
        if (!status.isGranted) {
          throw '需要电话权限才能拨打电话';
        }
      }

      final phoneNumber = phone.replaceAll(RegExp(r'[^\d]'), '');
      final Uri telUri = Uri.parse('tel:${phone}');
      print('准备拨打电话: ${telUri.toString()}');

      if (await canLaunchUrl(telUri,)) {
        await launchUrl(telUri,mode: LaunchMode.externalApplication);
      } else {
        throw '无法拨打电话: ${phoneNumber}';
      }
    } catch (e) {
      print('拨打电话失败: $e');
      // 可以在这里添加错误提示
      rethrow;
    }
  }
}