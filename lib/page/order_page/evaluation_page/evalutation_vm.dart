import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../repository/model/full_order.dart';
import '../../../utils/global.dart';

class EvalutationViewModel with ChangeNotifier{
  // 评价图片
  List<String>? imageUrls;
  //评论内容
  String? evaluationContent ;
  //总评分
  int? totalRating ;
  //评价时间
  DateTime? evaluationTime ;
  //三个评分
  List<int> rating = [5,5,5];

  FullOrder? order ;

  bool isChanged = true;
  Future<void> submitEvaluation() async {
    try{
      final Response response = await DioInstance.instance().post(
        path: '/order/comment',
        data: {
          'keeperId': order?.keeperId,
          'userId': order?.userId,
          'commentPicUrl': imageUrls,
          'comment': evaluationContent,
          'star': (rating[0]+rating[1]+rating[2])/3.ceil(),
        },
        queryParameters: {
          'commissionId': order?.commissionId,
          'status': 7
        },
        options: Options(
          headers: {
            'Authorization': Global.token,
          }
        ),
      );
      if(response.data['code'] == 200){
        print('评价成功');
      }else{
        print('评价失败 ${response.data['message']}');
      }
    }catch(e){
      print('网络请求失败 ${e}');
      print( e);
    }
  }

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
