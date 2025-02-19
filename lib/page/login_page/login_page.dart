import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/styles/app_colors.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';

import '../../http/dio_instance.dart';
import '../../http/url_path.dart';
import '../../repository/api/keeper_api.dart';
import '../../repository/model/user.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/constants.dart';
import '../../utils/sp_utils.dart';

bool isProduction = Constants.IS_Production;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Uint8List? captchaImage;
  TextEditingController _accountController =
      TextEditingController(text: Global.input);
  TextEditingController _passwordController =
      TextEditingController(text: Global.password);
  TextEditingController _captchaController = TextEditingController();
  FocusNode _accountFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _captchaFocusNode = FocusNode();
  bool _isPasswordVisible = false; // 新增变量，用于控制密码是否可见
  bool _isAgreed = false; // 新增变量，用于控制协议同意状态

  @override
  void initState() {
    super.initState();
    _loadInitialCaptcha();
    _accountFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _captchaFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _accountFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _captchaFocusNode.removeListener(_onFocusChange);
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    _captchaFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _loadInitialCaptcha() async {
    try {
      final response = await DioInstance.instance().get(
        path: UrlPath.captchaImageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      setState(() {
        captchaImage = response.data;
      });
      if (isProduction) print('Initial captcha loaded successfully.');
      if (isProduction) print("res : $response");
    } catch (e) {
      if (isProduction) print('Error loading initial captcha: $e');
      setState(() {
        captchaImage = null; // 设置为 null 表示无法获取验证码
      });
    }
  }

  void _reloadImage() async {
    try {
      final response = await DioInstance.instance().get(
        path: UrlPath.captchaImageUrl +
            "?timestamp=${DateTime.now().millisecondsSinceEpoch}",
        options: Options(responseType: ResponseType.bytes),
      );
      setState(() {
        captchaImage = response.data;
      });
    } catch (e) {
      if (isProduction) print('Error reloading captcha: $e');
      setState(() {
        captchaImage = null; // 设置为 null 表示无法获取验证码
      });
    }
  }

  void _jumpToTab() async {
    await Global.dbUtil!.open();

    //TODO:用户数据保存方法
    //await Global.dbUtil!.deleteAllByHelper('tbl_user');
    // await Global.dbUtil!.insertByHelper("tbl_user", Global.userTmp!.toMap());
    // if (Global.isLogin)
    //   await Global.dbUtil!.insertByHelper("tbl_user", Global.userInfo!.toMap());
    await Global.dbUtil!.close();

    RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.tab);
  }

  void _jumpToForgetPasswordPage() async {
    RouteUtils.pushForNamed(context, RoutePath.forgetPasswordCodePage);
  }

  void _jumpToRegisterPage() async {
    RouteUtils.pushForNamed(context, RoutePath.registerCheckCodePage);
  }

  void _jumpToPhoneLoginPage() async {
    RouteUtils.pushForNamed(context, RoutePath.phoneLoginPage);
  }

  void _jumpToEmailLoginPage() async {
    RouteUtils.pushForNamed(context, RoutePath.emailLoginPage);
  }

  Future<void> _login() async {
    final String captcha = _captchaController.text;
    final String account = _accountController.text;
    final String password = _passwordController.text;

    if (account.isEmpty) {
      showToast("账号不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (password.isEmpty) {
      showToast("密码不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (captcha.isEmpty) {
      showToast("验证码不能为空",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    if (!_isAgreed) {
      showToast("请先同意协议",
          position: ToastPosition.bottom, duration: Duration(seconds: 1));
      return;
    }

    final String url = UrlPath.loginUrl +
        "?countId=$account&password=$password" +
        "&captchaCode=$captcha";

    try {
      final response = await DioInstance.instance().post(path: url);
      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          final data = response.data;

          Global.isLogin = true;

          // 保存用户信息
          Global.userInfo = User.fromJson(data["data"]);
          Global.input = account;
          Global.password = password;

          // 保存token
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;

          //持久化
          await SpUtils.saveString("input", Global.input!);
          await SpUtils.saveString("password", Global.password!);
          await SpUtils.saveString("token", Global.token!);

          if (isProduction) print("userInfo: ${Global.userInfo.toString()}");
          if (isProduction) print("token: ${Global.token}");

          //获取家政员信息
          if ((Global.userInfo?.userType ?? 0) == 1) {
            await KeeperApi.instance.getKeeperDataByUserId();
          }

          //IM登录
          String userSig = response.data['message'];

          if (isProduction) print("userSig : $userSig");

          await ImChatApi.getInstance()
              .login(Global.userInfo!.userId.toString(), userSig);

          await ImChatApi.getInstance().setSelfInfo(
              Global.userInfo!.userId.toString(),
              Global.userInfo!.nickName,
              Global.userInfo!.userAvatar,
              Global.userInfo!.userSex,
              Global.userInfo!.userType);

          showToast("登陆成功", duration: Duration(seconds: 1));

          // 跳转
          _jumpToTab();
        } else {
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) print('Login failed: ${response}');
      }
    } catch (e) {
      if (isProduction) print('Error: $e');
    }
  }

  void _toggleAgreement() {
    setState(() {
      _isAgreed = !_isAgreed;
    });
  }

  void _showServiceAgreementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '服务协议',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18,color: AppColors.appColor),
          ),
          content: Container(height: 300,child: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: '家缘软件服务协议\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '一、总则\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 家缘软件（以下简称“本软件”）是由软件学院22级家缘开发组开发并提供的一款C2C家政委托软件，旨在为用户提供一个便捷、高效的家政服务交易平台。\n',
                  ),
                  TextSpan(
                    text: '2. 用户在注册、使用本软件前，请务必仔细阅读本协议，并同意遵守本协议的各项条款。一旦注册成功或使用本软件，即视为用户已完全理解并接受本协议的所有内容。\n\n',
                  ),
                  TextSpan(
                    text: '二、服务内容\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 本软件提供家政服务的发布、查询、预约、评价等功能，用户可根据需求选择相应的家政服务项目。\n',
                  ),
                  TextSpan(
                    text: '2. 用户应确保发布的服务信息真实、准确、完整，并遵守国家法律法规和本软件的相关规定。\n\n',
                  ),
                  TextSpan(
                    text: '三、用户账号\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 用户需通过手机号或其他有效方式进行注册，完成注册程序并通过身份认证的用户即成为正式用户。\n',
                  ),
                  TextSpan(
                    text: '2. 用户应妥善保管账号和密码，对因保管不善导致的账号被盗用、信息泄露等后果，本软件不承担任何责任。\n\n',
                  ),
                  TextSpan(
                    text: '四、使用规则\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 用户在使用本软件时，应遵守国家法律法规、社会公德和本软件的相关规定。\n',
                  ),
                  TextSpan(
                    text: '2. 用户不得利用本软件进行任何违法、违规或侵犯他人合法权益的行为。\n',
                  ),
                  TextSpan(
                    text: '3. 用户在使用本软件过程中，应尊重他人的知识产权和隐私权，不得发布或传播任何侵权内容。\n\n',
                  ),
                  TextSpan(
                    text: '五、费用支付\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 本软件提供的家政服务可能需要用户支付一定的费用，具体费用以服务详情页面为准。\n',
                  ),
                  TextSpan(
                    text: '2. 用户应按照服务详情页面的提示和指引完成费用支付，本软件不承担因用户未按时支付费用而产生的任何后果。\n\n',
                  ),
                  TextSpan(
                    text: '六、服务保障\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 本软件将尽力为用户提供优质、高效的家政服务，但不对服务的具体质量和效果作出任何保证或承诺。\n',
                  ),
                  TextSpan(
                    text: '2. 如用户在使用本软件过程中遇到任何问题或纠纷，应及时与本软件客服联系，本软件将积极协助用户解决问题。\n\n',
                  ),
                  TextSpan(
                    text: '七、责任声明\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 本软件不对用户在使用本软件过程中产生的任何直接、间接或附带性损害承担责任。\n',
                  ),
                  TextSpan(
                    text: '2. 如因不可抗力或其他本软件无法控制的原因导致本软件服务中断或无法正常使用，本软件不承担任何责任。\n\n',
                  ),
                  TextSpan(
                    text: '八、附则\n\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '1. 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。\n',
                  ),
                  TextSpan(
                    text: '2. 如本协议中的任何条款因某种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n',
                  ),
                  TextSpan(
                    text: '3. 本软件有权随时修改或终止本协议，而无需事先通知用户。用户在使用本软件时应及时关注本协议的更新情况。\n',
                  ),
                ],
              ),
            ),
          ),),
          actions: <Widget>[
            TextButton(
              child: Text('关闭',style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '家缘软件隐私协议',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: AppColors.appColor),
          ),
          content: Container(
            height: 300,
            child: SingleChildScrollView(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '家缘软件隐私协议\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '一、总则\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 尊重用户个人隐私信息是家缘软件的基本原则。本隐私协议旨在明确家缘软件如何收集、使用、存储和保护用户的个人信息。\n',
                    ),
                    TextSpan(
                      text: '2. 用户在注册、使用本软件前，请仔细阅读本隐私协议，并同意遵守本协议的各项条款。一旦注册成功或使用本软件，即视为用户已完全理解并接受本协议的所有内容。\n\n',
                    ),
                    TextSpan(
                      text: '二、信息收集\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 为向用户提供家政服务，本软件将收集用户的个人信息，包括但不限于姓名、手机号、身份证号、家庭住址等。\n',
                    ),
                    TextSpan(
                      text: '2. 用户应确保提供的个人信息真实、准确、完整，并同意本软件对个人信息进行存储和使用。\n\n',
                    ),
                    TextSpan(
                      text: '三、信息使用\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 本软件将使用用户的个人信息进行家政服务的匹配、预约、评价等功能，以提供更好的用户体验。\n',
                    ),
                    TextSpan(
                      text: '2. 在用户同意的前提下，本软件还可能将用户的个人信息用于市场调研、产品改进、个性化推荐等目的。\n',
                    ),
                    TextSpan(
                      text: '3. 本软件将采取技术措施和其他必要措施，确保用户个人信息安全，防止信息泄露、毁损或丢失。\n\n',
                    ),
                    TextSpan(
                      text: '四、信息披露\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 本软件不会向未经授权的第三方披露用户的个人信息，但以下情况除外：\n',
                    ),
                    TextSpan(
                      text: '- 根据法律法规规定或有权机关的指示提供用户个人信息；\n',
                    ),
                    TextSpan(
                      text: '- 用户自行向第三方公开其个人信息；\n',
                    ),
                    TextSpan(
                      text: '- 与本软件签订授权合作的单位或个人可以以合法合规的方式使用用户个人信息；\n',
                    ),
                    TextSpan(
                      text: '- 因黑客攻击、电脑病毒侵入等不可抗力事件导致用户个人信息泄露。\n\n',
                    ),
                    TextSpan(
                      text: '五、信息安全\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 本软件将采取必要的技术手段和管理措施，确保用户个人信息的安全。\n',
                    ),
                    TextSpan(
                      text: '2. 用户在使用本软件时，应注意保护自己的个人信息，避免在公共场合或不安全的网络环境下使用。\n\n',
                    ),
                    TextSpan(
                      text: '六、用户权利\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 用户有权查询、更正、删除自己的个人信息。如需行使这些权利，请联系本软件客服。\n',
                    ),
                    TextSpan(
                      text: '2. 用户有权要求本软件提供其个人信息的使用情况，并有权对本软件使用个人信息提出异议。\n\n',
                    ),
                    TextSpan(
                      text: '七、责任声明\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 本软件不对因用户个人信息泄露而产生的任何直接、间接或附带性损害承担责任。\n',
                    ),
                    TextSpan(
                      text: '2. 如因不可抗力或其他本软件无法控制的原因导致用户个人信息泄露，本软件不承担任何责任。\n\n',
                    ),
                    TextSpan(
                      text: '八、附则\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '1. 本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。\n',
                    ),
                    TextSpan(
                      text: '2. 如本协议中的任何条款因某种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n',
                    ),
                    TextSpan(
                      text: '3. 本软件有权随时修改或终止本协议，而无需事先通知用户。用户在使用本软件时应及时关注本协议的更新情况。\n',
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('关闭', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor2,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _jumpToTab,
            child: Text(
              "游客登录>",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "账号登录",
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        width: 350.w,
                        height: 600.h,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            TextField(
                              controller: _accountController,
                              focusNode: _accountFocusNode,
                              decoration: InputDecoration(
                                labelText: "账号",
                                labelStyle: TextStyle(
                                  color: _accountFocusNode.hasFocus
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: !_isPasswordVisible,
                                    // 控制密码是否可见
                                    decoration: InputDecoration(
                                      labelText: "密码",
                                      labelStyle: TextStyle(
                                        color: _passwordFocusNode.hasFocus
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _jumpToForgetPasswordPage,
                                  child: Text(
                                    "忘记密码",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              height: 50.h,
                              width: 250.w,
                              child: Row(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 50.h,
                                    child: GestureDetector(
                                      onTap: _reloadImage,
                                      child: captchaImage != null
                                          ? Image.memory(captchaImage!)
                                          : Center(
                                              child: Text("无法获取验证码",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                    ),
                                  ),
                                  SizedBox(width: 50.w),
                                  Container(
                                    width: 200.w,
                                    height: 50.h,
                                    child: TextField(
                                      controller: _captchaController,
                                      focusNode: _captchaFocusNode,
                                      decoration: InputDecoration(
                                        labelText: "验证码",
                                        labelStyle: TextStyle(
                                          color: _captchaFocusNode.hasFocus
                                              ? Theme.of(context).primaryColor
                                              : Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: _login,
                              child: Text('登录',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.r, vertical: 15.r),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 50.h,
                              width: 300.w,
                              child: Row(
                                children: [
                                  TextButton(
                                      onPressed: _jumpToRegisterPage,
                                      child: Text(
                                        "注册",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                  Expanded(child: SizedBox()),
                                  TextButton(
                                      onPressed: _jumpToPhoneLoginPage,
                                      child: Text(
                                        "使用手机验证码登录",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: 300.w,
                              child: Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  TextButton(
                                      onPressed: _jumpToEmailLoginPage,
                                      child: Text(
                                        "使用邮箱验证码登录",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40),
        child: Row(
          children: [
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: _toggleAgreement,
              child: Icon(
                _isAgreed
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline,
                color: _isAgreed ? Theme.of(context).primaryColor : Colors.grey,
                size: 25,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "我已阅读",
              style: TextStyle(
                color: _isAgreed ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
                onPressed: () {
                  _showServiceAgreementDialog(context);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(20, 20)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 2)),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.withOpacity(0.12); // 设置水波纹颜色
                      }
                      return null; // 默认情况下不显示水波纹
                    },
                  ),
                ),
                child: Text(
                  "《服务协议》",
                  style: TextStyle(
                    color: _isAgreed
                        ? Theme.of(context).primaryColor
                        : Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            TextButton(
                onPressed: () {
                  _showPrivacyPolicyDialog(context);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(20, 20)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 2)),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.withOpacity(0.12); // 设置水波纹颜色
                      }
                      return null; // 默认情况下不显示水波纹
                    },
                  ),
                ),
                child: Text(
                  "《隐私协议》",
                  style: TextStyle(
                    color: _isAgreed
                        ? Theme.of(context).primaryColor
                        : Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
