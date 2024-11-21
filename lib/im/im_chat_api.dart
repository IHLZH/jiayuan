import 'package:jiayuan/utils/constants.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimAdvancedMsgListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimFriendshipListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimGroupListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/history_msg_get_type_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_application.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';
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
        },
        onFriendApplicationListDeleted: (List<String> userIDList) async {
          //好友请求数量减少的回调
          //减少的好友请求的请求用户id列表
        },
        onFriendApplicationListRead: () async {
          //好友请求已读的回调
        },
        onFriendInfoChanged: (List<V2TimFriendInfo> infoList) async {
          //好友信息改变的回调
          //infoList 好友信息改变的好友列表
        },
        onFriendListAdded: (List<V2TimFriendInfo> users) async {
          //好友列表增加人员的回调
          //users 新增的好友信息列表
        },
        onFriendListDeleted: (List<String> userList) async {
          //好友列表减少人员的回调
          //userList 减少的好友id列表
        },
      );
      TencentImSDKPlugin.v2TIMManager
          .getFriendshipManager()
          .addFriendListener(listener: friendshipListener!); //添加关系链监听器

      if (isProduction && friendshipListener != null)
        print("============= IM设置关系链监听器成功 ============");
    } else {
      // 登录失败逻辑
      if (isProduction) print("登录失败");
      if (isProduction) print("错误码: ${loginRes.code} 错误信息: ${loginRes.desc}");
    }

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
      },
      onRecvNewMessage: (V2TimMessage message) async {
        // 处理文本消息
        if (message.elemType == MessageElemType.V2TIM_ELEM_TYPE_TEXT) {
          String? text = message.textElem!.text;

          if (isProduction) print("============获得新消息： ${text}=========");
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
    } else {
      if (isProduction) print("============= IM登出失败 ============");
      if (isProduction) print("错误码: ${logoutRes.code} 错误信息: ${logoutRes.desc}");
    }
  }

  Future<void> getUsersInfo(List<String> userIDList) async {
    //获取用户资料
    V2TimValueCallback<List<V2TimUserFullInfo>> getUsersInfoRes =
        await TencentImSDKPlugin.v2TIMManager
            .getUsersInfo(userIDList: userIDList); //需要查询的用户id列表
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

      if (isProduction) print("查询成功");
      if (isProduction) {
        print(
            "usersInfo: ID:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.userID}");
        print(
            "性别:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.gender}");
        print(
            "角色:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.role}");
        print(
            "昵称:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.nickName}");
        print(
            "等级:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.level}");
        print(
            "生日:${getUsersInfoRes.data?.firstWhere((user) => user.userID == userIDList.first)?.birthday}");
        //TODO:用户角色设置与查找
      }
    } else {
      if (isProduction) print("============= IM查询失败 ============");
    }
  }

  Future<void> setSelfInfo(String userID, String nickName, String userAvatar,
      int userSex, int userType) async {
    //用户资料设置信息
    V2TimUserFullInfo userFullInfo = V2TimUserFullInfo(
      nickName: nickName,
      // 用户昵称
      allowType: 0,
      //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
      birthday: 0,
      //用户生日
      faceUrl: userAvatar,
      //用户头像 url
      gender: userSex,
      //用户的性别 1:男 2:女
      level: 0,
      //用户的等级
      role: userType,
      //用户的角色
      selfSignature: "",
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
      getType: HistoryMsgGetTypeEnum.V2TIM_GET_LOCAL_OLDER_MSG, // 拉取消息的位置及方向
      userID: userID, // 用户id 拉取单聊消息，需要指定对方的 userID，此时 groupID 传空即可。
      groupID: "", // 群组id 拉取群聊消息，需要指定群聊的 groupID，此时 userID 传空即可。
      count: count, // 拉取数据数量
      lastMsgID: lastMsgID, // 拉取起始消息id
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
}
