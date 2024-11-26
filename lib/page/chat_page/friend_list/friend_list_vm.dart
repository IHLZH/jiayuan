import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

class FriendListViewModel with ChangeNotifier{

  static FriendListViewModel instance = FriendListViewModel._();

  FriendListViewModel._();

  int currentIndex = 0;

  List<V2TimFriendInfo> friendList = [];

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

}