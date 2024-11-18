import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/repository/api/identity_api.dart';
import 'package:oktoast/oktoast.dart';

class KeeperCertifiedPageViewModel with ChangeNotifier{

  XFile idCardFront = XFile("");

  XFile idCardBack = XFile("");

  XFile selfAvatar = XFile("");

  String name = "";
  String idCard = "";
  String phoneNumber = "";

  bool _isSuccess = false;
  bool _isFail = false;

  bool _isNameCorrect = true;
  bool _isIdCorrect = true;
  bool _isPhoneCorrect = true;



  Future<void> authenticated() async {
    if(isNameCorrect && isIdCorrect && isPhoneCorrect){
      if(name != "" && idCard != "" && phoneNumber != ""){
        if(idCardFront.path != "" && idCardBack.path != "" && selfAvatar.path != ""){
          if(await getCardNoAuth() && await getIdCardFrontAuth() && await getIdCardBackAuth()){
            isSuccess = true;
            //发起网络请求，赋予家政员身份
            notifyListeners();
          }else{
            isFail = true;
            notifyListeners();
          }
        }else{
          showToast("照片不能为空");
        }
      } else{
        showToast("信息不能为空");
      }
    }
  }

  void reAuth(){
    isFail = false;
    name = "";
    idCard = "";
    phoneNumber = "";
    notifyListeners();
  }

  Future<bool> getCardNoAuth() async {
    bool result = await IdentityApi.instance.getCardNoAuth(
        cardNo: idCard,
        realName: name
    );

    if(result){
      print("身份证号码验证通过");
      return true;
    }else{
      print("身份证号码验证失败");
      return false;
    }
  }

  Future<bool> getIdCardFrontAuth() async {

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
      return true;
    }else{
      print("身份证正面验证失败");
      return false;
    }
  }

  Future<bool> getIdCardBackAuth() async {

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
      return true;
    }else{
      print("身份证反面验证失败");
      return false;
    }
  }

  bool get isSuccess => _isSuccess;
  set isSuccess(bool value){
    _isSuccess = value;
  }

  bool get isFail => _isFail;
  set isFail(bool value) {
    _isFail = value;
  }

  bool get isIdCorrect => _isIdCorrect;

  set isIdCorrect(bool value) {
    _isIdCorrect = value;
  }

  bool get isPhoneCorrect => _isPhoneCorrect;

  set isPhoneCorrect(bool value) {
    _isPhoneCorrect = value;
  }

  bool get isNameCorrect => _isNameCorrect;

  set isNameCorrect(bool value) {
    _isNameCorrect = value;
  }
}