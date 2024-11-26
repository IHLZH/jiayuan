import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/tab_page/tab_page.dart';

import 'http/dio_instance.dart';

Future<void> main() async {
  DioInstance.instance().initDio(baseUrl: UrlPath.yuwenBaseUrl);
  await ScreenUtil.ensureScreenSize();
  runApp(MyApp());



}


