import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class CookieInterceptor{
  CookieManager getCookieManager(){
    return CookieManager(CookieJar());
  }
}