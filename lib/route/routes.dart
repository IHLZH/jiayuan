import 'package:flutter/material.dart';
import 'package:jiayuan/page/certified_page/cert/cert_certified_page.dart';
import 'package:jiayuan/page/certified_page/keeper/keeper_certified_page.dart';
import 'package:jiayuan/page/chat_page/conversation_page.dart';
import 'package:jiayuan/page/chat_page/create_group/create_group_page.dart';
import 'package:jiayuan/page/chat_page/friend_info/friend_info_page.dart';
import 'package:jiayuan/page/chat_page/friend_list/friend_list.dart';
import 'package:jiayuan/page/chat_page/group_info/group_info_page.dart';
import 'package:jiayuan/page/chat_page/group_info/invite_member_page.dart';
import 'package:jiayuan/page/commission_center_page/commission_center_page.dart';
import 'package:jiayuan/page/commission_center_page/order/order_page.dart';
import 'package:jiayuan/page/commission_page/detail/commission_detail_page.dart';
import 'package:jiayuan/page/commission_page/search/commission_search_page.dart';
import 'package:jiayuan/page/home_page/housekeepingScreening%20_page.dart';
import 'package:jiayuan/page/login_page/email_login_page.dart';
import 'package:jiayuan/page/login_page/forget_password_check_code_page.dart';
import 'package:jiayuan/page/login_page/forget_password_page.dart';
import 'package:jiayuan/page/login_page/forget_password_submit_page.dart';
import 'package:jiayuan/page/login_page/login_page.dart';
import 'package:jiayuan/page/order_page/order_change_page/order_chage_page.dart';
import 'package:jiayuan/page/order_page/order_detail_page/order_detail_page.dart';
import 'package:jiayuan/page/register_page/register_check_code_page.dart';
import 'package:jiayuan/page/register_page/register_password_submit_page.dart';
import 'package:jiayuan/page/search_user/user_info/user_info_page.dart';
import 'package:jiayuan/page/search_user/user_search_page.dart';
import 'package:jiayuan/page/start_page.dart';
import 'package:jiayuan/page/user_page/faq_page/faq_page.dart';
import 'package:jiayuan/page/user_page/setting_page/change_email_page/bind_email_page.dart';
import 'package:jiayuan/page/user_page/setting_page/change_email_page/change_email_page.dart';
import 'package:jiayuan/page/user_page/setting_page/change_email_page/check_email_page.dart';
import 'package:jiayuan/page/user_page/setting_page/setting_page.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/route/route_path.dart';

