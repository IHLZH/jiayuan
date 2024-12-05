import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/chat_page/group_info/group_info_page_vm.dart';
import 'package:oktoast/oktoast.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';

class InviteMemberPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return InviteMemberPageState();
  }
}

class InviteMemberPageState extends State<InviteMemberPage>{

  GroupInfoPageViewModel _groupInfoVM = GroupInfoPageViewModel.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    _groupInfoVM.clearFriendInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor3,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                    Colors.white,      // 渐变结束颜色
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                height: 250.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              RouteUtils.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new)
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          child: Text(
                            "邀请好友",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
          )
      ),
      body: ListView(
        children: _groupInfoVM.friendList.map((friend) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.backgroundColor6
                        )
                    )
                ),
                child: Stack(
                  children: [
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: CircleBorder(
                        side: BorderSide(
                          color: AppColors.backgroundColor3,
                        ),
                      ),
                      checkColor: Colors.white,
                      activeColor: AppColors.appColor,
                      title: Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.backgroundColor3,
                              backgroundImage: friend.userProfile?.faceUrl != null
                                  ? CachedNetworkImageProvider(friend.userProfile!.faceUrl!)
                                  : null,
                            ),
                            SizedBox(width: 10),
                            Text(
                              friend.friendRemark != null && friend.friendRemark != "" ? friend.friendRemark! : friend.userProfile!.nickName!,
                              style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: _groupInfoVM.selectedFriendIds.contains(friend.userID),
                      onChanged: (bool? isSelected) {
                        setState(() {
                          if (isSelected == true && !_groupInfoVM.groupMemberId.contains(friend.userID)) {
                            _groupInfoVM.selectedFriendIds.add(friend.userID);
                          } else {
                            _groupInfoVM.selectedFriendIds.remove(friend.userID);
                          }
                        });
                      },
                    ),
                    if(_groupInfoVM.groupMemberId.contains(friend.userID))
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0), // 设置模糊强度
                          child: Container(
                            color: Colors.white.withOpacity(0.5), // 半透明的白色
                          ),
                        ),
                      ),
                  ],
                )
              )
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 60.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonHeight: 50.h,
                  radius: 8.r,
                  type: AppButtonType.main,
                  buttonText: "确认邀请",
                  onTap: () async {
                    await _groupInfoVM.inviteFriend(_groupInfoVM.selectedFriendIds.toList());
                    RouteUtils.pop(context);
                  },
                ),
              )
            ],
          )
      ),
    );
  }
}