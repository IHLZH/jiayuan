import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/chat_page/friend_info/friend_info_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../common_ui/styles/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {

    _friendInfoVM.friendInfo = ModalRoute.of(context)?.settings.arguments as V2TimFriendInfo;

    return ChangeNotifierProvider.value(
      value: _friendInfoVM,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor3
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
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
                        "好友设置",
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                )
            )
        ),
      ),
    );
  }
}