class Housekeeper {
  //真实姓名
  String? realName;
  //家政员id
  int? keeperId;
  //年龄
  int? age;
  //头像
  String? avatar;
  //工作经验
  int? workExperience;
  //亮点
  String? highlight;
  //评分
  double? rating;

  Housekeeper({
    this.realName,
    this.keeperId,
    this.age,
    this.avatar,
    this.workExperience,
    this.highlight,
    this.rating,
  });

  Housekeeper.fromJson(data) {
    realName = data['realName'];
    keeperId = data['keeperId'];
    age = data['age'];
    avatar = data['avatar'];
    workExperience = data['workExperience'];
    highlight = data['highlight'];
    rating = data['rating'];
  }
  Map<String, dynamic> toMap() {
    return {
      'realName': realName,
      'keeperId': keeperId,
      'age': age,
      'avatar': avatar,
      'workExperience': workExperience,
      'highlight': highlight,
      'rating': rating,
      'createTime': DateTime.now().toIso8601String(),
    };
  }


}
