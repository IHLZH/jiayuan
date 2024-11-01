import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/app.dart';
import 'package:jiayuan/page/tab_page.dart';

import 'http/dio_instance.dart';

Future<void> main() async {
  DioInstance.instance().initDio(baseUrl: "http://192.168.3.32:9900/");
  await ScreenUtil.ensureScreenSize();
  runApp(MyApp());
}
