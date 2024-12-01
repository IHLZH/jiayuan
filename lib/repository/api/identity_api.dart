import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/http_method.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../utils/sp_utils.dart';

class IdentityApi{

  static IdentityApi instance = IdentityApi._();

  IdentityApi._();

  Future<bool> getCardNoAuth({required String cardNo, required String realName}) async {
    try{
      final Response response = await DioInstance.instance().post(
          path: UrlPath.CardNoAuthPath,
          options: Options(
              method: HttpMethod.POST,
              headers: {
                "Authorization" : Global.token
              }
          ),
          data: {
            "realName": realName,
            "idCard": cardNo
          },
      );

      if(response.statusCode == 200){
        if(response.data['code'] == 200){
          Global.token = response.data['message'];
          //持久化
          await SpUtils.saveString("token", Global.token!);
          return true;
        }else{
          showToast(response.data['message']);
        }
      }else{
        showToast("网络连接错误");
      }

    }catch(e){
      print("身份证号码认证请求错误" + e.toString());
    }
    return false;
  }

  Future<bool> getIdCardAuth({required String idCardFront, required String idCardBack}) async {
    try{
      final Response response = await DioInstance.instance().post(
          path: UrlPath.IdCardFrontAuthPath,
          options: Options(
            method: HttpMethod.POST,
              headers: {
                "Authorization" : Global.token
              },
          ),
          data:  {
            "front":idCardFront,
            "back":idCardBack
          },
      );

      if(response.statusCode == 200){
        if(response.data['code'] == 200){
          return response.data['data'];
        }else{
          print("服务器错误：" + response.data['code'].toString() + " " + response.data['message']);
        }
      }else{
        showToast("网络连接错误");
      }
    }catch(e){
      print("身份证照片认证请求错误" + e.toString());
    }
    return false;
  }
}