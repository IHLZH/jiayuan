class UrlPath {
  static const String BaseUrl = "http://10.7.89.94:8080";

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
}
