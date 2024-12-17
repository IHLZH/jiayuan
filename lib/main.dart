import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/ai_customer_service_page/ai_customer_service_vm.dart';
import 'package:jiayuan/page/tab_page/tab_page.dart';
import 'package:provider/provider.dart';

import 'http/dio_instance.dart';

Future<void> main() async {
  DioInstance.instance().initDio(baseUrl: UrlPath.yuwenBaseUrl);
  await ScreenUtil.ensureScreenSize();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AiCustomerServiceViewModel()),
    ],
    child: MyApp(),
  ));
}
