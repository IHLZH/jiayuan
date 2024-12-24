import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/chat_page/friend_list/friend_list_vm.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/buttons/red_button.dart';
import '../../../common_ui/styles/app_colors.dart';
import '../../../repository/model/commission_data1.dart';
import '../../../route/route_utils.dart';
import 'friend_list_vm.dart';

class FriendListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FriendListPageState();
  }
}

class _FriendListPageState extends State<FriendListPage>{

  ShareFriendListViewModel _friendListVM = ShareFriendListViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFriendList();
  }

  Future<void> _initFriendList() async {
    await _friendListVM.getFriendList();
  }

  @override
  Widget build(BuildContext context) {

    _friendListVM.commissionData = ModalRoute.of(context)?.settings.arguments as CommissionData1;

    return ChangeNotifierProvider(
      create: (context){
        return _friendListVM;
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
                              "分享到",
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
        body: Consumer<ShareFriendListViewModel>(
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
                    buttonText: "分享",
                    onTap: () async {
                      bool result = await _friendListVM.shareCommission(_friendListVM.selectedFriendIds.toList());
                      if(result){
                        RouteUtils.pop(context);
                      }
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