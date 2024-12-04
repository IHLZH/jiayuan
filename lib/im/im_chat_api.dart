import 'package:jiayuan/page/chat_page/chat/chat_page_vm.dart';
import 'package:jiayuan/page/chat_page/conversation_page_vm.dart';
import 'package:jiayuan/page/chat_page/friend_list/friend_list_vm.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimConversationListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_application_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_response_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/friend_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_add_opt_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_search_param.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_change_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_operation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_full_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_user_status.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

bool isProduction = Constants.IS_Production;

//登录
// ImChatApi.getInstance().login("19",
//     "eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwoaWUNHilOzEgoLMFCUrQzMDAwMzQ1MTE4hMakVBZlEqUNzU1NQIKAURLcnMBYmZGwOFzIzNoKLFmekgQ7WzkqP8LdOSM5yTjQvNCkLKS6Is0sNKXfy1C01NSrPN-NO9HF3SAkwjy22VagElwy93");

//获取用户信息
// ImChatApi.getInstance().getUsersInfo(['19']);

//修改用户信息
// ImChatApi.getInstance()
//     .setSelfInfo('19', 'ikunhuaji', 'www.ikun.jpg', 1, 0);

//修改2
// ImChatApi.getInstance().setSelfInfo('19', 'null', 'www.null.jpg', 2, 1);

//发送单聊文本消息
// ImChatApi.getInstance().sendTextMessage(receiverID, text);//分别为接收人ID和文本

//获取会话列表 分页
// List<V2TimConversation?> conversationList = await ImChatApi.getInstance().getConversationList('0', 20);

//获取特定会话信息
// 若为单聊，格式为 c2c_${userID} , 群聊为 group_${groupID}
// V2TimConversation? conversation = await ImChatApi.getInstance().getConversation("c2c_21");

//获取指定单聊的历史信息 分页，endID为分页结尾msgID,保证能继续拉取
//单聊ID 格式为 ${userID}
// List<V2TimMessage>? messageList = await ImChatApi.getInstance().getHistorySignalMessageList(ID, pageSize,endID);

//清空聊天记录
// await ImChatApi.getInstance().clearSignalMessage(userID);

class ImChatApi {
  // 私有化构造函数
  ImChatApi._();

  // 静态私有实例
  static ImChatApi _instance = ImChatApi._();

  // 静态方法获取实例
  static ImChatApi getInstance() {
    return _instance;
  }

  // 监听器
  V2TimSDKListener? sdkListener; //sdk监听器
  V2TimFriendshipListener? friendshipListener; //关系监听器
  V2TimAdvancedMsgListener? advancedMsgListener; //高级消息监听器
  V2TimConversationListener? conversationListener; //会话监听器
  V2TimGroupListener? groupListener; //群组监听器

  Future<void> initSDK() async {
    // 1. 从即时通信 IM 控制台获取应用 SDKAppID。
    int sdkAppID = 1600061544;
    // 2. 添加 V2TimSDKListener 的事件监听器，sdkListener 是 V2TimSDKListener 的实现类
    sdkListener = V2TimSDKListener(
      onConnectFailed: (int code, String error) {
        // 连接失败的回调函数
        // code 错误码
        // error 错误信息

        if (isProduction)
          print("============= 连接失败的回调函数 错误码 $code,错误信息 $error ============");
      },
      onConnectSuccess: () {
        // SDK 已经成功连接到腾讯云服务器
        if (isProduction) print("============= SDK 已经成功连接到腾讯云服务器 ============");
      },
      onConnecting: () {
        // SDK 正在连接到腾讯云服务器
        if (isProduction) print("============= SDK 正在连接到腾讯云服务器 ============");
      },
      onKickedOffline: () {
        // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
        if (isProduction)
          print("当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。");

        showToast("其他设备登录当前账户", duration: Duration(seconds: 2));
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        // 登录用户的资料发生了更新
        // info登录用户的资料
        if (isProduction) print("============= 登录用户的资料发生了更新 ============");
      },
      onUserSigExpired: () {
        // 在线时票据过期：此时您需要生成新的 userSig 并再次调用 V2TIMManager 的 login() 函数重新登录。
        if (isProduction) print("票据过期");
      },
      onUserStatusChanged: (List<V2TimUserStatus> userStatusList) {
        // 用户状态变更通知
        // userStatusList 用户状态变化的用户列表
        // 收到通知的情况：订阅过的用户发生了状态变更（包括在线状态和自定义状态），会触发该回调
        // 在 IM 控制台打开了好友状态通知开关，即使未主动订阅，当好友状态发生变更时，也会触发该回调
        // 同一个账号多设备登录，当其中一台设备修改了自定义状态，所有设备都会收到该回调

        if (isProduction) print("用户状态变更通知");
      },
    );
    // 3. 初始化SDK
    V2TimValueCallback<bool> initSDKRes =
        await TencentImSDKPlugin.v2TIMManager.initSDK(
      sdkAppID: sdkAppID, // SDKAppID
      loglevel: LogLevelEnum.V2TIM_LOG_DEBUG, // 日志登记等级
      listener: sdkListener!, // 事件监听器
    );
    if (initSDKRes.code == 0) {
      // 初始化成功
      if (isProduction) print("============= IM SDK 初始化成功 ============");
    }
  }

