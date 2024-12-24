import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/repository/model/message_comission.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../http/url_path.dart';
import '../../repository/model/ai_message.dart';
import '../../repository/model/message_keeper.dart';
import '../../utils/global.dart';

bool isProduction = Constants.IS_Production;

class FullAiMessage {
  final AiMessage aiMessage;
  final String type;
  final List<Object> data;

  // 有参构造函数
  FullAiMessage({
    required this.aiMessage,
    required this.type,
    required this.data,
  });

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'aiMessage': aiMessage.toJson(),
      'type': type,
      'data':
          data.map((item) => item is AiMessage ? item.toJson() : item).toList(),
    };
  }

  // fromJson 方法
  factory FullAiMessage.fromJson(Map<String, dynamic> json) {
    return FullAiMessage(
      aiMessage: AiMessage.fromJson(json['aiMessage']),
      type: json['type'],
      data: List<Object>.from(json['data'].map((item) {
        return item;
      })),
    );
  }

  // toJsonList 方法
  static String toJsonList(List<FullAiMessage> messages) {
    return jsonEncode(messages.map((message) => message.toJson()).toList());
  }

  // fromJsonList 方法
  static Future<List<FullAiMessage>> fromJsonList(String json) async {
    final List<dynamic> parsedList = jsonDecode(json);
    return parsedList.map((json) => FullAiMessage.fromJson(json)).toList();
  }
}

class AiCustomerServiceViewModel with ChangeNotifier {
  // 私有构造函数
  AiCustomerServiceViewModel._internal();

  // 静态实例
  static final AiCustomerServiceViewModel _instance =
      AiCustomerServiceViewModel._internal();

  // 工厂构造函数
  factory AiCustomerServiceViewModel() => _instance;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<FullAiMessage> messages = [];

  // 发送消息到后端
  Future<void> sendMessage(String message) async {
    // 模拟发送消息
    AiMessage userMessage =
        AiMessage(isSelf: true, message: message, sendTime: DateTime.now());
    FullAiMessage fullAiMessageMe =
        FullAiMessage(aiMessage: userMessage, type: 'Me', data: []);
    messages.add(fullAiMessageMe);
    notifyListeners();

    String url = UrlPath.aiCustomerServiceUrl;

    String answer = '';

    List<int> messagesList = [];

    try {
      // 发送消息到后端
      final response = await DioInstance.instance().get(
        path: url,
        param: {'message': message, 'username': Global.userInfo?.userName},
        options: Options(headers: {"Authorization": Global.token}),
      );

      if (isProduction) print("res: ${response}");

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          if (response.data['message'] == '委托id' ||
              response.data['message'] == '家政员id') {
            messagesList = List<int>.from(response.data['data']);

            //将List<int>转为逗号分隔的字符串
            answer = response.data['message'];
            // answer = messagesList.join(",");

            if (isProduction)
              print("============== answer: $answer ================");
            if (isProduction)
              print("======== 回复： ${messagesList.join(',')}=============");
          }else{
            answer = response.data['message'];
          }
        } else {
          showToast("error: ${response.data['message']}",
              duration: Duration(seconds: 1));
          answer = response.data['message'];
        }
      } else {
        if (isProduction) showToast("服务器连接失败", duration: Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }

    //获取委托信息组
    if (answer == '委托id') {
      if (isProduction) print("======== 进入查找 =========");
      try {
        final response = await DioInstance.instance().get(
          path: UrlPath.getAiCommissionList,
          param: {'commissionIds': messagesList},
          options: Options(headers: {"Authorization": Global.token}),
        );
        if (response.statusCode == 200) {
          if (response.data['code'] == 200) {
            List<MessageCommission> commissionList =
                MessageCommission.fromJsonList(response.data['data']);

            if (isProduction) print("======== 回复： =============");
            if (isProduction) print(response.data['data']);

            AiMessage newMessage = AiMessage(
                isSelf: false, message: answer, sendTime: DateTime.now());

            FullAiMessage fullAiMessageAi = FullAiMessage(
                aiMessage: newMessage, type: '委托id', data: commissionList);

            messages.add(fullAiMessageAi);
            notifyListeners();
          } else {
            showToast("失败： ${response.data['message']}",
                duration: Duration(seconds: 1));
            if (isProduction) print("error: ${response.data['message']}");
          }
        } else {
          if (isProduction)
            showToast("服务器连接失败", duration: Duration(seconds: 1));
          if (isProduction) print("error: ${response.statusMessage}");
        }
      } catch (e) {
        if (isProduction) print("error: $e");
      }
    } else if (answer == '家政员id') {
      print("======== 进入查找 =========");

      try {
        final response = await DioInstance.instance().get(
          path: UrlPath.getAiKeeperList,
          param: {'keeperIds': messagesList},
          options: Options(headers: {"Authorization": Global.token}),
        );

        if (response.statusCode == 200) {
          if (response.data['code'] == 200) {
            List<MessageKeeper> keeperList =
                MessageKeeper.fromJsonList(response.data['data']);

            if (isProduction) print("======== 回复： =============");
            if (isProduction) print(response.data['data']);

            AiMessage newMessage = AiMessage(
                isSelf: false, message: answer, sendTime: DateTime.now());

            FullAiMessage fullAiMessageAi = FullAiMessage(
                aiMessage: newMessage, type: '家政员id', data: keeperList);
            messages.add(fullAiMessageAi);
            notifyListeners();
          } else {
            showToast("失败： ${response.data['message']}",
                duration: Duration(seconds: 1));
            if (isProduction) print("error: ${response.data['message']}");
          }
        } else {
          if (isProduction)
            showToast("服务器连接失败", duration: Duration(seconds: 1));
          if (isProduction) print("失败: ${response.statusMessage}");
        }
      } catch (e) {
        print("error: $e");
      }
    } else {
      // 模拟接收回复
      // await Future.delayed(Duration(seconds: 2));

      // print("============== answer: $answer=============");

      AiMessage aiResponse =
          AiMessage(isSelf: false, message: answer, sendTime: DateTime.now());
      FullAiMessage fullAiMessageAi =
          FullAiMessage(aiMessage: aiResponse, type: 'Ai', data: []);
      messages.add(fullAiMessageAi);
      notifyListeners();
    }
  }

  // 加载本地缓存的消息
  Future<void> loadCachedMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedMessagesJson = prefs.getString('cachedMessages');
    if (cachedMessagesJson != null) {
      // 使用 fromJsonList 方法解析 JSON 字符串
      messages = await FullAiMessage.fromJsonList(cachedMessagesJson);
      if (isProduction) {
        //打印本地缓存的信息
        print("========== 本地缓存的消息 ===========");
        print(cachedMessagesJson);
      }
      notifyListeners();
    }
  }

  // 保存消息到本地缓存
  Future<void> saveMessagesToCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // 使用 toJsonList 方法将消息列表转换为 JSON 字符串
    final String messagesJson = FullAiMessage.toJsonList(messages);
    await prefs.setString('cachedMessages', messagesJson);

    if (isProduction) {
      print("========== 保存到本地缓存的消息 ===========");
      print(messagesJson);
    }
  }

  // 清空聊天记录
  Future<void> clearMessages() async {
    messages.clear();
    notifyListeners();
    await saveMessagesToCache();
  }

  MessageCommission parseCommission(Map<String, dynamic> data) {
    return MessageCommission(
      username: data['username'],
      commissionId: data['commissionId'],
      serviceName: data['serviceName'],
      commissionBudget: data['commissionBudget'],
      expectStartTime: DateTime.parse(data['expectStartTime']),
    );
  }
}
