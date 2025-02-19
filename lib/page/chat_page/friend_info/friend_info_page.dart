import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/dialog/loading.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/page/chat_page/friend_info/friend_info_page_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/dialog/dialog_factory.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../repository/api/user_api.dart';
import '../../../route/route_utils.dart';

class FriendInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FriendInfoPageState();
  }
}

class _FriendInfoPageState extends State<FriendInfoPage>{

  FriendInfoPageViewModel _friendInfoVM = FriendInfoPageViewModel.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkIsFriend() async {
    await _friendInfoVM.checkIsFriend();
  }

  @override
  void dispose() {
    super.dispose();
    Loading.dismissAll();
    _friendInfoVM.clear();
  }

  Future<void> _initFriendInfo() async {
    if (_friendInfoVM.friendInfo == null) {
      _friendInfoVM.friendInfo = ModalRoute.of(context)?.settings.arguments as V2TimFriendInfo;
      await _checkIsFriend();
    }
  }

  @override
  Widget build(BuildContext context) {

    _initFriendInfo();

    return ChangeNotifierProvider.value(
      value: _friendInfoVM,
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
                          RouteUtils.pop(context, result:_friendInfoVM.isChange);
                        },
                      ),
                      Expanded(
                        child: Text(
                          _friendInfoVM.isFriend ? "好友设置" : "聊天设置",
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
        body: Consumer<FriendInfoPageViewModel>(
            builder: (context, vm, child){
              return vm.isFriend
                  ? Container(
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
                                    vm.gotoUserInfo(context, vm.friendInfo!.userID);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: AppColors.backgroundColor3,
                                              backgroundImage: vm.friendInfo?.userProfile?.faceUrl != "默认头像" ? CachedNetworkImageProvider(vm.friendInfo!.userProfile!.faceUrl!) : null
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            (vm.friendInfo?.friendRemark != null && vm.friendInfo?.friendRemark != "") ?
                                            vm.friendInfo!.friendRemark! :
                                            (vm.friendInfo?.userProfile?.nickName ?? ""),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        _showSetRemarkDialog();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "修改备注",
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r)
                                ),
                                child: InkWell(
                                  onTap: (){
                                    _showClearChatMessageDialog();
                                  },
                                  child: Center(
                                    child: Text(
                                      "清空聊天记录",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.sp
                                      ),
                                    ),
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
                                child: InkWell(
                                  onTap: () {
                                    _showDeleteFriendDialog();
                                  },
                                  child: Center(
                                    child: Text(
                                      "删除好友",
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
              )
                  : Container(
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
                                    vm.gotoUserInfo(context, vm.friendInfo!.userID);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: AppColors.backgroundColor3,
                                              backgroundImage: vm.friendInfo?.userProfile?.faceUrl != "默认头像" ? CachedNetworkImageProvider(vm.friendInfo!.userProfile!.faceUrl!) : null
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            (vm.friendInfo?.userProfile?.nickName ?? ""),
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
                                child: InkWell(
                                  onTap: (){
                                    _showClearChatMessageDialog();
                                  },
                                  child: Center(
                                    child: Text(
                                      "清空聊天记录",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16.sp
                                      ),
                                    ),
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
                                child: InkWell(
                                  onTap: (){
                                    if(_friendInfoVM.friendInfo != null){
                                      _showAddFriendDialog(vm.friendInfo!.userID, vm.friendInfo!.userProfile!.nickName ?? "");
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      "添加好友",
                                      style: TextStyle(
                                          color: Colors.blue,
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

  void _showSetRemarkDialog(){
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
                    "修改备注",
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
                      controller: _friendInfoVM.textEditingController,
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
                          await _friendInfoVM.setFriendRemark(_friendInfoVM.friendInfo!.userID, _friendInfoVM.textEditingController.text);
                          _friendInfoVM.isChange = 1;
                          RouteUtils.pop(context);
                          showToast("修改成功");
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "保存",
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void _showClearChatMessageDialog(){
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
                    "清空聊天记录",
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
                      "确认清空聊天记录？",
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
                          await _friendInfoVM.clearChatMessage();
                          RouteUtils.pop(context);
                          _friendInfoVM.isChange = 1;
                          showToast("操作成功");
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "确认",
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void _showDeleteFriendDialog(){
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
                    "删除好友",
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
                      "确认删除该好友？该好友将从好友列表中删除",
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
                          await _friendInfoVM.deleteFriend();
                          RouteUtils.pop(context);
                          _friendInfoVM.isChange = 1;
                          showToast("操作成功");
                          setState(() {
                          });
                        },
                        type: AppButtonType.main,
                        radius: 8.r,
                        buttonText: "确认",
                      )
                  )
                ],
              )
            ],
          ),
        )
    );
  }

  void _showAddFriendDialog(String userID, String nickName) {
    final TextEditingController remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '好友申请',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: remarkController,
                  decoration: InputDecoration(
                    hintText: "输入备注",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: AppColors.searchBgColor,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '取消',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        String remark = remarkController.text.isNotEmpty
                            ? remarkController.text
                            : nickName;
                        // 发送申请的代码

                        await _friendInfoVM.addFriend(userID, remark);
                        _friendInfoVM.isChange = 1;
                        Navigator.of(context).pop();

                        showToast("操作成功");
                        setState(() {
                        });
                      },
                      child: Text(
                        '发送申请',
                        style:
                        TextStyle(color: AppColors.appColor, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}