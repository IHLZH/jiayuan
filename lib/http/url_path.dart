class UrlPath {
  static const String realBaseUrl = "http://192.168.3.32:9900/";

  static const String BaseUrl = "http://10.7.89.247:8080";

  static const String testBaseUrl = "http://10.7.89.171:8080";

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

  //搜索委托接口
  static const String searchCommissionUrl = "/search";

  //搜索后根据距离筛选委托接口
  static const String searchCommissionByDistanceUrl = "/search_by_distance";

  //搜索后根据金额刷选委托接口
  static const String searchCommissionByMoneyUrl = "/search_by_money";

  //根据分类获取委托接口
  static const String getcommissionByTypeUrl = "/commission";

  //根据分类获取委托后根据距离筛选委托
  static const String getcommissionByTypeDistanceUrl =
      "/search_by_typeId_distance";

  //根据分类获取委托后根据金额筛选委托
  static const String getcommissionByTypeMoneyUrl = "/search_by_money_typeId";

  //接取委托接口
  static const String receiveCommissionUrl = "/receive";

  //取消接取委托接口
  static const String cancelReceiveCommissionUrl = "/cancel_receive";

  //根据userId和commissionId获取委托信息接口
  static const String getCommissionInfoByIdUrl = "/release/comissionByUserId";
}
