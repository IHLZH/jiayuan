import 'dart:convert';

class AiMessage {
  final bool isSelf;
  final String message;
  final DateTime sendTime;

  AiMessage({required this.isSelf, required this.message, required this.sendTime});

  Map<String, dynamic> toJson() {
    return {
      'isSelf': isSelf,
      'message': message,
      'sendTime': sendTime.toIso8601String(),
    };
  }

  static AiMessage fromJson(Map<String, dynamic> json) {
    return AiMessage(
      isSelf: json['isSelf'],
      message: json['message'],
      sendTime: DateTime.parse(json['sendTime']),
    );
  }

  static String toJsonList(List<AiMessage> messages) {
    return jsonEncode(messages.map((message) => message.toJson()).toList());
  }

  static List<AiMessage> fromJsonList(String json) {
    final List<dynamic> parsedList = jsonDecode(json);
    return parsedList.map((json) => AiMessage.fromJson(json)).toList();
  }
}
   