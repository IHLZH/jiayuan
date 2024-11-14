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

  //创建时间
  DateTime? createdTime;

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


  //用于本地数据库的解析
  Map<String, dynamic> toMap() {
    return {
      'realName': realName,
      'keeperid': keeperId,
      'age': age,
      'avatar': avatar,
      'workExperience': workExperience,
      'highlight': highlight,
      'rating': rating,
      'createdTime': createdTime?.toIso8601String(),
    };
  }
//用于本地数据库的解析
  static Housekeeper fromMap(Map map) {
    Housekeeper housekeeper = Housekeeper(
      realName: map['realName'],
      keeperId: map['keeperid'],
      age: map['age'],
      avatar: map['avatar'],
      workExperience: map['workExperience'],
      highlight: map['highlight'],
      rating: map['rating'],
    );
    housekeeper.createdTime = DateTime.parse(map['createdTime']);
    return housekeeper;
  }
}
