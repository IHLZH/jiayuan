import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/group_api.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../im/im_chat_api.dart';

class CreateGroupPageViewModel with ChangeNotifier{

  List<V2TimFriendInfo> friendList = [];

  // 用于记录已选中的好友ID
  Set<String> selectedFriendIds = {};

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

  Future<void> createGroup() async {
    await GroupApi().createGroup("groupName", selectedFriendIds.toList());
  }

  void clear(){
    selectedFriendIds.clear();
    friendList.clear();
  }


}