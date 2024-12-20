import 'package:dio/dio.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class RejectReasonApi {
  //单例模式
  RejectReasonApi._internal();

  static final RejectReasonApi _instance = RejectReasonApi._internal();

  factory RejectReasonApi() => _instance;

  Future<String> getRejectReason(int id) async {
    String url = UrlPath.getRejectReason;

    try {
      final response = await DioInstance.instance().get(
          path: url,
          param: {'commissionId': id},
          options: Options(headers: {'Authorization': Global.token!}));

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          return response.data['data']?? "无";
        } else {
          if (isProduction) print("${response.data['message']}");
          showToast("${response.data['message']}",
              duration: const Duration(seconds: 1));
        }
      } else {
        if (isProduction) print("无法连接服务器");
        showToast("无法连接服务器", duration: const Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }

    return "无";
  }
}
