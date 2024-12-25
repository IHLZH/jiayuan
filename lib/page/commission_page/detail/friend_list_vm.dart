import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';

import '../../../im/im_chat_api.dart';
import '../../../repository/api/group_api.dart';

class ShareFriendListViewModel with ChangeNotifier{

  List<V2TimFriendInfo> friendList = [];

  List<V2TimGroupInfo> groupList = [];

  // 用于记录已选中的好友ID
  Set<String> selectedFriendIds = {};

  Set<String> selectedGroupIds = {};

  CommissionData1? commissionData;

  HousekeeperDataDetail? keeperData;

  TextEditingController textEditingController = TextEditingController();

  late TabController tabController;

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

  Future<void> getGroupList() async {
    groupList = await ImChatApi.getInstance().getGroupList();
    notifyListeners();
  }

  Future<bool> shareCommission() async {
    List<String> users = selectedFriendIds.toList();
    List<String> groups = selectedGroupIds.toList();
    if(commissionData != null){
      for(String userId in users){
        await ImChatApi.getInstance().sendTextMessage(userId, "@CommissionData:${commissionData!.commissionId}");
      }
      for(String groupId in groups){
        await ImChatApi.getInstance().sendGroupTextMessage(groupId, "@CommissionData:${commissionData!.commissionId}");
      }
      showToast("分享成功");
      return true;
    }else{
      showToast("委托信息获取错误！");
      return false;
    }
  }

  Future<bool> shareKeeper() async {
    List<String> users = selectedFriendIds.toList();
    List<String> groups = selectedGroupIds.toList();
    if(keeperData != null){
      for(String userId in users){
        await ImChatApi.getInstance().sendTextMessage(userId, "@KeeperData:${keeperData!.keeperId}");
      }
      for(String groupId in groups){
        await ImChatApi.getInstance().sendGroupTextMessage(groupId, "@KeeperData:${keeperData!.keeperId}");
      }
      showToast("分享成功");
      return true;
    }else{
      showToast("家政员信息获取错误！");
      return false;
    }
  }

  void clear(){
    selectedFriendIds.clear();
    friendList.clear();
  }

}