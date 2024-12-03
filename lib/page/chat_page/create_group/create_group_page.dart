import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/buttons/red_button.dart';
import 'package:jiayuan/page/chat_page/create_group/create_group_page_vm.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../route/route_utils.dart';

class CreateGroupPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CreateGroupPageState();
  }
}

class _CreateGroupPageState extends State<CreateGroupPage>{

  CreateGroupPageViewModel _createGPVM = CreateGroupPageViewModel();

  @override
  void initState() {
    super.initState();
    _initFriendList();
  }

  Future<void> _initFriendList() async {
    await _createGPVM.getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _createGPVM;
        },
        child: Scaffold(
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
                                  "创建群组",
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
            body: Consumer<CreateGroupPageViewModel>(
                builder: (context, vm, child){
                  return ListView(
                      children: vm.friendList.map((friend) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.backgroundColor6
                              )
                            )
                          ),
                          child: CheckboxListTile(
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
                                    backgroundImage: friend.userProfile?.faceUrl != null ? CachedNetworkImageProvider(friend.userProfile!.faceUrl!) : null,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    friend.friendRemark ?? friend.userProfile!.nickName!,
                                    style: TextStyle(
                                      color: AppColors.textColor2b,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              )
                            ),
                            value: vm.selectedFriendIds.contains(friend.userID),
                            onChanged: (bool? isSelected) {
                              setState(() {
                                if (isSelected == true) {
                                  vm.selectedFriendIds.add(friend.userID);
                                } else {
                                  vm.selectedFriendIds.remove(friend.userID);
                                }
                              });
                            },
                          ),
                        )
                      );
                    }).toList(),
                  );
                }
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
                        buttonText: "确认创建",
                        onTap: () async {
                          await _createGPVM.createGroup();
                          showToast("创建成功");
                        },
                      ),
                  )
                ],
              )
            ),
        ),
    );
  }


}