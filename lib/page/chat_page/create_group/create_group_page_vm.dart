import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/group_api.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../im/im_chat_api.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';

class CreateGroupPageViewModel with ChangeNotifier{

  List<V2TimFriendInfo> friendList = [];

  // 用于记录已选中的好友ID
  Set<String> selectedFriendIds = {};

  TextEditingController textEditingController = TextEditingController();

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

  Future<String> createGroup(String groupName) async {
    String groupId = await GroupApi().createGroup(groupName ?? "", selectedFriendIds.toList());
    return groupId;
  }

  Future<void> gotoChatPage(BuildContext context,String groupId) async {
    V2TimConversation? conversation = await ImChatApi.getInstance().getConversation("group_${groupId}");
    if(conversation != null){
      RouteUtils.pushReplacementNamed(context, RoutePath.chatPage, arguments: conversation);
    }
  }

  void clear(){
    selectedFriendIds.clear();
    friendList.clear();
  }


}