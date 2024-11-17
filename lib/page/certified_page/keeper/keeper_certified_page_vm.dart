import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/repository/api/identity_api.dart';

class KeeperCertifiedPageViewModel with ChangeNotifier{

  XFile idCardFront = XFile("");

  XFile idCardBack = XFile("");

  XFile selfAvatar = XFile("");

  String name = "";
  String idCard = "";
  String phoneNumber = "";

  Future<void> getCardNoAuth() async {
    bool result = await IdentityApi.instance.getCardNoAuth(
        cardNo: idCard,
        realName: name
    );

    if(result){
      print("身份证号码验证通过");
    }else{
      print("身份证号码验证失败");
    }
  }

  Future<void> getIdCardFrontAuth() async {

    File imageFile = File(idCardFront.path);

    // 读取图片文件的字节
    List<int> imageBytes = await imageFile.readAsBytes();

    // 将字节转换为 Base64 字符串
    String idCardBase64 = base64Encode(imageBytes);

    bool result = await IdentityApi.instance.getIdCardFrontAuth(
        idCardNo: idCard,
        idCardBase64: idCardBase64
    );

    if(result){
      print("身份证正面验证通过");
    }else{
      print("身份证正面验证失败");
    }
  }

  Future<void> getIdCardBackAuth() async {

    File imageFile = File(idCardBack.path);

    // 读取图片文件的字节
    List<int> imageBytes = await imageFile.readAsBytes();

    // 将字节转换为 Base64 字符串
    String idCardBase64 = base64Encode(imageBytes);

    bool result = await IdentityApi.instance.getIdCardBackAuth(
        idCardNo: idCard,
        idCardBase64: idCardBase64
    );

    if(result){
      print("身份证反面验证通过");
    }else{
      print("身份证反面验证失败");
    }
  }

}