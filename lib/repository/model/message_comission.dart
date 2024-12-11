import 'dart:convert';

class MessageCommission {
  final int commissionId;
  final String username;
  final String serviceName;
  final double commissionBudget;
  final DateTime expectStartTime;

  MessageCommission({
    required this.commissionId,
    required this.username,
    required this.serviceName,
    required this.commissionBudget,
    required this.expectStartTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'commissionId': commissionId,
      'username': username,
      'serviceName': serviceName,
      'commissionBudget': commissionBudget,
      'expectStartTime': expectStartTime.toIso8601String(),
    };
  }

  static MessageCommission fromJson(Map<String, dynamic> json) {
    return MessageCommission(
      commissionId: json['commissionId'],
      username: json['username'],
      serviceName: json['serviceName'],
      commissionBudget: json['commissionBudget'] is int
          ? json['commissionBudget'].toDouble()
          : json['commissionBudget'],
      expectStartTime: DateTime.parse(json['expectStartTime']),
    );
  }

  static List<MessageCommission> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageCommission.fromJson(json)).toList();
  }
}
