import 'package:flutter/cupertino.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/page/chat_page/chat/chat_page_vm.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';

class FriendInfoPageViewModel with ChangeNotifier{

  static FriendInfoPageViewModel instance = FriendInfoPageViewModel._();

  FriendInfoPageViewModel._();

  TextEditingController textEditingController = TextEditingController();

  V2TimFriendInfo? friendInfo;

  bool isFriend = false;

  int isChange = 0;

  Future<void> checkIsFriend() async {
    if(friendInfo != null){
      isFriend = await UserApi.instance.checkFriend(int.parse(friendInfo!.userID));
      notifyListeners();
    }
  }

  Future<void> setFriendRemark(String userId, String remark) async {
    await ImChatApi.getInstance().setFriendRemark(userId, remark);
    await refreshFriendInfo();
    notifyListeners();
  }

  Future<void> refreshFriendInfo() async {
    if(friendInfo != null){
      V2TimFriendInfoResult friendInfoResult = await ImChatApi.getInstance().getFriendProfile(friendInfo!.userID);
      if(friendInfoResult.friendInfo != null){
        this.friendInfo = friendInfoResult.friendInfo!;
      }
      notifyListeners();
    }
  }

  Future<void> refreshConversation() async {
    await ChatPageViewModel.instance.refreshConversation();
  }

  Future<void> deleteFriend() async {
    if(friendInfo != null){
      await ImChatApi.getInstance().deleteFriend(friendInfo!.userID);
    }
  }

  Future<void> clearChatMessage() async {
    if(friendInfo != null){
      await ImChatApi.getInstance().clearSignalMessage(friendInfo!.userID);
    }
  }

  void clear(){
    friendInfo = null;
    isFriend = false;
    textEditingController.clear();
    isChange = 0;
  }

}