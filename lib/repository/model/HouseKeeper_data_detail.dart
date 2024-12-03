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

   HousekeeperDataDetail.fromJson(data) {
     keeperId = data['keeperId'] ;
     realName = data['realName'] ?? "";
     age = data['age'] ?? 0;
     avatar = data['avatar'] ?? "";
     workExperience = data['workExperience'] ?? 1;
     highlight = data['highLight'] ?? "";
     rating = (data['averageRating']  ?? 4.5) as double ;
     city = data['city'] ?? "";
     completedOrders = data['completeSingularNumber']?? 0;
     tags = data['tags']?.cast<String>() ?? [];
     keeperImages = data['photoUrl']?.cast<String>() ?? [];
     introduction = data['introduction']?? "";
     certificates = data['certificatePicUrl']?.cast<String>() ?? [];
     contact = data['dailyPhoneNumber'] ?? data['phoneNumber'] ??  "";
     evaluations = [] ;
   }

   Map<String, dynamic> toJson() => {
     "keeperId":keeperId,
     "realName":realName,
     "age":age,
     "avatar":avatar,
     "workExperience":workExperience,
     "highLight":highlight,
     "averageRating":rating,
     "city":city,
     "completeSingularNumber":completedOrders,
     "tags":tags,
     "photoUrl":keeperImages,
     "introduction":introduction,
     "certificatePicUrl":certificates,
     "dailyPhoneNumber":contact,
   };
}

class Evaluation{

  //评价者头像
  String? avatar;

  //评价者昵称
  String? nickName;

  //评价时间
  DateTime? time;


  //评价内容
  String? content;

  //评价图片
  List<String>? images;

  //评分
  int? rating;

  Evaluation({
    this.avatar,
    this.nickName,
    this.content,
    this.time,
    this.images,
    this.rating,
  });

  Evaluation.fromJson(item) {
    avatar = item['userAvatar'];
    nickName = item['nickName'];
    content = item['comment'];
    time = DateTime.parse(item['createTime']);
    images = item['commentPicUrl'].cast<String>();
    rating = item['star'];
  }
}
