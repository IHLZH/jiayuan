import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_text_elem.dart';

class ConversationPageViewModel with ChangeNotifier{

  //会话列表
  List<V2TimConversation?> conversationList = [];

  //刷新控制器
  RefreshController refreshController = RefreshController();

  int currentPage = 0;
  int size = 10;

  bool hasData = true;

  //上拉加载
  Future<void> onLoading() async {
    if(hasData){
      currentPage += size;
      List<V2TimConversation?> conversationData = await ImChatApi.getInstance().getConversationList(currentPage.toString(), size);
      if(conversationData.length < size){
        conversationList.addAll(conversationData);
        hasData = false;
        refreshController.loadNoData();
        notifyListeners();
      }else{
        conversationList.addAll(conversationData);
        refreshController.loadComplete();
        notifyListeners();
      }
    }else{
      refreshController.loadNoData();
      notifyListeners();
    }
  }

  //下拉刷新
  Future<void> onRefresh() async {
    currentPage = 0;
    await initConversationList();
    refreshController.resetNoData();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  //调用sdk，初始化会话列表
  Future<void> initConversationList() async {
    conversationList = await ImChatApi.getInstance().getConversationList("0", size);
    if(conversationList.length < size){
      hasData = false;
    }
    notifyListeners();
  }

  String formatTimestamp(int timestamp) {
    // 将时间戳（秒或毫秒）转化为 DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // 使用 DateFormat 格式化时间
    return DateFormat('HH:mm').format(dateTime);
  }


}