import 'package:collection/equality.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:jiayuan/repository/api/keeper_api.dart';
import 'package:jiayuan/repository/api/uploadImage_api.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/utils/global.dart';

class PersonalKeeperVm with ChangeNotifier {
  RegExp reg_tel = RegExp(r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
  String? avatarUrl = Global.keeperInfo?.avatar ?? ""; //服务器头像
  String? phoneNumber = Global.keeperInfo?.contact ?? ""; //手机号
  String? city = Global.keeperInfo?.city ?? ""; // 工作城市
  int? workExperience = Global.keeperInfo?.workExperience ?? 0; //工作经验
  String? highlight = Global.keeperInfo?.highlight ?? ""; // 个人优势
  String? introduction = Global.keeperInfo?.introduction! ?? ""; //自我介绍
  List<String>? tags = Global.keeperInfo?.tags ?? []; //工作标签
  List<String> imageUrls = Global.keeperInfo?.keeperImages ?? []; //服务器上的图片

  Map<String, bool> commissionTypeSelected = {
    for (int i = 0; i < 11; i++)
      HomeViewModel.CommissionTypes[i].typeText: false
  };
  Map<String, bool> commissionTypeSelected1 = {
    for (int i = 0; i < 11; i++)
      HomeViewModel.CommissionTypes[i].typeText: false
  };

  //工作城市
  void setCity(String city) {
    this.city = city;
    notifyListeners();
  }

  //个人优势
  void setHighlight(String highlight) {
    this.highlight = highlight;
    notifyListeners();
  }

  //自我介绍
  void updateIntroduction(String introduction) {
    this.introduction = introduction;
    notifyListeners();
  }

  //个人优势
  void updateHighlight(String highlight) {
    this.highlight = highlight;
    notifyListeners();
  }

  // 获取图片
  void getImageUrls(List<String> imageUrls) {
    print("图片地址: $imageUrls");
    this.imageUrls = imageUrls;
  }

  //上传家政员信息，只上传改变的部分
  Future<void> upLoadKeeperInfo() async {
   // List<String> imageUrls2 = imageUrls.forEach((e) => return e);
    HousekeeperDataDetail housekeeperDataDetail = HousekeeperDataDetail(
      avatar: isEqual(avatarUrl, Global.keeperInfo!.avatar) ? null : avatarUrl,
      city: isEqual(city, Global.keeperInfo!.city) ? null : city,
      contact:
          isEqual(phoneNumber, Global.keeperInfo!.contact) ? null : phoneNumber,
      highlight:
          isEqual(highlight, Global.keeperInfo!.highlight) ? null : highlight,
      introduction: isEqual(introduction, Global.keeperInfo!.introduction)
          ? null
          : introduction,
      keeperImages: isListEqual(Global.keeperInfo!.keeperImages, imageUrls)
          ? null
          : imageUrls.map((e)=> e.substring(("http://62.234.165.111:8080/upload/pictures/keeper/work_photo/").length)).toList() ,
      tags: isListEqual(Global.keeperInfo!.tags, tags) ? null : tags,
      workExperience: workExperience == Global.keeperInfo!.workExperience
          ? null
          : workExperience,
    );
    await KeeperApi.instance.updateKeeperInfo(housekeeperDataDetail);
    await KeeperApi.instance.getKeeperDataByUserId();
  }

  bool isListEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null ) return false;
    return ListEquality().equals(list1, list2);
  }

  bool isEqual(String? str1, String? str2) {
    return str1 == str2;
  }

  //保存被选择的委托
  void SaveCommissionTypeSelected() {
    commissionTypeSelected = Map<String, bool>.from(commissionTypeSelected1);
    tags = [];
    commissionTypeSelected.forEach((key, value) {
      if (value == true) {
        tags!.add(key);
      }
      ;
    });
    notifyListeners();
  }

  //更新临时被选择的委托
  void updateCommissionTypeSelected1(String type) {
    //map内部更新，不会触发监听
    final newMap = Map<String, bool>.from(commissionTypeSelected1);
    newMap[type] = !newMap[type]!;
    commissionTypeSelected1 = newMap;
    notifyListeners();
  }

  //删除选择的照片
  Future<void> deleteImage(int? index) async {
    //让服务器删除本地图片
    //  await deleteImage(imageFileUrl[image![index].path]);
    // imageUrl!.remove(index); //删除图片
  }

  // 图库选择头像 并上传
  Future<void> selectAvatarByGallery() async {
    XFile? avatar = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (avatar != null) {
      avatarUrl = await uploadImage(avatar);
      notifyListeners();
    }
  }

  // 相机选择头像 + 上传
  Future<void> selectAvatarByCamera() async {
    XFile? avatar = await ImagePicker().pickImage(source: ImageSource.camera);
    if (avatar != null) {
      avatarUrl = await uploadImage(avatar);
      notifyListeners();
    }
  }

  //上传单张图片 返回图片存储路径
  Future<String> uploadImage(XFile file) async {
    String imageUrl = await UploadImageApi.instance
        .uploadImage(file, UrlPath.keeperAvatarPath);
    print("图片路径: $imageUrl");
    return imageUrl;
  }
}
