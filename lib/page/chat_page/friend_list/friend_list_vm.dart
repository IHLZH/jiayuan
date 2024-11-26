import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';

class FriendListViewModel with ChangeNotifier{

  static FriendListViewModel instance = FriendListViewModel._();

  FriendListViewModel._();

  RefreshController refreshController = RefreshController();

  List<V2TimFriendInfo> friendList = [];

  int currentIndex = 0;

  Future<void> onRefresh() async {
    await getFriendList();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

  Future<void> gotoChatPage(BuildContext context, String userId) async {
    V2TimConversation? conversation = await ImChatApi.getInstance().getConversation("c2c_${userId}");
    RouteUtils.pushForNamed(context, RoutePath.chatPage, arguments: conversation);
  }

}