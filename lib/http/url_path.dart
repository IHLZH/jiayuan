class UrlPath {
  static const String realBaseUrl = "http://192.168.3.32:9900/";

  static const String BaseUrl = "http://10.7.89.121:8080";
  // static const String BaseUrl = "http://192.168.31.189:8080";
  // static const String BaseUrl = "http://www.shinesuning.top:8080";
  static const String wangBaseUrl = "http://10.7.89.154:8080";

  static const String testBaseUrl = "http://10.7.89.68:8080";

  static const String yuwenBaseUrl = "http://192.168.201.44:8080";
  //Token登录
  static const String loginAutoUrl = "/login/autoLogin";

  //账号登录获取图像验证码接口
  static const String captchaImageUrl = "/code/image";

  //账号登录接口
  static const String loginUrl = "/login/loginBoth";

  //邮箱获取验证码接口
  static const String getEmailCodeUrl = "/email/sendEmailCode";

  //邮箱登录接口
  static const String loginWithEmailCodeUrl = "/login/email";

  //手机号登录接口
  static const String loginWithPhoneCodeUrl = "/login/phone";

  //手机获取验证码接口
  static const String getPhoneCodeUrl = "/sendSmsCode";

  //邮箱忘记密码检验验证码接口
  static const String checkPasswordEmailCodeUrl = "/password/email";

  //手机忘记密码检验验证码接口
  static const String checkPasswordPhoneCodeUrl = "/password/phone";

  //重置密码接口
  static const String resetPasswordUrl = "/password/resetPassword";

  //邮箱注册验证码验证接口
  static const String checkRegisterEmailCodeUrl = "/register/email";

  //手机注册验证码验证接口
  static const String checkRegisterPhoneCodeUrl = "/register/phone";

  //注册设置密码接口
  static const String setRegisterPasswordUrl = "/register/setPassword";

  //注销接口
  static const String logoutUrl = "/logout";

  //个人信息修改接口
  static const String updateUserInfoUrl = "/update/userInfo";

  //邮箱绑定接口
  static const String bindEmailUrl = "/bindEmail";

  //邮箱验证接口
  static const String verifyEmailUrl = "/verify/email";

  //手机号绑定接口
  static const String bindPhoneUrl = "/bindPhone";

  //手机号验证接口
  static const String verifyPhoneUrl = "/verify/phone";

  //旧密码修改密码接口
  static const String updatePasswordUrl = "/password/resetPassword/old";

  //用户头像上传接口
  static const String uploadAvatarUrl = "/avatar/upload";

  //接取委托接口
  static const String receiveCommissionUrl = "/receive";

  //取消接取委托接口
  static const String cancelReceiveCommissionUrl = "/cancel_receive";

  //根据userId获取订单信息接口
  static const String getOrderInfoByUserIdUrl = "/order/view/list";

  //根据userId和status获取订单信息接口
  static const String getOrderInfoByUserIdAndStatusUrl = "/order/view/status";

  //订单状态更改接口
  static const String updateOrderStatusUrl = "/order/update/status";

  //订单信息更改接口
  static const String updateOrderInfoUrl = "/order/update/commissionInfo";

  //发送委托的接口
  static const String sendCommissionUrl = "/release/add";

  //或缺委托价格的接口
  static const String getAllPriceUrl = "/release/add/price";

  //高德地图天气接口
  static const String weatherUrl =
      "https://restapi.amap.com/v3/weather/weatherInfo";

  //分类请求委托
  static const String getTypeCommission = "/searchList_by_money_distance";

  //首页推荐委托
  static const String getRecommendCommission = "/search_by_distance";

  //搜索委托
  static const String searchCommission = "/search_list_by_order";

  //更改订单状态
  static const String changeOrderStatus = "/order/update/status";

  static const String CardNoAuthPath = "/keeper/identity/add";

  static const String IdCardFrontAuthPath = "/keeper/identity/identityByPic";

  //获取用户
  static const String searchUser = "/searchFriends";

  static const String getOrderByStatus = "/keeper/order";

  static const String getKeeperDataByUserId = "/keeper/info";
  static const String BannerPath = "/release/carousel";

   static const String keeperAvatarPath = "/keeper/upload/avatar";
   //上传证书
  static const String uploadCertificate = "/keeper/certificate/upload";
   //上传工作照
   static const String uploadWorkPicture = "/keeper/upload/picture";
   //删除工作照片
  static const String deleteWorkPicture = "/keeper/picture/delete";
  //上传评价图
  static const String uploadEvaluationPicture = "/commentPic/upload";
  //删除评价图
  static const String deleteEvaluationPicture = "/commentPic/delete";
   //更新家政员信息
  static const String updateKeeperInfo = "/keeper/update";
  //获取单个用户信息
  static const String getSignalUserInfo = "/searchUserById";
  //收藏家政员
  static const String collectKeeper = "/release/keeper/collection";
  //创建订单id
  static const String createOrderUrl = "/api/housekeeper/create-order";
  //获取订单url
  static const String getOrderStr = "/api/user/get-order-str" ;

  //ai 客服接口
  static const String aiCustomerServiceUrl = "/talk";

  //ai页获取委托列表接口
  static const String getAiCommissionList = "/getCommission";
  //获取已完成订单
  static const String getOrderCompleted = "/order/view/byYearMonth";

  //ai页获取家政员列表接口
  static const String getAiKeeperList = "/getKeeper";

  static const String uploadGroupAvatar = "/avatar/upload/groupAvatar";
}

