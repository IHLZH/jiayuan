import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/page/chat_page/conversation_page.dart';
import 'package:jiayuan/page/chat_page/conversation_page_vm.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../repository/api/user_api.dart';
import '../../../repository/model/searchUser.dart';
import '../../search_user/user_info/user_info_vm.dart';

class ChatPageViewModel with ChangeNotifier{

  static ChatPageViewModel instance = ChatPageViewModel._();

  ChatPageViewModel._();

  List<V2TimMessage> chatMessageList = [];

  V2TimConversation? conversation;

  ScrollController scrollController = ScrollController();

  TextEditingController textController = TextEditingController();

  int count = 15;
  String? lastMessageId = null;
  bool hasMoreData = true;

  bool isLoading = false;

  Future<void> getChatMessage() async {
    if(conversation != null){
      List<V2TimMessage> chatMessageData = await ImChatApi.getInstance().getHistorySignalMessageList(conversation!.userID!, count, lastMessageId);
      if(chatMessageData.isNotEmpty){
        lastMessageId = chatMessageData.last.msgID;
        if(chatMessageData.length < count){
          hasMoreData = false;
        }
        //print("获取到 chatMessageList 长度为：" + chatMessageList.length.toString());
        chatMessageList.addAll(chatMessageData);
      }else{
        hasMoreData = false;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void clear(){
    conversation = null;
    lastMessageId = null;
    hasMoreData = true;
    chatMessageList.clear();
  }

  Future<void> refreshConversation() async {
    conversation = await ImChatApi.getInstance().getConversation(conversation!.conversationID);
    notifyListeners();
    await refreshChatMessage();
  }

  Future<void> refreshChatMessage() async {
    if(conversation != null){
      lastMessageId = null;
      chatMessageList.clear();
      List<V2TimMessage> chatMessageData = await ImChatApi.getInstance().getHistorySignalMessageList(conversation!.userID!, count, lastMessageId);
      chatMessageList.addAll(chatMessageData);
      await clearUnReadCount(conversation!);
      notifyListeners();
    }
  }

  Future<void> clearUnReadCount(V2TimConversation conversation) async {
    await ImChatApi.getInstance().clearSignalUnread(conversation.userID!);
    notifyListeners();
  }

  Future<void> sendSingMessage() async {
    if(conversation != null){
      await ImChatApi.getInstance().sendTextMessage(conversation!.userID!, textController.text);
      //更新lastMessageId
      await refreshChatMessage();
    }
  }

  Future<void> gotoFriendInfo(BuildContext context, String userId) async {
    V2TimFriendInfoResult friendInfoResult = await ImChatApi.getInstance().getFriendProfile(userId);
    V2TimFriendInfo? friendInfo = friendInfoResult.friendInfo;
    if(friendInfo != null){
      int result = await RouteUtils.pushForNamed(context, RoutePath.friendInfo,arguments: friendInfo) as int;
      if(result == 1){
        print("备注改变");
        refreshConversation();
      }
    }else{
      showToast("用户信息获取失败");
    }
  }

  Future<void> gotoUserInfo(BuildContext context, String userId) async {
    SearchUser searchUser = await UserApi.instance.getSignalUser(int.parse(userId));
    if(userId != Global.userInfo!.userId.toString() || conversation?.userID == Global.userInfo!.userId.toString()) {
      UserInfoViewModel.isChatJumpTo = true;
    }
    RouteUtils.pushForNamed(context, RoutePath.userInfoPage,  arguments: {"user": searchUser}) as String;
  }

  void initScorllListener(){
    scrollController.addListener(_onScorll);
  }

  Future<void> _onScorll() async {
    // 距离顶部的距离（预加载阈值）
    const double preloadThreshold = 100.0;
    if (scrollController.position.pixels <=
        scrollController.position.minScrollExtent + preloadThreshold) {
      // 滑动到顶部时加载更多
      await _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if(hasMoreData && !isLoading){
      isLoading = true;
      notifyListeners();
      await getChatMessage();
    }
  }

  String? formatTimestampToHours(int timestamp){
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000); // 如果时间戳是秒
    // 判断是否是今天
    if (!isSameDay(date, now)) {
      return DateFormat('HH:mm').format(date);
    }
    return null;
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


}