import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_text_elem.dart';

class ConversationPageViewModel with ChangeNotifier{

  static ConversationPageViewModel instance = ConversationPageViewModel._();

  ConversationPageViewModel._();

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
    refreshController = RefreshController();
    conversationList = await ImChatApi.getInstance().getConversationList("0", size);
    if(conversationList.length < size){
      hasData = false;
    }
    notifyListeners();
  }

  //将时间戳转化为具体时间显示
  String formatTimestamp(int timestamp) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000); // 如果时间戳是秒
    // final date = DateTime.fromMillisecondsSinceEpoch(timestamp); // 如果时间戳是毫秒

    // 判断是否是今天
    if (isSameDay(date, now)) {
      return DateFormat('HH:mm').format(date);
    }

    // 判断是否是昨天
    final yesterday = now.subtract(Duration(days: 1));
    if (isSameDay(date, yesterday)) {
      return "昨天";
    }

    // 判断是否在本周内
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // 本周开始时间
    if (date.isAfter(startOfWeek)) {
      const weekdays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];
      return weekdays[date.weekday - 1];
    }

    // 判断是否是今年
    if (date.year == now.year) {
      return DateFormat('MM/dd').format(date);
    }

    // 更久之前
    return DateFormat('yyyy/MM/dd').format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void clear(){
    refreshController.dispose();
    conversationList.clear();
    currentPage = 0;
    hasData = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("ConversationPageViewModel销毁");
  }

}