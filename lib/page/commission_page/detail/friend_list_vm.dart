import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../../im/im_chat_api.dart';
import '../../../repository/api/group_api.dart';

class ShareFriendListViewModel with ChangeNotifier{

  List<V2TimFriendInfo> friendList = [];

  // 用于记录已选中的好友ID
  Set<String> selectedFriendIds = {};

  CommissionData1? commissionData;

  TextEditingController textEditingController = TextEditingController();

  Future<void> getFriendList() async {
    friendList = await ImChatApi.getInstance().getFriendList();
    notifyListeners();
  }

  Future<bool> shareCommission(List<String> users) async {
    if(commissionData != null){
      for(String userId in users){
        await ImChatApi.getInstance().sendTextMessage(userId, "@CommissionData:${commissionData!.commissionId}");
      }
      showToast("分享成功");
      return true;
    }else{
      showToast("委托信息获取错误！");
      return false;
    }
  }

  void clear(){
    selectedFriendIds.clear();
    friendList.clear();
  }

}