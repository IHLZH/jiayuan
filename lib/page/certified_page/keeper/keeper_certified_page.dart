import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/page/certified_page/keeper/keeper_certified_page_vm.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/global.dart';
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

  Future<void> _uploadFromCamera(int id) async {
    final pickedFile = await ImageUtils.getCameraImage();
    if(pickedFile != null){
      setState(() {
        switch(id){
          case 0:
            _keeperViewModel.idCardFront = pickedFile;
            break;
          case 1:
            _keeperViewModel.idCardBack = pickedFile;
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
            _keeperViewModel.idCardBack = pickedFile;
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

  //检验身份证号
  bool _validateIDCard(String idCard) {
    // 正则表达式：前 17 位为数字，最后一位可以为数字或 X
    RegExp idCardRegex = RegExp(r"^[1-9]\d{5}(19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|(3[0-1]))\d{3}(\d|X|x)$");
    return idCardRegex.hasMatch(idCard);
  }

  bool _validateName(String name) {
    // 正则表达式：支持 2-10 个字符的中文或英文字符
    RegExp nameRegex = RegExp(r"^[\u4e00-\u9fa5a-zA-Z]{2,20}$");
    return nameRegex.hasMatch(name);
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
                              getColor(),      // 渐变结束颜色
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
                                  vm.back(context);
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
                body: _KeeperPage()
              );
            }
        ),
    );
  }

  Color getColor(){
    if(_keeperViewModel.isSuccess || (Global.userInfo?.userType ?? 0) == 1 || _keeperViewModel.isFail){
      return Colors.white;
    }else return AppColors.backgroundColor3;
  }

  Widget _KeeperPage(){
    if(_keeperViewModel.isSuccess || (Global.userInfo?.userType ?? 0) == 1){
      return _Success();
    }else if(_keeperViewModel.isFail){
      return _Fail();
    }else if(_keeperViewModel.cardImgWay || _keeperViewModel.cardNoWay){
      return _AuthResult();
    }else {
      return _AuthWay();
    }
  }

  Widget _AuthWay(){
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor3
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "选择认证方式",
                  style: TextStyle(
                      color: AppColors.textColor2b,
                      fontSize: 18.sp,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 120.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "身份证号码认证",
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 16.sp
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.textColor2b,
                        )
                      ],
                    ),
                    onTap: (){
                      _keeperViewModel.toCardNo();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "身份证正反面认证",
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 16.sp
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.textColor2b,
                        )
                      ],
                    ),
                    onTap: (){
                      _keeperViewModel.toCardImg();
                    },
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }

  Widget _AuthResult(){
    return _keeperViewModel.cardNoWay
        ? Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color : AppColors.backgroundColor3
        ),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r)
              ),
              child: Column(
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
                                    _keeperViewModel.name = name;
                                    _keeperViewModel.isNameCorrect = _validateName(name);
                                  });
                                }else{
                                  setState(() {
                                    _keeperViewModel.isNameCorrect = true;
                                  });
                                }
                              },
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: _keeperViewModel.isNameCorrect ? null : Text(
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
                                    _keeperViewModel.idCard = id;
                                    _keeperViewModel.isIdCorrect = _validateIDCard(id);
                                  });
                                }else{
                                  setState(() {
                                    _keeperViewModel.isIdCorrect = true;
                                  });
                                }
                              },
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: _keeperViewModel.isIdCorrect ? null : Text(
                      "(请填写真实的身份证号)",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h,),

                  AppButton(
                    type: AppButtonType.main,
                    radius: 8.r,
                    buttonText: "认证完成>",
                    onTap: (){
                      _keeperViewModel.authenticated();
                    },
                  )
                ],
              ),
            )
          ],
        )
    )
        : Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor3
        ),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                              image: _keeperViewModel.idCardFront.path != "" ? FileImage(File(_keeperViewModel.idCardFront.path)) : AssetImage('assets/images/upload2.jpg')
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _showPickerOptions(context, 1);
                          },
                          child: Image(
                              width: 150.w,
                              height: 90.w,
                              image: _keeperViewModel.idCardBack.path != "" ? FileImage(File(_keeperViewModel.idCardBack.path)) : AssetImage('assets/images/upload2.jpg')
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h,),

                  AppButton(
                    type: AppButtonType.main,
                    radius: 8.r,
                    buttonText: "认证完成>",
                    onTap: (){
                      _keeperViewModel.authenticated();
                    },
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _Success(){
    return Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                height: 200.h,
                width: 200.w,
                "assets/images/auth_success.png",
              ),
              Text(
                "认证成功",
                style: TextStyle(
                    fontSize: 25.sp
                ),
              ),
              SizedBox(height: 20.h,),
              AppButton(
                onTap: (){
                  RouteUtils.pushReplacementNamed(context, RoutePath.commissionCenter);
                },
                type: AppButtonType.main,
                radius: 8.r,
                buttonText: "前往委托中心>",
              )
            ],
          ),
        )
    );
  }

  Widget _Fail(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              height: 200.h,
              width: 200.w,
              "assets/images/auth_fail.png",
            ),
            Text(
              "认证失败",
              style: TextStyle(
                  fontSize: 25.sp
              ),
            ),
            SizedBox(height: 20.h,),
            AppButton(
              onTap: (){
                _keeperViewModel.reAuth();
              },
              type: AppButtonType.main,
              radius: 8.r,
              buttonText: "重新认证>",
            )
          ],
        ),
      )
    );
  }
}
