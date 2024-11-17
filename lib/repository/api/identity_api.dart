import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/http_method.dart';

class IdentityApi{

  static IdentityApi instance = IdentityApi._();

  IdentityApi._();

  String host = "https://zidv2.market.alicloudapi.com";

  String CardNoAuthPath = "/idcard/VerifyIdcardv2";

  String IdCardFrontAuthPath = "/thirdnode/ImageAI/idcardfrontrecongnition";

  String IdCardBackAuthPath = "/thirdnode/ImageAI/idcardbackrecongnition";

  String appCode = "ad39e2a665a04127a665de70ab1a6c2d";

  final _defaultTimeout = const Duration(seconds: 30);

  Dio _dio = Dio();

  void initDio(){
    _dio.options = BaseOptions(
      baseUrl: host,
      responseType: ResponseType.json,
      connectTimeout: _defaultTimeout,
      receiveTimeout: _defaultTimeout,
      sendTimeout: _defaultTimeout,
    );
  }

  Future<bool> getCardNoAuth({required String cardNo, required String realName}) async {
    try{
      final Response response = await _dio.get(
          CardNoAuthPath,
          options: Options(
              method: HttpMethod.GET,
              headers: {
                "Authorization" : "APPCODE " + appCode
              }
          ),
          queryParameters: {
            "cardNo" : cardNo,
            "realName" : realName
          }
      );

      print(response.data);

      //final data = response.data as Map<String, dynamic>;

      if (response.data is String) {
        // 如果是字符串，尝试解析为 JSON
        final data = json.decode(response.data) as Map<String, dynamic>;
        if (data["error_code"] == 0) {
          final result = data["result"] as Map<String, dynamic>;
          bool isok = result["isok"] as bool;
          return isok;
        }
      } else if (response.data is Map<String, dynamic>) {
        // 如果是 Map 类型，直接处理
        final data = response.data as Map<String, dynamic>;
        if (data["error_code"] == 0) {
          final result = data["result"] as Map<String, dynamic>;
          bool isok = result["isok"] as bool;
          return isok;
        }
      }
    }catch(e){
      print("身份证号码认证请求错误" + e.toString());
    }
    return false;
  }

  Future<bool> getIdCardFrontAuth({required String idCardNo, required String idCardBase64}) async {
    try{
      final Response response = await _dio.post(
          IdCardFrontAuthPath,
          options: Options(
            method: HttpMethod.POST,
              headers: {
                "Authorization" : "APPCODE " + appCode
              }
          ),
          data: {
            "base64Str" : idCardBase64
          },
      );

      if (response.data is String) {
        // 如果是字符串，尝试解析为 JSON
        final data = json.decode(response.data) as Map<String, dynamic>;
        print(data["error_code"]);
        if(data["error_code"] == 0){
          return idCardNo == response.data["result"]["idcardno"];
        }
      } else if (response.data is Map<String, dynamic>) {
        // 如果是 Map 类型，直接处理
        final data = response.data as Map<String, dynamic>;
        if(data["error_code"] == 0){
          return idCardNo == response.data["result"]["idcardno"];
        }
      }
    }catch(e){
      print("身份证正面认证请求错误" + e.toString());
    }
    return false;
  }

  Future<bool> getIdCardBackAuth({required String idCardNo, required String idCardBase64}) async {
    try{
      final Response response = await _dio.post(
          IdCardBackAuthPath,
          options: Options(
            method: HttpMethod.POST,
              headers: {
                "Authorization" : "APPCODE " + appCode
              }
          ),
          data: {
            "base64Str" : idCardBase64
          }
      );

      if (response.data is String) {
        // 如果是字符串，尝试解析为 JSON
        final data = json.decode(response.data) as Map<String, dynamic>;
        if(data["error_code"] == 0){
          return isExpired(response.data["result"]["end_data"]);
        }
      } else if (response.data is Map<String, dynamic>) {
        // 如果是 Map 类型，直接处理
        final data = response.data as Map<String, dynamic>;
        if(data["error_code"] == 0){
          return isExpired(response.data["result"]["end_data"]);
        }
      }
    }catch(e){
      print("身份证背面认证请求错误" + e.toString());
    }
    return false;
  }

  //判断是否过期
  bool isExpired(String inputDate) {
    try {
      // 解析输入日期
      DateTime parsedDate = DateFormat("yyyyMMdd").parseStrict(inputDate);
      // 获取当前日期并清除时间部分
      DateTime today = DateTime.now();
      DateTime currentDate = DateTime(today.year, today.month, today.day);
      // 日期没有过期
      return parsedDate.isAfter(currentDate);
    } catch (e) {
      // 输入格式错误时，抛出异常
      return false;
    }
  }

}