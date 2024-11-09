class HousekeeperDataDetail {
  //家政员id
  int? keeperId;

  //真实姓名
  String? realName;

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

  //所在地
  String? city;

  //完成订单数
  int? completedOrders;

  //服务标签
  List<String> ? tags;

  //个人照片
  List<String> ? keeperImages;

  //个人简介
  String? introduction;

  //个人证书
  List<String> ? certificates;

  //联系方式
  String? contact;

  //评价类
  List<Evaluation>? evaluations;

  HousekeeperDataDetail({
    this.city,
    this.completedOrders,
    this.keeperImages,
    this.introduction,
    this.certificates,
    this.tags,
    this.realName,
    this.keeperId,
    this.age,
    this.avatar,
    this.workExperience,
    this.highlight,
    this.rating,
    this.contact,
    this.evaluations
  });
}

class Evaluation{

  // 评价者id
  int? userId;

  //评价者头像
  String? avatar;

  //评价者昵称
  String? nickname;

  //评价时间
  DateTime? time;


  //评价内容
  String? content;

  //评价图片
  List<String>? images;

  //评分
  double? rating;

  Evaluation({
    this.userId,
    this.avatar,
    this.nickname,
    this.content,
    this.time,
    this.images,
    this.rating,
  });
}
