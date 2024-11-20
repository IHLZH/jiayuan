class UrlPath {
  static const String realBaseUrl = "http://192.168.3.32:9900/";

  static const String BaseUrl = "http://www.shinesuning.top:8080";

  static const String wangBaseUrl = "http://10.7.89.154:8080";

  static const String testBaseUrl = "http://10.7.89.171:8080";

  static const String yuwenBaseUrl = "http://192.168.153.44:8080";
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

  //图片上传接口
  static const String uploadAvatarUrl = "/profile/upload";

  //接取委托接口
  static const String receiveCommissionUrl = "/receive";

  //取消接取委托接口
  static const String cancelReceiveCommissionUrl = "/cancel_receive";

  //根据userId获取委托信息接口
  static const String getOrderInfoByUserIdUrl = "/order/view/list";

  //根据userId和status获取委托信息接口
  static const String getOrderInfoByUserIdAndStatusUrl = "/order/view/status";

  //订单状态更改接口
  static const String updateOrderStatusUrl = "/order/update/status";

  //发送委托的接口
  static const String sendCommissionUrl = "/release/add";

  //或缺委托价格的接口
  static const String getAllPriceUrl = "/release/add/price";

  //高德地图天气接口
  static const String weatherUrl = "https://restapi.amap.com/v3/weather/weatherInfo";

  //分类请求委托
  static const String getTypeCommission = "/searchList_by_money_distance";

  //首页推荐委托
  static const String getRecommendCommission = "/search_by_distance";

  //搜索委托
  static const String searchCommission = "/search_list_by_order";

  //更改订单状态
  static const String changeOrderStatus = "/order/update/status";

}
