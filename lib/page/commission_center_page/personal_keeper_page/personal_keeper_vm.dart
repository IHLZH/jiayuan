import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:jiayuan/repository/api/uploadImage_api.dart';

class PersonalKeeperVm with ChangeNotifier {
  String? avatarUrl; //服务器头像
  String? phoneNumber; //手机号
  String? city; // 工作城市
  int? workExperience; //工作经验
  String highlight = ""; // 个人优势
  String introduction = ""; //自我介绍
  List<String> tags = []; //工作标签
  List<String>? imageUrls; //服务器上的图片

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
    this.imageUrls = imageUrls;
  }

  //保存被选择的委托
  void SaveCommissionTypeSelected() {
    commissionTypeSelected = Map<String, bool>.from(commissionTypeSelected1);
    tags = [];
    commissionTypeSelected.forEach((key, value) {
      if (value == true) {
        tags.add(key);
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
      // avatarUrl = await uploadImage(avatar);
      await uploadImage(avatar);
      notifyListeners();
    }
  }

  // 相机选择头像 + 上传
  Future<void> selectAvatarByCamera() async {
    XFile? avatar = await ImagePicker().pickImage(source: ImageSource.camera);
    if (avatar != null) {
      await uploadImage(avatar);
      // avatarUrl = await uploadImage(avatar);
      notifyListeners();
    }
  }

  //上传单张图片 返回图片存储路径
  Future<String> uploadImage(XFile file) async {
    String imageUrl = await UploadImageApi.instance.uploadImage(file);
    print("图片路径: $imageUrl");
    return imageUrl;
  }

  //上传多张图片  采用并发上传的方式进行上传  返回存储路径
  Future<List<String>> uploadMultipleImages(List<XFile> files) async {
    List<String> imageUrls =
        await UploadImageApi.instance.uploadMultipleImages(files); // 等待所有任务完成
    return imageUrls;
  }
}
