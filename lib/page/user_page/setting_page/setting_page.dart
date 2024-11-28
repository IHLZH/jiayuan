import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/repository/api/user_api.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common_ui/styles/app_colors.dart';

bool isProduction = Constants.IS_Production;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    String? lastSignalMessageID = null;

    Future<void> _test() async {
      // 获取当前日期
      DateTime now = DateTime.now();

      // 格式化日期为字符串，例如 "2024-11-20"
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}";

      String text = "🦌🦌🦌";
      ImChatApi.getInstance().sendTextMessage('21', text);
    }

    Future<void> _receiveTest() async {
      List<V2TimConversation?> conversationList =
          await ImChatApi.getInstance().getConversationList('0', 20);
      for (var item in conversationList) {
        print(
            "id: ${item?.conversationID} ==== groupID: ${item?.groupID} ==== groupType: ${item?.groupType} ==== 未读数: ${item?.unreadCount} ==== 展示名: ${item?.showName} ==== 对方ID: ${item?.userID}}");
      }
    }

    Future<void> _receiveSignalTest() async {
      V2TimConversation? conversation =
          await ImChatApi.getInstance().getConversation("c2c_19");
      print(
          "id: ${conversation?.conversationID} ==== groupID: ${conversation?.groupID} ==== groupType: ${conversation?.groupType} ==== 未读数: ${conversation?.unreadCount} ==== 展示名: ${conversation?.showName} ==== 对方ID: ${conversation?.userID}}");
    }

    Future<void> _getSignalConversationMessage() async {
      List<V2TimMessage>? messageList = await ImChatApi.getInstance()
          .getHistorySignalMessageList('21', 100, lastSignalMessageID);

      for (var item in messageList!) {
        print(
            "id: ${item.msgID} ==== 消息类型: ${item.elemType} ==== 消息内容: ${item.textElem?.text}");
        lastSignalMessageID = item.msgID;
      }
    }

    Future<void> _clearSignalMessage() async {
      await ImChatApi.getInstance().clearSignalMessage('21');
    }

    Future<void> _searchUser() async {
      await UserApi.instance.getSignalUser(1);
    }

    Future<void> _getFriendsList() async {
      await ImChatApi.getInstance().getFriendList();
    }

    Future<void> _addMyFriend() async {
      await ImChatApi.getInstance().addFriend('19', 'ikun');
    }

    Future<void> _jumpToChangeEmailPage() async {
      RouteUtils.pushForNamed(context, RoutePath.changeEmailPage);
    }

    Future<void> _jumpToChangePhonePage() async {
      RouteUtils.pushForNamed(context, RoutePath.changePhonePage);
    }

    Widget _buildOption(IconData icon, String title, {VoidCallback? onCheck}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            switch (title) {
              case '邮箱地址':
                _jumpToChangeEmailPage();
                break;
              case '手机号码':
                _jumpToChangePhonePage();
                break;
              case '修改密码':
                break;
              case '发送给喜多郁代':
                _test();
                break;
              case '拉取所有会话列表':
                _receiveTest();
                break;
              case '拉取单聊会话':
                _receiveSignalTest();
                break;
              case '拉取和喜多的单聊历史信息':
                _getSignalConversationMessage();
                break;
              case '清空和喜多的聊天':
                _clearSignalMessage();
                break;
              case '搜索用户':
                _searchUser();
                break;
              case '获得好友列表':
                _getFriendsList();
                break;
              case '添加好友':
                _addMyFriend();
                break;
              default:
                break;
            }
          },
          splashColor: Colors.grey[300],
          highlightColor: Theme.of(context).primaryColor.withAlpha(30),
          child: ListTile(
            leading: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    AppColors.appColor,
                  ],
                ).createShader(bounds);
              },
              child: Icon(icon, color: Colors.white),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      );
    }

    Widget _line() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.r),
        child: Divider(
          height: 2.h,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // 使用 Container 包裹 AppBar 以实现渐变背景
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.appColor,
                AppColors.endDeepColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text('设置',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            RouteUtils.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10.r),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              child: Column(
                children: [
                  _buildOption(Icons.email_outlined, '邮箱地址'),
                  _line(),
                  _buildOption(Icons.phone, '手机号码'),
                  _line(),
                  _buildOption(Icons.lock, '修改密码'),
                  // _line(),
                  // _buildOption(Icons.send_outlined, '发送给喜多郁代'),
                  // _line(),
                  // _buildOption(Icons.record_voice_over_outlined, '拉取所有会话列表'),
                  // _line(),
                  // _buildOption(Icons.record_voice_over_outlined, '拉取单聊会话'),
                  // _line(),
                  // _buildOption(
                  //     Icons.record_voice_over_outlined, '拉取和喜多的单聊历史信息'),
                  // _line(),
                  // _buildOption(Icons.cleaning_services_rounded, '清空和喜多的聊天'),
                  // _line(),
                  // _buildOption(Icons.search, '搜索用户'),
                  // _line(),
                  // _buildOption(Icons.search, '获得好友列表'),
                  // _line(),
                  // _buildOption(Icons.person_add_alt, '添加好友'),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
