class MessageKeeper {
  final int keeperId;
  final int userId;
  final String avatar;
  final int completeSingularNumber;
  final double averageRating;
  final String realName;

  MessageKeeper({
    required this.keeperId,
    required this.userId,
    required this.avatar,
    required this.completeSingularNumber,
    required this.averageRating,
    required this.realName,
  });

  Map<String, dynamic> toJson() {
    return {
      'keeperId': keeperId,
      'userId': userId,
      'avatar': avatar,
      'completeSingularNumber': completeSingularNumber,
      'averageRating': averageRating,
      'realName': realName,
    };
  }

  static MessageKeeper fromJson(Map<String, dynamic> json) {
    return MessageKeeper(
      keeperId: json['keeperId'],
      userId: json['userId'],
      avatar: json['avatar'] ?? '',
      completeSingularNumber: json['completeSingularNumber'],
      averageRating: json['averageRating'] is int
          ? json['averageRating'].toDouble()
          : json['averageRating'],
      realName: json['realName'] ?? '',
    );
  }

  static List<MessageKeeper> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageKeeper.fromJson(json)).toList();
  }
}
