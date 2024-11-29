import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';
import '../../../utils/image_utils.dart';
import 'cert_certified_page_vm.dart';

/*
证书认证页面
 */
class CertCertifiedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CertCertifiedPageState();
  }
}

class _CertCertifiedPageState extends State<CertCertifiedPage> {
  CertCertifiedPageViewModel _certViewModel = CertCertifiedPageViewModel();
  TextEditingController _certTextController = TextEditingController();

  @override
  void initState() {
    _certViewModel.getAllCertificates();
    super.initState();
  }

  Future<void> _uploadFromCamera() async {
    final pickedFile = await ImageUtils.getCameraImage();
    if (pickedFile != null) {
      setState(() {
        _certViewModel.certImage = pickedFile;
      });
    }
  }

  Future<void> _uploadFromGallery() async {
    final pickedFile = await ImageUtils.getImage();
    if (pickedFile != null) {
      setState(() {
        _certViewModel.certImage = pickedFile;
      });
    }
  }

  void _showPickerOptions(BuildContext context) {
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
                  _uploadFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("使用相机拍照"),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _authenticated() {
    _certViewModel.certName = _certTextController.text;
    if (_certViewModel.certImage != null &&
        _certViewModel.certName != null &&
        _certViewModel.certName != "") {
      //发起网络请求
      _certViewModel.addCertificate();
    } else {
      showToast("信息不能为空");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return _certViewModel;
      },
      child:
          Consumer<CertCertifiedPageViewModel>(builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.appColor, // 渐变起始颜色
                        Colors.white, // 渐变结束颜色
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
                          "证书认证",
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: Icon(Icons.info_outline),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ))),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "证书名称",
                          style: TextStyle(
                              color: AppColors.textColor2b, fontSize: 18.sp),
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          child: AppInput(
                            controller: _certTextController,
                          )),
                      SizedBox(
                        height: 40.w,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "上传证书照片",
                          style: TextStyle(
                              color: AppColors.textColor2b, fontSize: 18.sp),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(16.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showPickerOptions(context);
                              },
                              child: Image(
                                  width: 150.w,
                                  height: 90.w,
                                  image: vm.certImage != null
                                      ? FileImage(File(vm.certImage!.path))
                                      : AssetImage(
                                          'assets/images/upload2.jpg')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.w,
                      ),
                      Container(
                        child: AppButton(
                          type: AppButtonType.main,
                          buttonText: "提交审核",
                          buttonWidth: 200.w,
                          radius: 8.r,
                          onTap: () {
                            _authenticated();
                          },
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vm.certificates?.length,
                  itemBuilder: (context, index) {
                    final certificate = vm.certificates?[index];
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(certificate!.certName ?? '',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              Spacer(),
                              switch (certificate.status) {
                                0 => Text(
                                    '待审核',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                1 => Text('已通过',
                                    style: TextStyle(color: Colors.red)),
                                2 => Text('未通过',
                                    style: TextStyle(color: Colors.red)),
                                _ => Text('已删除',
                                    style: TextStyle(color: Colors.red)),
                              }
                            ],
                          ),
                          const SizedBox(height: 10),
                          //图片
                          certificate.imageUrl != null
                              ? Stack(
                                  children: [
                                    Image.network(
                                      certificate.imageUrl!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Image.asset(
                                          switch (certificate.status) {
                                            0 =>
                                              'assets/images/ToBeReviewed.png',
                                            1 => 'assets/images/reviewed.png',
                                            2 => 'assets/images/approved.png',
                                            _ => 'assets/images/delete.png'
                                          },
                                          color: Colors.red,
                                          width: 60,
                                          height: 60,
                                        ))
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