import '../page/ai_customer_service_page/ai_customer_service_page.dart';
import '../page/chat_page/chat/chat_page.dart';
import '../page/commission_center_page/certificates/certificate_page.dart';
import '../page/commission_center_page/comment/comment_page.dart';
import '../page/commission_center_page/personal_keeper_page/personal_keeper_page.dart';
import '../page/commission_center_page/wallet_center/wallet_center_page.dart';
import '../page/keeper_page/KeeperPage.dart';
import '../page/login_page/phone_login_page.dart';
import '../page/order_page/evaluation_page/evalutation_page.dart';
import '../page/order_page/order_page.dart';
import '../page/send_commission_page/send_commision_page.dart';
import '../page/tab_page/tab_page.dart';
import '../page/user_page/browser_history_page/browser_history_page.dart';
import '../page/user_page/keeper_collection/keeper_collection.dart';
import '../page/user_page/profile_edit_page/profile_edit_page.dart';
import '../page/user_page/setting_page/change_password_page/change_password_page.dart';
import '../page/user_page/setting_page/change_password_page/password_check_page.dart';
import '../page/user_page/setting_page/change_password_page/reset_password_page.dart';
import '../page/user_page/setting_page/change_phone_page/bind_phone_page.dart';
import '../page/user_page/setting_page/change_phone_page/change_phone_page.dart';
import '../page/user_page/setting_page/change_phone_page/check_phone_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //首页tab
      case RoutePath.tab:
        return pageRoute(const TabPage(), settings: settings);
      // 启动页
      case RoutePath.startPage:
        return pageRoute(StartPage());
      //账号密码登录页
      case RoutePath.loginPage:
        return pageRoute(LoginPage());
      // 邮箱验证码登录页
      case RoutePath.emailLoginPage:
        return pageRoute(EmailLoginPage());
      //手机号验证码登录页
      case RoutePath.phoneLoginPage:
        return pageRoute(PhoneLoginPage());
      // 忘记密码页（不用）
      case RoutePath.forgetPasswordPage:
        return pageRoute(ForgetPasswordPage());
      // 忘记密码验证码页
      case RoutePath.forgetPasswordCodePage:
        return pageRoute(ForgetPasswordCheckCodePage());
      // 忘记密码新密码页
      case RoutePath.forgetPasswordNewPasswordPage:
        final args = settings.arguments as Map<String, dynamic>;
        final input = args['input'] as String;
        final isEmail = args['isEmail'] as bool;
        return pageRoute(
            ForgetPasswordSubmitPage(input: input, isEmail: isEmail));
      //委托搜索页
      case RoutePath.commissionSearch:
        return pageRoute(CommissionSearchPage());
      //委托发布页
      case RoutePath.sendCommissionPage:
        return pageRoute(SendCommissionPage(id: 1));
      //注册验证码页
      case RoutePath.registerCheckCodePage:
        return pageRoute(RegisterCheckCodePage());
      //注册提交密码页
      case RoutePath.registerSubmitPasswordPage:
        final args = settings.arguments as Map<String, dynamic>;
        final input = args['input'] as String;
        final isEmail = args['isEmail'] as bool;
        return pageRoute(RegisterPasswordSubmitPage(
          input: input,
          isEmail: isEmail,
        ));
      //委托详情页
      case RoutePath.commissionDetail:
        return pageRoute(CommissionDetailPage(), settings: settings);
      //个人资料编辑页
      case RoutePath.profileEditPage:
        return pageRoute(ProfileEditPage());
      //订单页
      case RoutePath.orderPage:
        final args = settings.arguments as Map<String, dynamic>;
        final status = args['status'] as int;
        return pageRoute(OrderPage(
          status: status,
        ));
      //订单详情页
      case RoutePath.orderDetailPage:
        return pageRoute(OrderDetailPage());
      //订单信息修改页
      case RoutePath.orderChangePage:
        return pageRoute(OrderChangePage());
      //设置页
      case RoutePath.settingPage:
        return pageRoute(SettingPage());
      //更改邮箱页
      case RoutePath.changeEmailPage:
        return pageRoute(ChangeEmailPage());
      //邮箱绑定页
      case RoutePath.bindEmailPage:
        return pageRoute(BindEmailPage());
      //检验邮箱页
      case RoutePath.checkEmailPage:
        return pageRoute(CheckEmailPage());
      //更改手机号页
      case RoutePath.changePhonePage:
        return pageRoute(ChangePhonePage());
      //手机号绑定页
      case RoutePath.bindPhonePage:
        return pageRoute(BindPhonePage());
      //检验手机号页
      case RoutePath.checkPhonePage:
        return pageRoute(CheckPhonePage());
      //修改密码页
      case RoutePath.changePasswordPage:
        return pageRoute(ChangePasswordPage());
      //检验密码页
      case RoutePath.passwordCheckPage:
        return pageRoute(PasswordCheckPage());
      //重设密码页
      case RoutePath.resetPasswordPage:
        final args = settings.arguments as Map<String, dynamic>;
        final input = args['input'] as String;
        return pageRoute(ResetPasswordPage(input: input));
      //家政员个人页面
      case RoutePath.KeeperPage:
        final keeperId = settings.arguments as int;
        return pageRoute(Keeperpage(keeperId: keeperId));
      //家政员分类页
      case RoutePath.houseKeepingScreeningPage:
        return pageRoute(HouseKeepingScreeningPage());
      //委托中心页面
      case RoutePath.commissionCenter:
        return pageRoute(CommissionCenterPage());
      //浏览历史页面
      case RoutePath.browseHistoryPage:
        return pageRoute(BrowseHistoryPage());
      //委托中心页
      case RoutePath.commissionCenter:
        return pageRoute(CommissionCenterPage());
      //家政员认证页
      case RoutePath.keeperCertified:
        return pageRoute(KeeperCertifiedPage());
      //证书认证页
      case RoutePath.certCertified:
        return pageRoute(CertCertifiedPage());
      //委托中心订单页
      case RoutePath.centerOrder:
        return pageRoute(CenterOrderPage(), settings: settings);
      //服务完成后的评价页
      case RoutePath.evalutationPage:
        return pageRoute(EvalutationPage(), settings: settings);
      case RoutePath.personalKeeper:
        return pageRoute(PersonalKeeperPage());
      case RoutePath.conversationList:
        return pageRoute(ConversationPage());
      //我的证书页面
      case RoutePath.keeperCertificate:
        return pageRoute(CertificatePage());
      //家政员中心展示用户评论的页面
      case RoutePath.commentPage:
        final keeperId = settings.arguments as int?;
        return pageRoute(CommentPage(
          keeperId: keeperId!,
        ));
      case RoutePath.chatPage:
        return pageRoute(ChatPage(), settings: settings);
      // 用户搜索页
      case RoutePath.userSearchPage:
        return pageRoute(UserSearchPage());
      case RoutePath.friendList:
        return pageRoute(FriendList());
      // 用户资料页
      case RoutePath.userInfoPage:
        final arg = settings.arguments as Map<String, dynamic>;
        return pageRoute(UserInfoPage(user: arg['user'] as SearchUser));
      case RoutePath.friendInfo:
        return pageRoute(FriendInfoPage(), settings: settings);
      case RoutePath.keeperCollection:
        return pageRoute(KeeperCollectionPage());
      case RoutePath.createGroup:
        return pageRoute(CreateGroupPage());
      case RoutePath.groupInfo:
        return pageRoute(GroupInfoPage(), settings: settings);
      case RoutePath.inviteFriend:
        return pageRoute(InviteMemberPage());
      case RoutePath.aiCustomerService:
        return pageRoute(AiCustomerServicePage());
      case RoutePath.walletCenter:
        return pageRoute(WalletCenterPage());
      case RoutePath.faq:
        return pageRoute(FaqPage());
    }
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body:
                Center(child: Text('No route defined for ${settings.name}'))));
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
        builder: (context) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}