  Future<void> login(String userID, String userSig) async {
    V2TimCallback loginRes = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userID, userSig: userSig);
    if (loginRes.code == 0) {
      // 登录成功逻辑
      if (isProduction)
        print("============= IM登录成功 UserID: $userID ============");

      // 消息监听
      // 设置高级消息监听器
      // 创建消息监听器
      advancedMsgListener = V2TimAdvancedMsgListener(
        onRecvC2CReadReceipt: (List<V2TimMessageReceipt> receiptList) {
          //单聊已读回调
          if (isProduction) print("============单聊已读回调==========");
        },
        onRecvMessageModified: (V2TimMessage message) {
          // msg 为被修改之后的消息对象
        },
        onRecvMessageReadReceipts: (List<V2TimMessageReceipt> receiptList) {
          //群聊已读回调
          receiptList.forEach((element) {
            element.groupID; // 群id
            element.msgID; // 已读回执消息 ID
            element.readCount; // 群消息最新已读数
            element.unreadCount; // 群消息最新未读数
            element.userID; //  C2C 消息对方 ID
          });
        },
        onRecvMessageRevoked: (String messageid) {
          // 在本地维护的消息中处理被对方撤回的消息
          if (isProduction) print("============撤回消息： $messageid=========");
          // ConversationPageViewModel.instance.initConversationList();
        },
        onRecvNewMessage: (V2TimMessage message) async {
          //ConversationPageViewModel.instance.onRefresh();
          // 处理文本消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
            String? text = message.textElem!.text;

            if (isProduction) print("============获得新消息： ${text}=========");

            if ((ChatPageViewModel.instance.conversation != null &&
                    message.userID != null &&
                    message.userID ==
                        ChatPageViewModel.instance.conversation!.userID) ||
                (ChatPageViewModel.instance.conversation != null &&
                    message.groupID != null &&
                    message.groupID ==
                        ChatPageViewModel.instance.conversation!.groupID)) {
              if (isProduction) {
                print(
                    "============ ID: ${message.userID ?? message.groupID} =========");
              }
              await ChatPageViewModel.instance.refreshChatMessage();
            }
          }
          // 使用自定义消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
            message.customElem?.data;
            message.customElem?.desc;
            message.customElem?.extension;
          }
          // 使用图片消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_IMAGE) {
            message.imageElem
                ?.path; // 图片上传时的路径，消息发送者才会有这个字段，消息发送者可用这个字段将图片预先上屏，优化上屏体验。
            message.imageElem?.imageList?.forEach((element) {
              // 遍历大图、原图、缩略图
              // 解析图片属性
              element?.height;
              element?.localUrl;
              element?.size;
              element?.type; // 大图 缩略图 原图
              element?.url;
              element?.uuid;
              element?.width;
            });
          }
          // 处理视频消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_VIDEO) {
            // 解析视频消息属性，封面、播放地址、宽高、大小等。
            message.videoElem?.UUID;
            message.videoElem?.duration;
            message.videoElem?.localSnapshotUrl;
            message.videoElem?.localVideoUrl;
            message.videoElem?.snapshotHeight;
            message.videoElem?.snapshotPath;
            // ...
          }
          // 处理音频消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_SOUND) {
            // 解析语音消息 播放地址，本地地址，大小，时长等。
            message.soundElem?.UUID;
            message.soundElem?.dataSize;
            message.soundElem?.duration;
            message.soundElem?.localUrl;
            message.soundElem?.url;
            // ...
          }
          // 处理文件消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FILE) {
            // 解析文件消息 文件名、文件大小、url等
            message.fileElem?.UUID;
            message.fileElem?.fileName;
            message.fileElem?.fileSize;
            message.fileElem?.localUrl;
            message.fileElem?.path;
            message.fileElem?.url;
          }
          // 处理位置消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_LOCATION) {
            // 解析地理位置消息，经纬度、描述等
            message.locationElem?.desc;
            message.locationElem?.latitude;
            message.locationElem?.longitude;
          }
          // 处理表情消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_FACE) {
            message.faceElem?.data;
            message.faceElem?.index;
          }
          // 处理群组tips文本消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS) {
            message.groupTipsElem?.groupID; // 所属群组
            message.groupTipsElem?.type; // 群Tips类型
            message.groupTipsElem?.opMember; // 操作人资料
            message.groupTipsElem?.memberList; // 被操作人资料
            message.groupTipsElem?.groupChangeInfoList; // 群信息变更详情
            message.groupTipsElem?.memberChangeInfoList; // 群成员变更信息
            message.groupTipsElem?.memberCount; // 当前群在线人数
          }
          // 处理合并消息消息
          if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_MERGER) {
            message.mergerElem?.abstractList;
            message.mergerElem?.isLayersOverLimit;
            message.mergerElem?.title;
            V2TimValueCallback<List<V2TimMessage>> download =
                await TencentImSDKPlugin.v2TIMManager
                    .getMessageManager()
                    .downloadMergerMessage(
                      msgID: message.msgID!,
                    );
            if (download.code == 0) {
              List<V2TimMessage>? messageList = download.data;
            }
          }
          if (message.textElem?.nextElem != null) {
            //通过第一个 Elem 对象的 nextElem 方法获取下一个 Elem 对象，如果下一个 Elem 对象存在，会返回 Elem 对象实例，如果不存在，会返回 null。
          }
        },
        onSendMessageProgress: (V2TimMessage message, int progress) {
          //文件上传进度回调
        },
      );
      // 添加高级消息的事件监听器
      TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .addAdvancedMsgListener(listener: advancedMsgListener!);
      if (isProduction) print("============= IM添加高级消息监听器成功 ============");

      //获取信息

      // 会话监听
      //设置会话监听器
      conversationListener = V2TimConversationListener(
        onConversationChanged:
            (List<V2TimConversation> conversationList) async {
          //某些会话的关键信息发生变化（未读计数发生变化、最后一条消息被更新等等）的回调函数
          //conversationList    变化的会话列表
          if (isProduction) print("============ 会话列表发生变化 ===========");
          await ConversationPageViewModel.instance.initConversationList();
        },
        onConversationGroupCreated:
            (String groupName, List<V2TimConversation> conversationList) {
          // 会话分组被创建
          // groupName 会话分组名称
          // conversationList 会话分组包含的会话列表
        },
        onConversationGroupDeleted: (String groupName) {
          // 会话分组被删除
          // groupName  被删除的会话分组名称
        },
        onConversationGroupNameChanged: (String oldName, String newName) {
          // 会话分组名变更
          // oldName 旧名称
          // newName 新名称
        },
        onConversationsAddedToGroup:
            (String groupName, List<V2TimConversation> conversationList) {
          // 会话分组新增会话
          // groupName 会话分组名称
          // conversationList 被加入会话分组的会话列表
        },
        onConversationsDeletedFromGroup:
            (String groupName, List<V2TimConversation> conversationList) {
          // 会话分组删除会话
          // groupName 会话分组名称
          // conversationList 被删除的会话列表
        },
        onNewConversation: (List<V2TimConversation> conversationList) {
          // 新会话的回调函数
          // conversationList 收到的新会话列表
        },
        onSyncServerFailed: () {
          // 同步服务失败的回调函数
        },
        onSyncServerFinish: () {
          // 同步服务完成的回调函数
        },
        onSyncServerStart: () {
          // 同步服务开始的回调函数
        },
        onTotalUnreadMessageCountChanged: (int totalUnreadCount) {
          // 会话未读总数改变的回调函数
          // totalUnreadCount 会话未读总数
        },
      );
      TencentImSDKPlugin.v2TIMManager
          .getConversationManager()
          .addConversationListener(listener: conversationListener!);
      if (isProduction) print("============= IM添加会话监听器成功 ============");

      //关系监听
      //设置关系链监听器
      friendshipListener = V2TimFriendshipListener(
        onBlackListAdd: (List<V2TimFriendInfo> infoList) async {
          //黑名单列表新增用户的回调
          //infoList 新增的用户信息列表
        },
        onBlackListDeleted: (List<String> userList) async {
          //黑名单列表删除的回调
          //userList 被删除的用户id列表
        },
        onFriendApplicationListAdded:
            (List<V2TimFriendApplication> applicationList) async {
          //好友请求数量增加的回调
          //applicationList 新增的好友请求信息列表
          if (isProduction) print("=========== 好友请求数量增加的回调 ============");
        },
        onFriendApplicationListDeleted: (List<String> userIDList) async {
          //好友请求数量减少的回调
          //减少的好友请求的请求用户id列表、
          if (isProduction) print("=========== 好友请求数量减少的回调 ============");
        },
        onFriendApplicationListRead: () async {
          //好友请求已读的回调
          if (isProduction) print("=========== 好友请求已读的回调 ============");
        },
        onFriendInfoChanged: (List<V2TimFriendInfo> infoList) async {
          //好友信息改变的回调
          //infoList 好友信息改变的好友列表
          if (isProduction) print("=========== 好友信息改变的回调 ============");
          await FriendListViewModel.instance.getFriendList();
        },
        onFriendListAdded: (List<V2TimFriendInfo> users) async {
          //好友列表增加人员的回调
          //users 新增的好友信息列表
          if (isProduction) print("=========== 好友列表增加人员的回调 ============");
        },
        onFriendListDeleted: (List<String> userList) async {
          //好友列表减少人员的回调
          //userList 减少的好友id列表
          if (isProduction) print("=========== 好友列表减少人员的回调 ============");
        },
      );
      TencentImSDKPlugin.v2TIMManager
          .getFriendshipManager()
          .addFriendListener(listener: friendshipListener!); //添加关系链监听器

      if (isProduction && friendshipListener != null)
        print("============= IM设置关系链监听器成功 ============");

      //设置群组监听器
      groupListener = V2TimGroupListener(
        onApplicationProcessed: (String groupID, V2TimGroupMemberInfo opUser,
            bool isAgreeJoin, String opReason) async {
          //加群请求已经被群主或管理员处理了（只有申请人能够收到）
          //groupID    群 ID
          //opUser    处理人
          //isAgreeJoin    是否同意加群
          //opReason    处理原因
        },
        onGrantAdministrator: (String groupID, V2TimGroupMemberInfo opUser,
            List<V2TimGroupMemberInfo> memberList) async {
          //指定管理员身份
          //groupID    群 ID
          //opUser    处理人
          //memberList    被处理的群成员
        },
        onGroupAttributeChanged:
            (String groupID, Map<String, String> groupAttributeMap) async {
          //收到群属性更新的回调
          //groupID    群 ID
          //groupAttributeMap    群的所有属性
        },
        onGroupCreated: (String groupID) async {
          //创建群（主要用于多端同步）
          //groupID    群 ID
        },
        onGroupDismissed: (String groupID, V2TimGroupMemberInfo opUser) async {
          //群被解散了（全员能收到）
          //groupID    群 ID
          //opUser    处理人
        },
        onGroupInfoChanged:
            (String groupID, List<V2TimGroupChangeInfo> changeInfos) async {
          //群信息被修改（全员能收到）
          //groupID    群 ID
          //changeInfos    修改的群信息
        },
        onGroupRecycled: (String groupID, V2TimGroupMemberInfo opUser) async {
          //群被回收（全员能收到）
          //groupID    群 ID
          //opUser    处理人
        },
        onMemberEnter:
            (String groupID, List<V2TimGroupMemberInfo> memberList) async {
          //有用户加入群（全员能够收到）
          //groupID    群 ID
          //memberList    加入的成员
        },
        onMemberInfoChanged: (String groupID,
            List<V2TimGroupMemberChangeInfo>
                v2TIMGroupMemberChangeInfoList) async {
          //群成员信息被修改，仅支持禁言通知（全员能收到）。
          //groupID    群 ID
          //v2TIMGroupMemberChangeInfoList    被修改的群成员信息
        },
        onMemberInvited: (String groupID, V2TimGroupMemberInfo opUser,
            List<V2TimGroupMemberInfo> memberList) async {
          //某些人被拉入某群（全员能够收到）
          //groupID    群 ID
          //opUser    处理人
          //memberList    被拉进群成员

          if (isProduction) print("=========== 有用户加入群 ============");

          if (isProduction) {
            memberList.forEach((element) {
              print("=========== 用户 ${element.userID} 被拉入某群 ============");
            });
          }
        },
        onMemberKicked: (String groupID, V2TimGroupMemberInfo opUser,
            List<V2TimGroupMemberInfo> memberList) async {
          //某些人被踢出某群（全员能够收到）
          //groupID    群 ID
          //opUser    处理人
          //memberList    被踢成员
        },
        onMemberLeave: (String groupID, V2TimGroupMemberInfo member) async {
          //有用户离开群（全员能够收到）
          //groupID    群 ID
          //member    离开的成员
        },
        onQuitFromGroup: (String groupID) async {
          //主动退出群组（主要用于多端同步，直播群（AVChatRoom）不支持）
          //groupID    群 ID
        },
        onReceiveJoinApplication: (String groupID, V2TimGroupMemberInfo member,
            String opReason) async {
          //有新的加群请求（只有群主或管理员会收到）
          //groupID    群 ID
          //member    申请人
          //opReason    申请原因
        },
        onReceiveRESTCustomData: (String groupID, String customData) async {
          //收到 RESTAPI 下发的自定义系统消息
          //groupID    群 ID
          //customData    自定义数据
        },
        onRevokeAdministrator: (String groupID, V2TimGroupMemberInfo opUser,
            List<V2TimGroupMemberInfo> memberList) async {
          //取消管理员身份
          //groupID    群 ID
          //opUser    处理人
          //memberList    被处理的群成员
        },
      );
      //添加群组监听器
      TencentImSDKPlugin.v2TIMManager
          .addGroupListener(listener: groupListener!);

      if (isProduction && groupListener != null)
        print("============= IM设置群组监听器成功 ============");
    } else {
      // 登录失败逻辑
      if (isProduction) print("登录失败");
      if (isProduction) print("错误码: ${loginRes.code} 错误信息: ${loginRes.desc}");
    }
  }

  Future<void> logout() async {
    // 在用户登陆成功之后可调用
    // 调用logout登出当前用户账号
    V2TimCallback logoutRes = await TencentImSDKPlugin.v2TIMManager.logout();
    if (logoutRes.code == 0) {
      // 登出成功的逻辑
      if (isProduction) print("============= IM登出成功 ============");

      //移除关系链监听器
      //添加成功之后可移除
      TencentImSDKPlugin.v2TIMManager
          .getFriendshipManager()
          .removeFriendListener(listener: friendshipListener!); //需要移除的关系链监听器

      if (isProduction) print("============= IM移除关系链监听器成功 ============");

      //移除消息监听器
      TencentImSDKPlugin.v2TIMManager
          .getMessageManager()
          .removeAdvancedMsgListener(listener: advancedMsgListener);

      if (isProduction) print("============= IM移除消息监听器成功 ============");

      //移除会话监听器
      TencentImSDKPlugin.v2TIMManager
          .getConversationManager()
          .removeConversationListener(listener: conversationListener!);
      if (isProduction) print("============= IM移除会话监听器成功 ============");

      TencentImSDKPlugin.v2TIMManager
          .removeGroupListener(listener: groupListener);
      if (isProduction) print("============= IM移除群组监听器成功 ============");
    } else {
      if (isProduction) print("============= IM登出失败 ============");
      if (isProduction) print("错误码: ${logoutRes.code} 错误信息: ${logoutRes.desc}");
    }
  }

  Future<V2TimUserFullInfo> getUsersInfo(String userID) async {
    //获取用户资料
    V2TimValueCallback<List<V2TimUserFullInfo>> getUsersInfoRes =
        await TencentImSDKPlugin.v2TIMManager
            .getUsersInfo(userIDList: [userID]); //需要查询的用户id
    if (getUsersInfoRes.code == 0) {
      // 查询成功
      getUsersInfoRes.data?.forEach((element) {
        element.allowType; //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
        element.birthday; //用户生日
        element.customInfo; //用户的自定义状态
        element.faceUrl; //用户头像 url
        element.gender; //用户的性别 1:男 2:女
        element.level; //用户的等级
        element.nickName; //用户昵称
        element.role; //用户的角色
        element.selfSignature; //用户的签名
        element.userID; //用户 ID
      });

      if (isProduction) print("============== 查询成功 ===========");
      // if (isProduction) {
      //   print(
      //       "usersInfo: ID:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.userID}");
      //   print(
      //       "性别:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.gender}");
      //   print(
      //       "角色:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.role}");
      //   print(
      //       "昵称:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.nickName}");
      //   print(
      //       "等级:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.level}");
      //   print(
      //       "生日:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.birthday}");
      // }

      return getUsersInfoRes.data!.first;
    } else {
      if (isProduction) print("============= IM查询失败 ============");
      if (isProduction)
        print("错误码: ${getUsersInfoRes.code} 错误信息: ${getUsersInfoRes.desc}");
      throw Exception("查询失败");
    }
  }

  Future<void> setSelfInfo(String userID, String nickName, String userAvatar,
      int userSex, int userType) async {
    //用户资料设置信息
    V2TimUserFullInfo userFullInfo = V2TimUserFullInfo(
      nickName: nickName,
      // 用户昵称
      // allowType: 0,
      //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
      // birthday: 0,
      //用户生日
      faceUrl: userAvatar,
      //用户头像 url
      gender: userSex,
      //用户的性别 1:男 2:女
      // level: 0,
      //用户的等级
      role: userType,
      //用户的角色
      // selfSignature: "",
      //用户的签名
      userID: userID, //用户 ID
    );
    V2TimCallback setSelfInfoRes = await TencentImSDKPlugin.v2TIMManager
        .setSelfInfo(userFullInfo: userFullInfo); //用户资料设置信息
    if (setSelfInfoRes.code == 0) {
      // 修改成功
      if (isProduction) print("============= IM修改成功 ============");
    } else {
      // 修改失败
      if (isProduction)
        print("修改失败，错误码: ${setSelfInfoRes.code}, 错误信息: ${setSelfInfoRes.desc}");
    }
  }

  //设置好友验证方式
  Future<void> setFriendAllowType(int allowType) async {
    //用户资料设置信息
    V2TimUserFullInfo userFullInfo = V2TimUserFullInfo(
      // nickName: nickName,
      // 用户昵称
      allowType: allowType,
      //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
      // birthday: 0,
      //用户生日
      // faceUrl: userAvatar,
      //用户头像 url
      // gender: userSex,
      //用户的性别 1:男 2:女
      // level: 0,
      //用户的等级
      // role: userType,
      //用户的角色
      // selfSignature: "",
      //用户的签名
      // userID: userID, //用户 ID
    );

    V2TimCallback setSelfInfoRes = await TencentImSDKPlugin.v2TIMManager
        .setSelfInfo(userFullInfo: userFullInfo); //用户资料设置信息
    if (setSelfInfoRes.code == 0) {
      // 修改成功
      if (isProduction) print("============= IM修改好友验证方式成功 ============");
    } else {
      // 修改失败
      if (isProduction)
        print("修改失败，错误码: ${setSelfInfoRes.code}, 错误信息: ${setSelfInfoRes.desc}");
    }
  }

  //单聊发送文本消息
  Future<void> sendTextMessage(String receiverID, String text) async {
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextMessage(
              text: text, // 文本信息
            );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;

      if (isProduction) print("============= 文本信息创建成功 id: ${id} ============");
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin
          .v2TIMManager
          .getMessageManager()
          .sendMessage(id: id!, receiver: receiverID, groupID: '');
      if (sendMessageRes.code == 0) {
        // 发送成功
        if (isProduction) print("============= 发送成功 => ${text} ============");
      } else {
        if (isProduction)
          print(
              "发送失败，错误码: ${sendMessageRes.code}, 错误信息: ${sendMessageRes.desc}");
      }
    }
  }

  //群聊发送文本消息
  Future<void> sendGroupTextMessage(String groupID, String text) async {
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .createTextMessage(
              text: text, // 文本信息
            );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes = await TencentImSDKPlugin
          .v2TIMManager
          .getMessageManager()
          .sendMessage(id: id!, receiver: "", groupID: groupID);
      if (sendMessageRes.code == 0) {
        // 发送成功
      }
    }
  }

  //单聊发送
  //分页拉取会话
  Future<List<V2TimConversation?>> getConversationList(
      String index, int pageSize) async {
    //获取会话列表
    V2TimValueCallback<V2TimConversationResult> getConversationListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversationList(
                count: pageSize, //分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
                nextSeq: index //分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
                );
    if (getConversationListRes.code == 0) {
      //拉取成功
      bool? isFinished = getConversationListRes.data?.isFinished; //是否拉取完
      String? nextSeq = getConversationListRes.data?.nextSeq; //后续分页拉取的游标
      List<V2TimConversation?>? conversationList =
          getConversationListRes.data?.conversationList; //此次拉取到的消息列表
      //如果没有拉取完，使用返回的nextSeq继续拉取直到isFinished为true
      if (!isFinished!) {
        V2TimValueCallback<V2TimConversationResult> nextConversationListRes =
            await TencentImSDKPlugin.v2TIMManager
                .getConversationManager()
                .getConversationList(
                    count: pageSize,
                    nextSeq: nextSeq =
                        index); //使用返回的nextSeq继续拉取直到isFinished为true
      }

      if (isProduction) print("=========== 拉取会话列表成功 ===========");

      getConversationListRes.data?.conversationList?.forEach((element) {
        element
            ?.conversationID; //会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
        element?.draftText; //草稿信息
        element?.draftTimestamp; //草稿编辑时间，草稿设置的时候自动生成。
        element?.faceUrl; //会话展示头像，群聊头像：群头像；单聊头像：对方头像。
        element?.groupAtInfoList; //群会话 @ 信息列表，通常用于展示 “有人@我” 或 “@所有人” 这两种提醒状态。
        element?.groupID; //当前群聊 ID，如果会话类型为群聊，groupID 会存储当前群的群 ID，否则为 null。
        element?.groupType; //当前群聊类型，如果会话类型为群聊，groupType 为当前群类型，否则为 null。
        element?.isPinned; //会话是否置顶
        element?.lastMessage; //会话最后一条消息
        element?.orderkey; //会话排序字段
        element?.recvOpt; //消息接收选项
        element
            ?.showName; //会话展示名称，群聊会话名称优先级：群名称 > 群 ID；单聊会话名称优先级：对方好友备注 > 对方昵称 > 对方的 userID。
        element?.type; //会话类型，分为 C2C（单聊）和 Group（群聊）。
        element?.unreadCount; //会话未读消息数，直播群（AVChatRoom）不支持未读计数，默认为 0。
        element?.userID; //对方用户 ID，如果会话类型为单聊，userID 会存储对方的用户 ID，否则为 null。

        if (isProduction)
          print("${element!.userID} ====== ${element!.lastMessage}");
      });

      return getConversationListRes.data?.conversationList ?? [];
    } else {
      if (isProduction) print("=========== 拉取会话列表失败 ===========");
      if (isProduction)
        print(
            "错误码：${getConversationListRes.code} 错误信息： ${getConversationListRes.desc}");
      return [];
    }
  }

  //获取指定单个会话
  Future<V2TimConversation?> getConversation(String conversationID) async {
    //获取指定会话
    V2TimValueCallback<V2TimConversation> getConversationtRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversation(
                conversationID:
                    conversationID); //会话唯一 ID，如果是 C2C 单聊，组成方式为 c2c_userID，如果是群聊，组成方式为 group_groupID
    if (getConversationtRes.code == 0) {
      if (isProduction) print("=========== 获取指定会话成功 ===========");

      //拉取成功
      getConversationtRes.data
          ?.conversationID; //会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
      getConversationtRes.data?.draftText; //草稿信息
      getConversationtRes.data?.draftTimestamp; //草稿编辑时间，草稿设置的时候自动生成。
      getConversationtRes.data?.faceUrl; //会话展示头像，群聊头像：群头像；单聊头像：对方头像。
      getConversationtRes
          .data?.groupAtInfoList; //群会话 @ 信息列表，通常用于展示 “有人@我” 或 “@所有人” 这两种提醒状态。
      getConversationtRes
          .data?.groupID; //当前群聊 ID，如果会话类型为群聊，groupID 会存储当前群的群 ID，否则为 null。
      getConversationtRes
          .data?.groupType; //当前群聊类型，如果会话类型为群聊，groupType 为当前群类型，否则为 null。
      getConversationtRes.data?.isPinned; //会话是否置顶
      getConversationtRes.data?.lastMessage; //会话最后一条消息
      getConversationtRes.data?.orderkey; //会话排序字段
      getConversationtRes.data?.recvOpt; //消息接收选项
      getConversationtRes.data
          ?.showName; //会话展示名称，群聊会话名称优先级：群名称 > 群 ID；单聊会话名称优先级：对方好友备注 > 对方昵称 > 对方的 userID。
      getConversationtRes.data?.type; //会话类型，分为 C2C（单聊）和 Group（群聊）。
      getConversationtRes
          .data?.unreadCount; //会话未读消息数，直播群（AVChatRoom）不支持未读计数，默认为 0。
      getConversationtRes
          .data?.userID; //对方用户 ID，如果会话类型为单聊，userID 会存储对方的用户 ID，否则为 null。

      return getConversationtRes.data;
    } else {
      if (isProduction) print("============= 获取会话失败 ============");
      if (isProduction)
        print(
            "错误码：${getConversationtRes.code} 错误信息： ${getConversationtRes.desc}");
      return null;
    }
  }

  //拉取单聊历史信息
  Future<List<V2TimMessage>> getHistorySignalMessageList(
      String userID, int count, String? lastMsgID) async {
    // 拉取单聊历史消息
    // 首次拉取，lastMsgID 设置为 null
    // 再次拉取时，lastMsgID 可以使用返回的消息列表中的最后一条消息的id
    V2TimValueCallback<List<V2TimMessage>> getHistoryMessageListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .getHistoryMessageList(
      getType: HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
      // 拉取消息的位置及方向
      userID: userID,
      // 用户id 拉取单聊消息，需要指定对方的 userID，此时 groupID 传空即可。
      groupID: "",
      // 群组id 拉取群聊消息，需要指定群聊的 groupID，此时 userID 传空即可。
      count: count,
      // 拉取数据数量
      lastMsgID: lastMsgID,
      // 拉取起始消息id
      // 仅能在群聊中使用该字段。
      // 设置 lastMsgSeq 作为拉取的起点，返回的消息列表中包含这条消息。
      // 如果同时指定了 lastMsg 和 lastMsgSeq，SDK 优先使用 lastMsg。
      // 如果均未指定 lastMsg 和 lastMsgSeq，拉取的起点取决于是否设置 getTimeBegin。设置了，则使用设置的范围作为起点；未设置，则使用最新消息作为起点。
      // lastMsgSeq: -1,
      messageTypeList: [], // 用于过滤历史信息属性，若为空则拉取所有属性信息。
    );

    if (getHistoryMessageListRes.code == 0) {
      // 获取成功
      if (isProduction)
        print("========= 拉取 ID : ${userID} 的 历史消息成功 ============");
      return getHistoryMessageListRes.data ?? [];
    } else {
      if (isProduction) print("============= 获取历史消息失败 ============");
      if (isProduction)
        print(
            "错误码：${getHistoryMessageListRes.code} 错误信息： ${getHistoryMessageListRes.desc}");
      return [];
    }
  }

  //获取群聊历史信息
  Future<List<V2TimMessage>> getHistoryGroupMessageList(
      String groupID, int count, String? lastMsgID) async {
    // 首次拉取，lastMsgID 设置为 null
    // 再次拉取时，lastMsgID 可以使用返回的消息列表中的最后一条消息的id
    V2TimValueCallback<List<V2TimMessage>> getHistoryMessageListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .getHistoryMessageList(
      getType: HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG,
      // 拉取消息的位置及方向
      userID: "",
      // 用户id 拉取单聊消息，需要指定对方的 userID，此时 groupID 传空即可。
      groupID: groupID,
      // 群组id 拉取群聊消息，需要指定群聊的 groupID，此时 userID 传空即可。
      count: count,
      // 拉取数据数量
      lastMsgID: lastMsgID,
      // 拉取起始消息id
      // 仅能在群聊中使用该字段。
      // 设置 lastMsgSeq 作为拉取的起点，返回的消息列表中包含这条消息。
      // 如果同时指定了 lastMsg 和 lastMsgSeq，SDK 优先使用 lastMsg。
      // 如果均未指定 lastMsg 和 lastMsgSeq，拉取的起点取决于是否设置 getTimeBegin。设置了，则使用设置的范围作为起点；未设置，则使用最新消息作为起点。
      // lastMsgSeq: -1,
      messageTypeList: [], // 用于过滤历史信息属性，若为空则拉取所有属性信息。
    );

    if (getHistoryMessageListRes.code == 0) {
      // 获取成功
      if (isProduction)
        print("========= 拉取 groupID : ${groupID} 的 历史消息成功 ============");
      return getHistoryMessageListRes.data ?? [];
    } else {
      if (isProduction) print("============= 获取历史消息失败 ============");
      if (isProduction)
        print(
            "错误码：${getHistoryMessageListRes.code} 错误信息： ${getHistoryMessageListRes.desc}");
      return [];
    }
  }

  //清空单聊消息
  Future<void> clearSignalMessage(String userID) async {
    V2TimCallback clearSignalMessageRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .clearC2CHistoryMessage(userID: userID);

    if (clearSignalMessageRes.code == 0) {
      if (isProduction)
        print("============= userID: $userID 清空单聊消息成功 ===========");
    } else {
      if (isProduction) print("============= 清空单聊消息失败 ===========");
      if (isProduction)
        print(
            "错误码：${clearSignalMessageRes.code} 错误信息： ${clearSignalMessageRes.desc}");
      return;
    }
  }

  //未读数更新
  //清空单聊未读数
  Future<void> clearSignalUnread(String userID) async {
    // 设置单聊消息已读
    V2TimCallback markC2CMessageAsReadRes = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .markC2CMessageAsRead(userID: userID); // 需要设置消息已读的用户id
    if (markC2CMessageAsReadRes.code == 0) {
      // 标记成功
      if (isProduction)
        print("============= userID: $userID 清空单聊未读数成功 ===========");
    } else {
      if (isProduction) print("============= 清空单聊未读数失败 ===========");
      if (isProduction)
        print(
            "错误码：${markC2CMessageAsReadRes.code} 错误信息： ${markC2CMessageAsReadRes.desc}");
    }
  }

  //清空群聊未读数
  Future<void> clearGroupUnread(String groupID) async {
    // 设置群消息已读
    V2TimCallback markGroupMessageAsReadRes = await TencentImSDKPlugin
        .v2TIMManager
        .getMessageManager()
        .markGroupMessageAsRead(groupID: groupID); // 需要设置消息已读的群id
    if (markGroupMessageAsReadRes.code == 0) {
      // 标记成功
      if (isProduction)
        print("============= groupID: $groupID 清空群聊未读数成功 ===========");
    } else {
      if (isProduction) print("============= 清空群聊未读数失败 ===========");
      if (isProduction)
        print(
            "错误码：${markGroupMessageAsReadRes.code} 错误信息： ${markGroupMessageAsReadRes.desc}");
    }
  }

  //撤回消息
  Future<void> revokeMessage(String msgID) async {
    V2TimCallback revokeMessageRes = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .revokeMessage(msgID: msgID);

    if (revokeMessageRes.code == 0) {
      if (isProduction) print("============= 撤回消息成功 ===========");
    } else {
      if (isProduction) print("============= 撤回消息失败 ===========");
      if (isProduction)
        print("错误码：${revokeMessageRes.code} 错误信息： ${revokeMessageRes.desc}");
    }
  }

  //搜索
  // Future<void> searchUser(String keyword) async {
  //   //搜索好友的搜索条件
  //   V2TimFriendSearchParam searchParam = V2TimFriendSearchParam(
  //     isSearchNickName: true, //是否搜索昵称
  //     isSearchRemark: true, //是否搜索备注
  //     isSearchUserID: true, //是否搜索id
  //     keywordList: [keyword], //关键字列表，最多支持5个。
  //   );
  //   V2TimValueCallback<List<V2TimFriendInfoResult>> searchFriendsRes =
  //       await TencentImSDKPlugin.v2TIMManager
  //           .getFriendshipManager()
  //           .searchFriends(searchParam: searchParam); //搜索好友的搜索条件
  //   if (searchFriendsRes.code == 0) {
  //     // if(isProduction) print("============= 搜索好友成功 ===========");
  //
  //     // 查询成功
  //     searchFriendsRes.data?.forEach((element) {
  //       element.relation; //好友类型 0:不是好友 1:对方在我的好友列表中 2:我在对方的好友列表中 3:互为好友
  //       element.resultCode; //此条记录的查询结果错误码
  //       element.resultInfo; //此条查询结果描述
  //       //friendInfo为好友个人资料，如果不是好友，除了 userID 字段，其他字段都为空
  //       element.friendInfo
  //           ?.friendCustomInfo; //好友自定义字段 首先要在 控制台 (功能配置 -> 好友自定义字段) 配置好友自定义字段，然后再调用接口进行设置
  //       element.friendInfo?.friendGroups; //好友所在分组列表
  //       element.friendInfo?.friendRemark; //好友备注
  //       element.friendInfo?.userID; //用户的id
  //       element.friendInfo?.userProfile
  //           ?.allowType; //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
  //       element.friendInfo?.userProfile?.birthday; //用户生日
  //       element.friendInfo?.userProfile?.customInfo; //用户的自定义状态
  //       element.friendInfo?.userProfile?.faceUrl; //用户头像 url
  //       element.friendInfo?.userProfile?.gender; //用户的性别 1:男 2:女
  //       element.friendInfo?.userProfile?.level; //用户的等级
  //       element.friendInfo?.userProfile?.nickName; //用户昵称
  //       element.friendInfo?.userProfile?.role; //用户的角色
  //       element.friendInfo?.userProfile?.selfSignature; //用户的签名
  //       element.friendInfo?.userProfile?.userID; //用户 ID
  //
  //       if (isProduction) print("============= 搜索好友成功 ===========");
  //       if (isProduction)
  //         print(
  //             "关键字：${keyword} 搜索结果：${element.friendInfo?.userID} 类型：${element.relation} 昵称：${element.friendInfo?.userProfile?.nickName} ");
  //     });
  //   } else {
  //     if (isProduction) print("============= 搜索失败 ===========");
  //     if (isProduction)
  //       print("错误码：${searchFriendsRes.code} 错误信息： ${searchFriendsRes.desc}");
  //   }
  // }

  //获取好友列表
  Future<List<V2TimFriendInfo>> getFriendList() async {
    // 获取好友列表
    V2TimValueCallback<List<V2TimFriendInfo>> friendsList =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendList();

    if (isProduction) {
      print("============= 获取好友列表 ===========");
      friendsList.data?.forEach((element) {
        element.friendRemark; //好友备注
        element.friendGroups; //好友所在分组列表
        element.userID; //用户的id
        element.userProfile
            ?.allowType; //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
        element.userProfile?.birthday; //用户生日
        element.userProfile?.customInfo; //用户的自定义状态

        print("好友ID ：${element.userID} 备注：${element.friendRemark}");
      });
    }

    return friendsList.data ?? [];
  }

  //添加好友
  Future<void> addFriend(String userID, String friendRemark) async {
    // 添加双向好友
    V2TimValueCallback<V2TimFriendOperationResult> addFriendResult =
        await TencentImSDKPlugin.v2TIMManager.getFriendshipManager().addFriend(
            userID: userID,
            remark: friendRemark,
            addWording: "附言",
            addType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH);

    if (addFriendResult.code == 0) {
      if (isProduction) print("============= 好友申请成功 ===========");
    } else {
      if (isProduction) print("============= 好友申请失败 ===========");
      if (isProduction)
        print("错误码：${addFriendResult.code} 错误信息： ${addFriendResult.desc}");
    }
  }

  //单个删除好友
  Future<void> deleteFriend(String userID) async {
    // 删除双向好友
    V2TimValueCallback<List<V2TimFriendOperationResult>> deleteres =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .deleteFromFriendList(
                deleteType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,
                userIDList: [userID]);

    if (deleteres.code == 0) {
      if (isProduction) print("============= 单个删除好友成功 ===========");
    } else {
      if (isProduction) print("============= 单个删除好友失败 ===========");
      if (isProduction) print("错误码：${deleteres.code} 错误信息： ${deleteres.desc}");
    }
  }

  //获取单个好友信息
  Future<V2TimFriendInfoResult> getFriendProfile(String userID) async {
    // 获取好友信息
    V2TimValueCallback<List<V2TimFriendInfoResult>> friendsInfo =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendsInfo(userIDList: [userID]);

    if (friendsInfo.code == 0) {
      if (isProduction) print("============= 获取单个好友信息成功 ===========");

      return friendsInfo.data![0];
    } else {
      if (isProduction) print("============= 获取单个好友信息失败 ===========");
      if (isProduction)
        print("错误码：${friendsInfo.code} 错误信息： ${friendsInfo.desc}");

      throw Exception("获取单个好友信息失败");
    }
  }

  //更改好友备注
  Future<void> setFriendRemark(String userID, String remark) async {
    //设置指定好友资料
    V2TimCallback setFriendInfoRes = await TencentImSDKPlugin.v2TIMManager
        .getFriendshipManager()
        .setFriendInfo(
          userID: userID, //需要修改的用户id
          friendRemark: remark, //修改的好友备注
        ); //修改的好友自定义信息
    if (setFriendInfoRes.code == 0) {
      // 修改成功
      if (isProduction) print("============= 更改好友备注成功 ===========");
    } else {
      if (isProduction) print("============= 更改好友备注失败 ===========");
      if (isProduction)
        print("错误码：${setFriendInfoRes.code} 错误信息： ${setFriendInfoRes.desc}");
    }
  }

  //检验是否是好友
  Future<V2TimFriendCheckResult> checkFriend(String userID) async {
    // 检测好友是否有双向（单向）好友关系。
    V2TimValueCallback<List<V2TimFriendCheckResult>> checkres =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .checkFriend(
                checkType: FriendTypeEnum.V2TIM_FRIEND_TYPE_BOTH,
                userIDList: [userID]);
    if (checkres.code == 0) {
      if (isProduction) print("============= 检验是否是好友成功 ===========");
      // 查询发送成功
      checkres.data?.forEach((element) {
        element.resultCode; //检查结果错误码
        element.resultInfo; //检查结果信息
        element.resultType; //与查询用户的关系类型 0:不是好友 1:对方在我的好友列表中 2:我在对方的好友列表中 3:互为好友
        element.userID; //用户id
      });
      return checkres.data![0];
    } else {
      if (isProduction) print("============= 检验是否是好友失败 ===========");
      if (isProduction) print("错误码：${checkres.code} 错误信息： ${checkres.desc}");
      throw Exception("检验是否是好友失败");
    }
  }

  //获取好友申请列表
  Future<V2TimFriendApplicationResult> getFriendApplicationList() async {
    // 获取好友申请列表

    // V2TimFriendCheckResult.unreadCount : 未读数
    // V2TimFriendCheckResult.friendApplicationList : 申请列表( 类型: List< V2TimFriendApplication > )

    //获取好友申请列表
    V2TimValueCallback<V2TimFriendApplicationResult>
        getFriendApplicationListRes = await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .getFriendApplicationList();

    if (getFriendApplicationListRes.code == 0) {
      // 查询成功
      // getFriendApplicationListRes.data?.unreadCount;//未读申请数量
      // getFriendApplicationListRes.data?.friendApplicationList
      //     ?.forEach((element) {
      //   element?.addSource;//申请添加来源 flutter会在发出请求的source前添加AddSource_Type_
      //   element?.addTime;//申请时间
      //   element?.addWording;//申请添加的信息
      //   element?.faceUrl;//申请好友头像Url
      //   element?.nickname;//申请用户昵称
      //   element?.type;//申请好友类型
      //   element?.userID;//申请用户id
      // });

      if (isProduction) print("============= 获取好友申请列表成功 ===========");

      return getFriendApplicationListRes.data!;
    } else {
      if (isProduction) print("============= 获取好友申请列表失败 ===========");
      if (isProduction)
        print(
            "错误码：${getFriendApplicationListRes.code} 错误信息： ${getFriendApplicationListRes.desc}");

      throw Exception("获取好友申请列表失败");
    }
  }

  //同意好友申请
  Future<bool> acceptFriendApplication(String userID) async {
    //同意好友申请
    V2TimValueCallback<V2TimFriendOperationResult> acceptFriendApplicationRes =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .acceptFriendApplication(
                responseType: FriendResponseTypeEnum.V2TIM_FRIEND_ACCEPT_AGREE,
                //建立好友关系时选择单向/双向好友关系
                type: FriendApplicationTypeEnum.V2TIM_FRIEND_APPLICATION_BOTH,
                //加好友类型 要与getApplicationList查询到的type相同，否则会报错。
                userID: userID); //同意好友的用户id
    if (acceptFriendApplicationRes.code == 0) {
      // 同意成功
      acceptFriendApplicationRes.data?.resultCode; //操作结果错误码
      acceptFriendApplicationRes.data?.resultInfo; //操作结果描述
      acceptFriendApplicationRes.data?.userID; //同意好友的id

      if (isProduction) print("============= 同意好友申请成功 ===========");
      return true;
    } else {
      if (isProduction) print("============= 同意好友申请失败 ===========");
      if (isProduction)
        print(
            "错误码：${acceptFriendApplicationRes.code} 错误信息： ${acceptFriendApplicationRes.desc}");

      return false;
    }
  }

  //拒绝好友申请
  Future<bool> refuseFriendApplication(String userID) async {
    //拒绝好友申请
    V2TimValueCallback<V2TimFriendOperationResult> refuseFriendApplicationRes =
        await TencentImSDKPlugin.v2TIMManager
            .getFriendshipManager()
            .refuseFriendApplication(
                type: FriendApplicationTypeEnum
                    .V2TIM_FRIEND_APPLICATION_BOTH, //拒绝好友类型
                userID: ""); //拒绝好友的用户id
    if (refuseFriendApplicationRes.code == 0) {
      // 拒绝成功
      refuseFriendApplicationRes.data?.resultCode; //操作结果错误码
      refuseFriendApplicationRes.data?.resultInfo; //操作结果描述
      refuseFriendApplicationRes.data?.userID; //拒绝好友的id
      if (isProduction) print("============= 拒绝好友申请成功 ===========");
      return true;
    } else {
      if (isProduction) print("============= 拒绝好友申请失败 ===========");
      if (isProduction)
        print(
            "错误码：${refuseFriendApplicationRes.code} 错误信息： ${refuseFriendApplicationRes.desc}");

      return false;
    }
  }

  //已读好友申请
  Future<bool> readFriendApplication() async {
    //设置好友申请已读
    V2TimCallback setFriendApplicationReadRes = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .setFriendApplicationRead();
    if (setFriendApplicationReadRes.code == 0) {
      // 设置成功
      if (isProduction) print("============= 设置好友申请已读成功 ===========");
      return true;
    } else {
      if (isProduction) print("============= 设置好友申请已读失败 ===========");
      if (isProduction)
        print(
            "错误码：${setFriendApplicationReadRes.code} 错误信息： ${setFriendApplicationReadRes.desc}");

      return false;
    }
  }

  //删除好友申请
  Future<bool> deleteFriendApplication(String userID) async {
    //删除好友申请
    V2TimCallback deleteFriendApplicationRes = await TencentImSDKPlugin
        .v2TIMManager
        .getFriendshipManager()
        .deleteFriendApplication(
          type: FriendApplicationTypeEnum.V2TIM_FRIEND_APPLICATION_BOTH,
          //加好友类型 要与getApplicationList查询到的type相同，否则会报错。
          userID: userID, //被删除好友申请的用户id
        );
    if (deleteFriendApplicationRes.code == 0) {
      // 删除成功
      if (isProduction) print("============= 删除好友申请成功 ===========");
      return true;
    } else {
      if (isProduction) print("============= 删除好友申请失败 ===========");
      if (isProduction)
        print(
            "错误码：${deleteFriendApplicationRes.code} 错误信息： ${deleteFriendApplicationRes.desc}");

      return false;
    }
  }

  //创建群聊
  Future<String> createGroup(
      String groupName, List<V2TimGroupMember> memberList) async {
    // 创建群组
    V2TimValueCallback<String> createGroupRes =
        await TencentImSDKPlugin.v2TIMManager.getGroupManager().createGroup(
              groupType: "Work",
              // 群类型
              groupName: groupName,
              // 群名称，不能为 null。
              notification: "",
              // 群公告
              introduction: "",
              // 群介绍
              faceUrl: "默认头像",
              // 群头像Url
              isAllMuted: false,
              // 是否全体禁言
              isSupportTopic: false,
              // 是否支持话题
              addOpt: GroupAddOptTypeEnum.V2TIM_GROUP_ADD_ANY,
              // 添加群设置( FORBID: 禁止加群 / AUTH: 加群审核 / ANY: 直接加群 )
              memberList: memberList, // 初始成员列表
            );
    if (createGroupRes.code == 0) {
      // 创建成功
      createGroupRes.data; // 创建的群号
      return createGroupRes.data!;
    } else {
      throw Exception("创建群聊失败");
    }
  }

  //获取群聊列表
  Future<List<V2TimGroupInfo>> getGroupList() async {
    //获取当前用户已经加入的群列
    V2TimValueCallback<List<V2TimGroupInfo>> getJoinedGroupListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getJoinedGroupList();
    if (getJoinedGroupListRes.code == 0) {
      // 查询成功
      getJoinedGroupListRes.data?.forEach((element) {
        element.createTime; // 群创建时间
        element.customInfo; // 群自定义字段
        element.faceUrl; // 群头像Url
        element.groupAddOpt; // 群添加选项设置
        element.groupID; // 群ID
        element.groupName; // 群名
        element.groupType; // 群类型
        element.introduction; // 群介绍
        element.isAllMuted; // 群是否全体禁言
        element.isSupportTopic; // 群是否支持话题
        element.joinTime; // 当前用户在此群的加入时间
        element.lastInfoTime; // 最后一次群修改资料的时间
        element.lastMessageTime; // 最后一次群发消息的时间
        element.memberCount; // 群员数量
        element.notification; // 群公告
        element.onlineCount; // 群在线人数
        element.owner; // 群主
        element.recvOpt; // 当前用户在此群中接受信息的选项
        element.role; // 此用户在群中的角色
      });

      return getJoinedGroupListRes.data!;
    } else {
      if (isProduction) print("============= 获取群聊列表失败 ===========");
      if (isProduction)
        print(
            "错误码：${getJoinedGroupListRes.code} 错误信息： ${getJoinedGroupListRes.desc}");
      throw Exception("获取群聊列表失败");
    }
  }

  //邀请进入群聊
  Future<void> inviteGroupMember(
      String groupID, List<String> memberList) async {
    // 邀请他人入群
    V2TimValueCallback<List<V2TimGroupMemberOperationResult>>
        inviteUserToGroupRes = await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .inviteUserToGroup(
      groupID: "groupID", // 需要加入的群组id
      userList: [], // 邀请的用户id列表
    );
    if (inviteUserToGroupRes.code == 0) {
      // 邀请成功
      inviteUserToGroupRes.data?.forEach((element) {
        element.memberID; // 被操作成员 ID
        // 邀请结果状态
        // 0:操作失败，1:操作成功，2:无效操作，加群时已经是群成员
        // 3:等待处理，邀请入群时等待对方处理，4:操作失败，创建群指定初始群成员列表或邀请入群时，被邀请者加入的群总数超限
        element.result; // 邀请结果状态
      });
    } else {
      if (isProduction) print("============= 邀请进入群聊失败 ===========");
      if (isProduction)
        print(
            "错误码：${inviteUserToGroupRes.code} 错误信息： ${inviteUserToGroupRes.desc}");
    }
  }

  //获取群聊信息
  Future<V2TimGroupInfo> getGroupInfo(String groupID) async {
    //获取群资料
    V2TimValueCallback<List<V2TimGroupInfoResult>> getGroupsInfoRes =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupsInfo(groupIDList: [groupID]); // 需要查询的群组id列表
    if (getGroupsInfoRes.code == 0) {
      // 查询成功
      getGroupsInfoRes.data?.forEach((element) {
        element.resultCode; // 此群组查询结果码
        element.resultMessage; // 此群查询结果描述
        element.groupInfo?.createTime; // 群创建时间
        element.groupInfo?.customInfo; // 群自定义字段
        element.groupInfo?.faceUrl; // 群头像Url
        element.groupInfo?.groupAddOpt; // 群添加选项设置
        element.groupInfo?.groupID; // 群ID
        element.groupInfo?.groupName; // 群名
        element.groupInfo?.groupType; // 群类型
        element.groupInfo?.introduction; // 群介绍
        element.groupInfo?.isAllMuted; // 群是否全体禁言
        element.groupInfo?.isSupportTopic; // 群是否支持话题
        element.groupInfo?.joinTime; // 当前用户在此群的加入时间
        element.groupInfo?.lastInfoTime; // 最后一次群修改资料的时间
        element.groupInfo?.lastMessageTime; // 最后一次群发消息的时间
        element.groupInfo?.memberCount; // 群员数量
        element.groupInfo?.notification; // 群公告
        element.groupInfo?.onlineCount; // 群在线人数
        element.groupInfo?.owner; // 群主
        element.groupInfo?.recvOpt; // 当前用户在此群中接受信息的选项
        element.groupInfo?.role; // 此用户在群中的角色
      });
      return getGroupsInfoRes.data![0].groupInfo!;
    } else {
      if (isProduction) print("============= 获取群聊信息失败 ===========");
      if (isProduction)
        print("错误码：${getGroupsInfoRes.code} 错误信息： ${getGroupsInfoRes.desc}");
      throw Exception("获取群聊信息失败");
    }
  }

  //获取群成员列表
  Future<List<V2TimGroupMemberFullInfo?>> getGroupMemberList(
      String groupID, GroupMemberFilterTypeEnum filter) async {
    // 获取群成员列表
    V2TimValueCallback<V2TimGroupMemberInfoResult> getGroupMemberListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupMemberList(
              groupID: groupID, // 需要查询的群组 ID
              filter: filter, //查询群成员类型
              nextSeq:
                  "0", // 分页拉取标志，第一次拉取填0，回调成功如果 nextSeq 不为零，需要分页，传入返回值再次拉取，直至为0。
              //count: 100,// 需要拉取的数量。最大值：100，避免回包过大导致请求失败。若传入超过100，则只拉取前100个。
              offset: 0, // 偏移量，默认从0开始拉取。
            );

    if (getGroupMemberListRes.code == 0) {
      // 拉取成功
      getGroupMemberListRes.data?.memberInfoList?.forEach((element) {
        element?.customInfo; // 群成员自定义字段
        element?.faceUrl; // 头像Url
        element?.friendRemark; // 好友备注
        element?.joinTime; // 群成员入群时间
        element?.muteUntil; // 群成员禁言持续时间
        element?.nameCard; // 群成员名片
        element?.nickName; // 群成员昵称
        element?.role; // 群成员角色
        element?.userID; // 群成员ID
      });

      return getGroupMemberListRes.data!.memberInfoList!;
    } else {
      if (isProduction) print("============= 获取群成员列表失败 ===========");
      if (isProduction)
        print(
            "错误码：${getGroupMemberListRes.code} 错误信息： ${getGroupMemberListRes.desc}");
      throw Exception("获取群成员列表失败");
    }
  }

  // 退出群聊
  Future<bool> quitGroup(String groupID) async {
    V2TimCallback quitGroupRes =
        await TencentImSDKPlugin.v2TIMManager.quitGroup(
      groupID: "groupID",
    ); // 需要退出的群组 ID
    if (quitGroupRes.code == 0) {
      // 退出成功
      if (isProduction) {
        print("退出群聊成功");
      }

      return true;
    } else {
      if (isProduction) print("============= 退出群聊失败 ===========");
      if (isProduction)
        print("错误码：${quitGroupRes.code} 错误信息： ${quitGroupRes.desc}");

      return false;
    }
  }
}
