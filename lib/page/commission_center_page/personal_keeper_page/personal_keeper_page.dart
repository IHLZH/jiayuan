import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/MultiImageUpLoad/MultiImageUpLoad.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/page/commission_center_page/personal_keeper_page/personal_keeper_vm.dart';
import 'package:jiayuan/page/home_page/home_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../utils/global.dart';

class PersonalKeeperPage extends StatefulWidget {
  const PersonalKeeperPage({super.key});

  @override
  State<PersonalKeeperPage> createState() => _PersonalKeeperPageState();
}

class _PersonalKeeperPageState extends State<PersonalKeeperPage> {
  FocusNode _focusNodePhone = FocusNode();
  TextEditingController _phoneController = TextEditingController();
  PersonalKeeperVm _personalKeeperVm = PersonalKeeperVm();
  TextEditingController _introductionController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _skillsController.text = _personalKeeperVm.highlight!;
    _introductionController.text = _personalKeeperVm.introduction!;
    for(int i = 0 ; i < Global.keeperInfo!.tags!.length; i++){
      _personalKeeperVm.commissionTypeSelected[Global.keeperInfo!.tags![i]] = true;
    }
  }

  void dispose() {
    _personalKeeperVm.phoneNumber = _phoneController.text;
    _personalKeeperVm.upLoadKeeperInfo();
    _focusNodePhone.dispose();
    _introductionController.dispose();
    _skillsController.dispose();
    super.dispose();
    // 销毁时，移除监听
  }

  // 通过钩子事件, 主动唤起浮层.
  Future<Result?> getResult() async {
    // type 3
    Result? result = await CityPickers.showCitiesSelector(
      context: context,
      appBarBuilder: (context) {
        return AppBar(
          title: Text('选择服务城市'),
          backgroundColor: Color.fromRGBO(70, 219, 201, 1),
          // 其他配置
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PersonalKeeperVm>(
      create: (context) => _personalKeeperVm,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor2,
        body: TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: AppColors.appColor,
              selectionHandleColor: AppColors.appColor,
              cursorColor: AppColors.appColor,
            ),
            child: Stack(
              children: [
                Container(
                  height: 230.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(148, 251, 195, 1),
                    //70, 219, 201
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                        AppColors.backgroundColor2, // 渐变结束颜色
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 56.h,
                  left: 0,
                  right: 210.h,
                  child: Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: const DecorationImage(
                            image: AssetImage(
                                "assets/images/drawkit-grape-pack-illustration-18.png"),
                            opacity: 1,
                            fit: BoxFit.contain),
                      )),
                ),
                Positioned(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        title: Text(
                          '我的简历',
                          style:
                              TextStyle(color: Colors.black, fontSize: 18.sp),
                        ),
                        centerTitle: true,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //头像
                            _buildAvatarInfo(),
                            //联系方式
                            _buildPhoneNumber(),
                            //城市选择器
                            _buildCitySelector(),
                            //工作经验 + 技能 / 擅长
                            _buildWorkExperienceWithSkills(),
                            //自我描述 + 工作标签 + 工作照片
                            _buildIntroductionAndTagsWithImages(),
                          ],
                        ),
                      ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildAvatarInfo() {
    return Selector<PersonalKeeperVm, String?>(
        selector: (context, vm) => vm.avatarUrl,
        builder: (context, avatarUrl, child) => Container(
              margin: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: Colors.white),
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.w)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '头像',
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '真实头像更容易提升接单的成功率',
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showPickerOptions();
                    },
                    child: CircleAvatar(
                      radius: 40.w,
                      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                          ? CachedNetworkImageProvider(avatarUrl)
                          : AssetImage(
                              'assets/images/drawkit-grape-pack-illustration-18.png'),
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _buildPhoneNumber() {
    _phoneController.text = _personalKeeperVm.phoneNumber!;
    return CommonContainer(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          children: [
            Text('联系方式', style: TextStyle(fontSize: 16, color: Colors.black)),
            Spacer(),
            Icon(Icons.phone, color: AppColors.appColor),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: _phoneController,
                focusNode: _focusNodePhone,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                onTapOutside: (e) {
                  _focusNodePhone.unfocus();
                  if (!_personalKeeperVm.reg_tel.hasMatch(_phoneController.text))
                  {
                    showToast('手机号格式不正确');
                  };
                  //校验手机格式
                },
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "请输入手机号",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        )
      ]),
    );
  }

  Widget _buildIntroductionAndTagsWithImages() {
    return Selector<PersonalKeeperVm,
            ({String? introduction, List<String>? tags})>(
        selector: (context, vm) =>
            (introduction: vm.introduction, tags: vm.tags),
        builder: (context, data, child) {
          return CommonContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    showTagsBottomSheet();
                  },
                  child: _buildWorkTag(),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                    onTap: () {
                      showIntroductionBottomSheet();
                    },
                    child: _buildIntroduction()),
                InkWell(
                  onTap: () {},
                  child: _buildImages(),
                )
              ],
            ),
          );
        });
  }

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('工作照片', style: TextStyle(fontSize: 15, color: Colors.black)),
        MultiImageUploadWidget(
          onImageSelected: _personalKeeperVm.getImageUrls,
          addUrlPath: UrlPath.uploadWorkPicture,
          deleteUrlPath: UrlPath.deleteWorkPicture,
          queryParameters: {"userId": Global.userInfo?.userId},
          initialImageUrls: _personalKeeperVm.imageUrls ,
        )
        // MultiImageUploadWidget(onImageSelected: _personalKeeperVm.getImageUrls,addUrlPath: UrlPath.uploadEvaluationPicture,deleteUrlPath: UrlPath.deleteEvaluationPicture,queryParameters:{"userId":Global.userInfo?.userId}),
      ],
    );
  }

  Widget _buildIntroduction() {
    return Column(
      children: [
        Row(
          children: [
            Text('自我介绍',
                style: TextStyle(fontSize: 15.sp, color: Colors.black)),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.grey,
              size: 15,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              '${_personalKeeperVm.introduction}',
              style: TextStyle(color: Colors.grey),
            ))
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildWorkTag() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text('工作标签',
                style: TextStyle(fontSize: 15.sp, color: Colors.black)),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.grey,
              size: 15,
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Wrap(
          children: List.generate(
            _personalKeeperVm.tags!.length,
            (index) {
              return Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                width: 65,
                height: 30,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(70, 219, 201, 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    '${_personalKeeperVm.tags![index]}',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildWorkExperienceWithSkills() {
    return Selector<PersonalKeeperVm,
            ({String? highlight, int? workExperience})>(
        selector: (context, vm) =>
            (highlight: vm.highlight, workExperience: vm.workExperience),
        builder: (context, data, child) {
          return CommonContainer(
            child: Column(
              children: [
                _buildWorkExperience(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                SizedBox(
                  height: 5,
                ),
                _buildHighlight()
              ],
            ),
          );
        });
  }

  Widget _buildWorkExperience() {
    String initData = _personalKeeperVm.workExperience == null
        ? '1年'
        : '${_personalKeeperVm.workExperience}年';
    return InkWell(
      onTap: () {
        Pickers.showSinglePicker(
          context,
          data: List.generate(10, (index) => '${index + 1}年'),
          selectData: _personalKeeperVm.workExperience == null
              ? '5年'
              : '${_personalKeeperVm.workExperience}年',
          onConfirm: (data, position) {
            setState(() {
              _personalKeeperVm.workExperience = position + 1;
            });
          },
        );
      },
      child: Container(
        child: Row(
          children: [
            Text(
              '工作经验',
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
            Spacer(),
            Text(
              _personalKeeperVm.workExperience == null
                  ? ''
                  : '${_personalKeeperVm.workExperience}年',
              style: TextStyle(fontSize: 15.sp, color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.grey,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHighlight() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showSkillsBottomSheet();
          },
          child: Column(
            children: [
              Row(
                children: [
                  Text('个人亮点',
                      style: TextStyle(fontSize: 15.sp, color: Colors.black)),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.grey,
                    size: 15,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${_personalKeeperVm.highlight}',
                    style: TextStyle(color: Colors.grey),
                  ))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCitySelector() {
    return Selector<PersonalKeeperVm, String?>(
        selector: (context, vm) => vm.city,
        builder: (context, data, child) => GestureDetector(
              onTap: () async {
                Result? result = await getResult();
                if (result != null) {
                  _personalKeeperVm.setCity(result.cityName!);
                }
              },
              child: CommonContainer(
                child: Row(
                  children: [
                    Text('服务城市',
                        style: TextStyle(fontSize: 15.sp, color: Colors.black)),
                    Spacer(),
                    Text(
                      _personalKeeperVm.city ?? '',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.grey,
                      size: 14,
                    )
                  ],
                ),
              ),
            ));
  }

  void showSkillsBottomSheet() {
    _skillsController.text = _personalKeeperVm.highlight ?? "";
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      //禁止拖动关闭
      isDismissible: false,
      builder: (context) {
        return TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: AppColors.appColor,
            selectionHandleColor: AppColors.appColor,
            cursorColor: AppColors.appColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // 动态适配键盘高度
              ),
              child: Container(
                height: 250,
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '个人亮点',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                        controller: _skillsController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "✎ 填写个人亮点/ 如：1年经验，擅长做菜",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        maxLength: 20,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _personalKeeperVm.setHighlight(_skillsController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(70, 219, 201, 1),
                                AppColors.appColor,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '保存',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showIntroductionBottomSheet() {
    _introductionController.text = _personalKeeperVm.introduction ?? "";
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      //禁止拖动关闭
      isDismissible: false,
      builder: (context) {
        return TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: AppColors.appColor,
            selectionHandleColor: AppColors.appColor,
            cursorColor: AppColors.appColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // 动态适配键盘高度
              ),
              child: Container(
                height: 250,
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '自我介绍',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                        controller: _introductionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "✎ 呼起键盘,给自己来个介绍吧",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        maxLength: 200,
                        maxLines: 5,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        _personalKeeperVm
                            .updateIntroduction(_introductionController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(70, 219, 201, 1),
                                AppColors.appColor,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '保存',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPickerOptions() {
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
                  _personalKeeperVm.selectAvatarByGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("使用相机拍照"),
                onTap: () {
                  Navigator.of(context).pop();
                  _personalKeeperVm.selectAvatarByCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showTagsBottomSheet() {
    //不可以进行引用赋值
    //_personalKeeperVm.commissionTypeSelected1 = _personalKeeperVm.commissionTypeSelected;
    _personalKeeperVm.commissionTypeSelected1 =
        Map<String, bool>.from(_personalKeeperVm.commissionTypeSelected);
    showModalBottomSheet(
        isScrollControlled: true, //可滚动 解除showModalBottomSheet最大显示屏幕一半的限制
        context: context,
        isDismissible: false,
        //禁止拖动关闭
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: _personalKeeperVm,
            child: Selector<PersonalKeeperVm, Map<String, bool>>(
                selector: (context, personalKeeperVm) =>
                    personalKeeperVm.commissionTypeSelected1,
                builder: (context, commissionTypeSelected1, child) => Container(
                      height: 360,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '工作标签',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 20.sp,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '短期',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 10),
                                GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 6,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.h,
                                      mainAxisSpacing: 10.h,
                                      childAspectRatio: 3,
                                    ),
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            _personalKeeperVm
                                                .updateCommissionTypeSelected1(
                                                    HomeViewModel
                                                        .CommissionTypes[index]
                                                        .typeText);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: commissionTypeSelected1[
                                                        HomeViewModel
                                                            .CommissionTypes[
                                                                index]
                                                            .typeText]!
                                                    ? Color.fromRGBO(
                                                        70, 219, 201, 1)
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                  '${HomeViewModel.CommissionTypes[index].typeText}',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        )),
                                Text(
                                  '长期',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 10),
                                GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.h,
                                      mainAxisSpacing: 10.h,
                                      childAspectRatio: 3,
                                    ),
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            _personalKeeperVm
                                                .updateCommissionTypeSelected1(
                                                    HomeViewModel
                                                        .CommissionTypes[
                                                            index + 6]
                                                        .typeText);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: commissionTypeSelected1[
                                                        HomeViewModel
                                                            .CommissionTypes[
                                                                index + 6]
                                                            .typeText]!
                                                    ? Color.fromRGBO(
                                                        70, 219, 201, 1)
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                '${HomeViewModel.CommissionTypes[index + 6].typeText}',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ))
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _personalKeeperVm.SaveCommissionTypeSelected();
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(70, 219, 201, 1),
                                      AppColors.appColor,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '保存',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
          );
        });
  }

  Widget CommonContainer({required Widget child}) {
    return Container(
        margin:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: Offset(1, 2),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10.w)),
        child: child);
  }
}
