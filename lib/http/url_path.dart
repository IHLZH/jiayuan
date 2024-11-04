class UrlPath {
  static const String BaseUrl = "http://192.168.242.236:8080";

  //账号登录获取图像验证码接口
  static const String captchaImageUrl="/code/image";

  //账号登录接口
  static const String loginUrl="/login/loginBoth";

  //邮箱获取验证码接口
  static const String getEmailCodeUrl="/sendEmailCode";

  //邮箱登录接口
  static const String loginWithEmailCodeUrl = "/login/email";

  //手机获取验证码接口
  static const String getPhoneCodeUrl="/sendSmsCode";

  //邮箱忘记密码检验验证码接口
  static const String checkPasswordEmailCodeUrl="/password/email";

  //手机忘记密码检验验证码接口
  static const String checkPasswordPhoneCodeUrl="/password/phone";

  //重置密码接口
  static const String resetPasswordUrl="/password/resetPassword";
}
