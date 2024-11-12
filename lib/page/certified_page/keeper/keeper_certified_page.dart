import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/page/certified_page/keeper/keeper_certified_page_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';
import '../../../utils/image_utils.dart';
/*
家政员认证页面
 */
class KeeperCertifiedPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _KeeperCertifiedPageState();
  }
}

class _KeeperCertifiedPageState extends State<KeeperCertifiedPage>{
  KeeperCertifiedPageViewModel _keeperViewModel = KeeperCertifiedPageViewModel();
  // 请求权限
  Future<bool> _requestPermissions() async {
    final statusCamera = await Permission.photos.request();
    //final statusStorage = await Permission.storage.request();

    // if (statusCamera.isGranted) {
    //   return true;
    // } else {
    //   return false;
    // }

    return true;
  }

  Future<void> _uploadFromCamera(int id) async {
    final pickedFile = await ImageUtils.getCameraImage();
    if(pickedFile != null){
      setState(() {
        switch(id){
          case 0:
            _keeperViewModel.idCardFront = pickedFile;
            break;
          case 1:
            _keeperViewModel.idCardOther = pickedFile;
            break;
          case 2:
            _keeperViewModel.selfAvatar = pickedFile;
            break;
        }

      });
    }
  }

  Future<void> _uploadFromGallery(int id) async {
    final pickedFile = await ImageUtils.getImage();
    if(pickedFile != null){
      setState(() {
        switch(id){
          case 0:
            _keeperViewModel.idCardFront = pickedFile;
            break;
          case 1:
            _keeperViewModel.idCardOther = pickedFile;
            break;
          case 2:
            _keeperViewModel.selfAvatar = pickedFile;
            break;
        }

      });
    }
  }

  void _showPickerOptions(BuildContext context, int id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("从相册选择"),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadFromGallery(id);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("使用相机拍照"),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadFromCamera(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool isNameCorrect = true;
  bool isIdCorrect = true;
  bool isPhoneCorrect = true;

  //检验身份证号
  bool _validateIDCard(String idCard) {
    // 正则表达式：前 17 位为数字，最后一位可以为数字或 X
    RegExp idCardRegex = RegExp(r"^[1-9]\d{5}(19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|(3[0-1]))\d{3}(\d|X|x)$");
    return idCardRegex.hasMatch(idCard);
  }

  //检验电话号码
  bool _validatePhoneNumber(String phoneNumber) {
    // 正则表达式：以 13-19 的数字开头，后接 9 位数字
    RegExp phoneRegex = RegExp(r"^(13|14|15|16|17|18|19)\d{9}$");
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool _validateName(String name) {
    // 正则表达式：支持 2-10 个字符的中文或英文字符
    RegExp nameRegex = RegExp(r"^[\u4e00-\u9fa5a-zA-Z]{2,20}$");
    return nameRegex.hasMatch(name);
  }

  void _authenticated(){
    if(isNameCorrect && isIdCorrect && isPhoneCorrect){
      if(_keeperViewModel.name != "" && _keeperViewModel.idCard != "" && _keeperViewModel.phoneNumber != ""){
        if(_keeperViewModel.idCardFront != null && _keeperViewModel.idCardOther != null && _keeperViewModel.selfAvatar != null){
          //发送网络请求
        }else{
          showToast("照片不能为空");
        }
      } else{
        showToast("信息不能为空");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _keeperViewModel;
        },
        child: Consumer<KeeperCertifiedPageViewModel>(
            builder: (context, vm, child){
              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.appColor, // 渐变起始颜色
                              Colors.white,      // 渐变结束颜色
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Container(
                          height: 250.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  RouteUtils.pop(context);
                                },
                              ),
                              Text(
                                "身份认证",
                                style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        )
                    )
                ),
                body: Container(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "一, 请填写真实的身份信息",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "姓名：",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                  Expanded(
                                      child: AppInput(
                                        hintText: "请输入真实姓名",
                                        onChanged: (name){
                                          if(name != ""){
                                            setState(() {
                                              vm.name = name;
                                              isNameCorrect = _validateName(name);
                                            });
                                          }else{
                                            setState(() {
                                              isNameCorrect = true;
                                            });
                                          }
                                        },
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: isNameCorrect ? null : Text(
                                "(请填写真实的姓名信息)",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.red
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "身份证号：",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                  Expanded(
                                      child: AppInput(
                                        hintText: "请输入正确的身份证号",
                                        onChanged: (id){
                                          if(id != ""){
                                            setState(() {
                                              vm.idCard = id;
                                              isIdCorrect = _validateIDCard(id);
                                            });
                                          }else{
                                            setState(() {
                                              isIdCorrect = true;
                                            });
                                          }
                                        },
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: isIdCorrect ? null : Text(
                                "(请填写真实的身份证号)",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.red
                                ),
                              ),
                            ),

                            SizedBox(height: 40.h,),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "二, 核对身份(上传身份证照片)",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(16.r)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _showPickerOptions(context, 0);
                                    },
                                    child: Image(
                                        width: 150.w,
                                        height: 90.w,
                                        image: vm.idCardFront != null ? FileImage(File(vm.idCardFront!.path)) : AssetImage('assets/images/upload2.jpg')
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _showPickerOptions(context, 1);
                                    },
                                    child: Image(
                                        width: 150.w,
                                        height: 90.w,
                                        image: vm.idCardOther != null ? FileImage(File(vm.idCardOther!.path)) : AssetImage('assets/images/upload2.jpg')
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 40.h,),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "三, 上传个人照片及联系方式",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    _showPickerOptions(context, 2);
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: vm.selfAvatar != null ? FileImage(File(vm.selfAvatar!.path)) : null,
                                    child: vm.selfAvatar == null ? Icon(Icons.person, size: 50,) : null,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "联系方式：",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.textColor2b
                                    ),
                                  ),
                                  Expanded(
                                      child: AppInput(
                                        hintText: "请输入电话号码(+86)",
                                        onChanged: (phone){
                                          if(phone != ""){
                                            setState(() {
                                              vm.phoneNumber = phone;
                                              isPhoneCorrect = _validatePhoneNumber(phone);
                                            });
                                          }else{
                                            setState(() {
                                              isPhoneCorrect = true;
                                            });
                                          }
                                        },
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: isPhoneCorrect ? null : Text(
                                "(请填写正确的电话号码)",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.red
                                ),
                              ),
                            ),

                            SizedBox(height: 40.h,),

                            AppButton(
                              type: AppButtonType.main,
                              buttonText: "认证完成>",
                              onTap: (){
                                _authenticated();
                              },
                            )
                          ],
                        )
                      ],
                    )
                )
              );
            }
        ),
    );
  }
}
