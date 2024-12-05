import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/group_api.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';

import '../../../im/im_chat_api.dart';

class GroupInfoPageViewModel with ChangeNotifier{

  static GroupInfoPageViewModel instance  = GroupInfoPageViewModel._();

  GroupInfoPageViewModel._();

  V2TimGroupInfo? groupInfo;

  late List<V2TimGroupMemberFullInfo?> groupMember = [];

  List<String> groupMemberId = [];

  List<V2TimFriendInfo> friendList = [];

  // 用于记录已选中的好友ID
  Set<String> selectedFriendIds = {};

  int isChange = 0;

  Future<void> getGroupMember() async {
    if(groupInfo != null){
      groupMember = await GroupApi().getGroupMemberList(groupInfo!.groupID);
      for(V2TimGroupMemberFullInfo? groupMember in groupMember){
        groupMemberId.add(groupMember!.userID);
      }
      notifyListeners();
      print("获取群成员结束");
    }else{
      showToast("群聊信息不存在");
    }
  }

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
  }

  Future<void> inviteFriend(List<String> userList) async {
    if(groupInfo != null){
      bool res = await GroupApi().inviteUserToGroup(groupInfo!.groupID, userList);
      if(res){
        isChange = 1;
        showToast("邀请成功");
        await getGroupMember();
      }else{
        showToast("邀请失败，请稍后再试");
      }
    }
  }

  void clear(){
    isChange = 0;
    groupInfo = null;
    groupMember = [];
    groupMemberId = [];
    clearFriendInfo();
  }

  void clearFriendInfo(){
    friendList.clear();
    selectedFriendIds.clear();
  }

}