import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/page/chat_page/group_info/group_info_page_vm.dart';
import 'package:jiayuan/repository/api/group_api.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/dialog/dialog_factory.dart';
import '../../../common_ui/input/app_input.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';
import '../../../utils/image_utils.dart';

class GroupInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GroupInfoPageState();
  }
}

class _GroupInfoPageState extends State<GroupInfoPage>{

  GroupInfoPageViewModel _groupVm = GroupInfoPageViewModel.instance;

  @override
  void initState() {
    super.initState();
    _initGroupMember();
    print("初始化结束");
  }


  @override
  void dispose() {
    super.dispose();
    _groupVm.clear();
  }

  Future<void> _initGroupMember() async {
    await _groupVm.getGroupMember();
    print("群主id为：${_groupVm.groupInfo!.owner}");
  }

  Future<void> _uploadFromCamera() async {
    await _groupVm.uploadFromCamera();
  }

  Future<void> _uploadFromGallery() async {
    await _groupVm.uploadFromGallery();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _groupVm,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor3,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          RouteUtils.pop(context, result: _groupVm.isChange);
                        },
                      ),
                      Expanded(
                        child: Text(
                          "群聊设置",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      //透明图标
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.transparent,
                        ),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                )
            )
        ),
        body: Consumer<GroupInfoPageViewModel>(
            builder: (context, vm, child){
              return Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColors.backgroundColor3
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: InkWell(
                              onTap: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: AppColors.backgroundColor3,
                                          backgroundImage: vm.groupInfo!.faceUrl != "默认头像" ? CachedNetworkImageProvider(vm.groupInfo!.faceUrl!) : null
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        vm.groupInfo?.groupName ?? "未命名群聊",
                                        style: TextStyle(
                                            color: AppColors.textColor2b,
                                            fontSize: 16.sp
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: AppColors.textColor2b,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "群聊成员",
                                      style: TextStyle(
                                          color: AppColors.textColor2b,
                                          fontSize: 16.sp
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await _groupVm.getFriendList();
                                        RouteUtils.pushForNamed(context, RoutePath.inviteFriend);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                            color: Colors.grey,),
                                          Text(
                                            "邀请成员",
                                            style: TextStyle(
                                                color: Colors.grey
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        crossAxisSpacing: 5,
                                        childAspectRatio: 0.9
                                        //mainAxisSpacing: 5,
                                      ),
                                      itemCount: vm.groupMember.length,
                                      itemBuilder: (context, index){
                                        return InkWell(
                                          onTap: (){
                                            vm.gotoUserInfo(context, vm.groupMember[index]!.userID);
                                          },
                                          child: Container(
                                            //padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: AppColors.backgroundColor3,
                                                    backgroundImage:
                                                    vm.groupMember[index] != null
                                                        ? vm.groupMember[index]!.faceUrl != null ? CachedNetworkImageProvider(vm.groupMember[index]!.faceUrl!) : null
                                                        : null
                                                ),
                                                Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  vm.groupMember[index]!.friendRemark != "" ? vm.groupMember[index]!.friendRemark!: vm.groupMember[index]!.nickName!,
                                                  style: TextStyle(
                                                      color: AppColors.textColor2b,
                                                      fontSize: 12.sp
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                )
                              ],
                            )
                          ),

                          SizedBox(height: 10,),

                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "群聊信息",
                              style: TextStyle(
                                  color: AppColors.textColor7d,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    showChangeGroupName();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "群名称",
                                            style: TextStyle(
                                                color: AppColors.textColor2b,
                                                fontSize: 16.sp
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            vm.groupInfo?.groupName ?? "",
                                            style: TextStyle(
                                                color: AppColors.textColor7d,
                                                fontSize: 14.sp
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: AppColors.textColor7d,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 1,
                                  color: AppColors.backgroundColor6,
                                ),
                                SizedBox(height: 10,),
                                InkWell(
                                  onTap: (){
                                    showChangeGroupAvatar();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "群头像",
                                            style: TextStyle(
                                                color: AppColors.textColor2b,
                                                fontSize: 16.sp
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: AppColors.backgroundColor3,
                                            backgroundImage: vm.groupInfo!.faceUrl != null ? CachedNetworkImageProvider(vm.groupInfo!.faceUrl!) : null,
                                          ),
                                          SizedBox(width: 5,),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: AppColors.textColor7d,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),

                          SizedBox(height: 20,),


                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: InkWell(
                              onTap: (){
                                if(Global.userInfo!.userId.toString() == vm.groupInfo!.owner){

                                }else{
                                  showQuitGroup();
                                }
                              },
                              child: Center(
                                child: Text(
                                  (Global.userInfo!.userId.toString() == vm.groupInfo!.owner) ? "解散群聊" : "退出群聊",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16.sp
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  )
              );
            }
        ),
      ),
    );
  }

  void showQuitGroup(){
    DialogFactory.instance.showParentDialog(
        touchOutsideDismiss: true,
        context: context,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r)
          ),
          width: 200,
          height: 180,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "退出群聊",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  children: [
                    Text(
                      "确认退出群聊，退群信息仅管理员与群主可见",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textColor7d
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: (){
                        RouteUtils.pop(context);
                      },
                      type: AppButtonType.minor,
                      radius: 8.r,
                      buttonText: "取消",
                      buttonTextStyle: TextStyle(
                          color: AppColors.textColor2b
                      ),
                    ),
                  ),
                  Expanded(
                      child: AppButton(
                        onTap: () async {
                          bool res = await _groupVm.quitGroup();
                          RouteUtils.pop(context);
                          if(res)RouteUtils.pop(context);
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "退群",
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void showChangeGroupName(){
    DialogFactory.instance.showParentDialog(
        touchOutsideDismiss: true,
        context: context,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r)
          ),
          width: 200,
          height: 180,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "修改群聊名称",
                    style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Expanded(
                    child: AppInput(
                      controller: _groupVm.groupNameController,
                    )
                )
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: (){
                        RouteUtils.pop(context);
                      },
                      type: AppButtonType.minor,
                      radius: 8.r,
                      buttonText: "取消",
                      buttonTextStyle: TextStyle(
                          color: AppColors.textColor2b
                      ),
                    ),
                  ),
                  Expanded(
                      child: AppButton(
                        onTap: () async {
                          bool result = await _groupVm.changeGroupName();
                          if(result){
                            RouteUtils.pop(context);
                            showToast("修改成功");
                          }else{
                            RouteUtils.pop(context);
                            showToast("修改失败");
                          }
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "修改",
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void showChangeGroupAvatar(){
    DialogFactory.instance.showParentDialog(
        touchOutsideDismiss: true,
        context: context,
        child: ChangeNotifierProvider.value(
            value: _groupVm,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r)
            ),
            width: 200,
            height: 180,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "修改群聊头像",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Selector<GroupInfoPageViewModel, XFile?>(
                    selector: (context, vm) => vm.changingGroupAvatar,
                    builder: (context, groupAvatar, child){
                      return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: (){
                              _showPickerOptions(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.backgroundColor3,
                              backgroundImage: groupAvatar != null ? FileImage(File(groupAvatar.path)) :
                              _groupVm.groupInfo!.faceUrl != null ? CachedNetworkImageProvider(_groupVm.groupInfo!.faceUrl!) : null,
                            ),
                          )
                      );
                    }
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onTap: (){
                          RouteUtils.pop(context);
                        },
                        type: AppButtonType.minor,
                        radius: 8.r,
                        buttonText: "取消",
                        buttonTextStyle: TextStyle(
                            color: AppColors.textColor2b
                        ),
                      ),
                    ),
                    Expanded(
                        child: AppButton(
                          onTap: () async {
                            if(_groupVm.changingGroupAvatar != null){
                              bool result = await _groupVm.changeGroupAvatar();
                              if(result){
                                RouteUtils.pop(context);
                                showToast("修改成功");
                              }else{
                                RouteUtils.pop(context);
                                showToast("修改失败");
                              }
                            }else{
                              RouteUtils.pop(context);
                            }
                          },
                          type: AppButtonType.main,
                          radius: 8.r,
                          buttonText: "修改",
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}