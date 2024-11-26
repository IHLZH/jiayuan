import 'package:dio/dio.dart';
import 'package:jiayuan/utils/global.dart';

import '../../utils/constants.dart';
import '../../utils/sp_utils.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["token"] = Global.token;
    options.headers["Authorization"] = Global.token;
    handler.next(options);
  }
}
