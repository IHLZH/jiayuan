import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';

class PersonalKeeperVm with ChangeNotifier {
  XFile ? avatar; //本地头像
  String? avatarUrl; //服务器头像
  String? phoneNumber; //手机号
  String? city; // 工作城市
  String? address; //地址
  int ? workExperience ; //工作经验
  String highlight = ""; // 个人优势
  String introduction = ""; //自我介绍
  List<String> tags = []; //工作标签
  List<XFile>? image; //个人工作照片
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

  //更新地址
  void updateAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  //保存被选择的委托
  void SaveCommissionTypeSelected() {
    commissionTypeSelected = Map<String, bool>.from(commissionTypeSelected1);
    tags = [];
    commissionTypeSelected.forEach((key, value) {
      if (value == true) {
        tags.add(key);
      };
    });
    notifyListeners();
  }

  //更新临时被选择的委托
  void updateCommissionTypeSelected1(String type) {
    //map内部更新，不会触发监听
    final newMap =  Map<String, bool>.from(commissionTypeSelected1);
    newMap[type] = !newMap[type]!;
     commissionTypeSelected1 = newMap;
      notifyListeners();
  }

  //更新被选择的照片
  void updateImage(List<XFile>? image) {
    this.image = image;
  }
 // 图库选择头像
  Future <void> selectAvatarByGallery(){
    return ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      avatar = value;
      notifyListeners();
    });
  }
  // 相机选择头像
  Future <void> selectAvatarByCamera(){
    return ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      avatar = value;
      notifyListeners();
    });
  }
}
