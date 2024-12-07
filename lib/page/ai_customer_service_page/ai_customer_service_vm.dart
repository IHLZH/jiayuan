import 'dart:convert'; // 添加这一行以使用 jsonEncode 和 jsonDecode

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/model/ai_message.dart';

class AiCustomerServiceViewModel with ChangeNotifier {

  // 私有构造函数
  AiCustomerServiceViewModel._internal();

  // 静态实例
  static final AiCustomerServiceViewModel _instance = AiCustomerServiceViewModel._internal();

  // 工厂构造函数
  factory AiCustomerServiceViewModel() => _instance;

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  List<AiMessage> messages = [];

  // 发送消息到后端
  Future<void> sendMessage(String message) async {
    // 模拟发送消息
    AiMessage userMessage = AiMessage(isSelf: true, message: message, sendTime: DateTime.now());
    messages.add(userMessage);
    notifyListeners();

    // 模拟接收回复
    await Future.delayed(Duration(seconds: 2));
    AiMessage aiResponse = AiMessage(isSelf: false, message: '这是AI的回复', sendTime: DateTime.now());
    messages.add(aiResponse);
    notifyListeners();
  }

  // 加载本地缓存的消息
  Future<void> loadCachedMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedMessagesJson = prefs.getString('cachedMessages');
    if (cachedMessagesJson != null) {
      // 使用 fromJsonList 方法解析 JSON 字符串
      messages = AiMessage.fromJsonList(cachedMessagesJson);
      notifyListeners();
    }
  }

  // 保存消息到本地缓存
  Future<void> saveMessagesToCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 使用 toJsonList 方法将消息列表转换为 JSON 字符串
    final String messagesJson = AiMessage.toJsonList(messages);
    await prefs.setString('cachedMessages', messagesJson);
  }

  // 清空聊天记录
  Future<void> clearMessages() async {
    messages.clear();
    notifyListeners();
    await saveMessagesToCache();
  }
}
   