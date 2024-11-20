import 'package:jiayuan/utils/constants.dart';
import 'package:tencent_cloud_chat_sdk/enum/V2TimSDKListener.dart';
import 'package:tencent_cloud_chat_sdk/enum/log_level_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
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

class ImChatApi {
  // 私有化构造函数
  ImChatApi._();

  // 静态私有实例
  static ImChatApi _instance = ImChatApi._();

  // 静态方法获取实例
  static ImChatApi getInstance() {
    return _instance;
  }

  Future<void> initSDK() async {
    // 1. 从即时通信 IM 控制台获取应用 SDKAppID。
    int sdkAppID = 1600061544;
    // 2. 添加 V2TimSDKListener 的事件监听器，sdkListener 是 V2TimSDKListener 的实现类
    V2TimSDKListener sdkListener = V2TimSDKListener(
      onConnectFailed: (int code, String error) {
        // 连接失败的回调函数
        // code 错误码
        // error 错误信息

        if (isProduction) print("连接失败的回调函数 错误码 $code,错误信息 $error");
      },
      onConnectSuccess: () {
        // SDK 已经成功连接到腾讯云服务器
        if (isProduction) print("SDK 已经成功连接到腾讯云服务器");
      },
      onConnecting: () {
        // SDK 正在连接到腾讯云服务器
        if (isProduction) print("SDK 正在连接到腾讯云服务器");
      },
      onKickedOffline: () {
        // 当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。
        if (isProduction)
          print("当前用户被踢下线，此时可以 UI 提示用户，并再次调用 V2TIMManager 的 login() 函数重新登录。");
      },
      onSelfInfoUpdated: (V2TimUserFullInfo info) {
        // 登录用户的资料发生了更新
        // info登录用户的资料
        if (isProduction) print("登录用户的资料发生了更新");
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
      listener: sdkListener, // 事件监听器
    );
    if (initSDKRes.code == 0) {
      // 初始化成功
      if (isProduction) print("IM SDK 初始化成功");
    }
  }

  Future<void> login(String userID, String userSig) async {
    V2TimCallback loginRes = await TencentImSDKPlugin.v2TIMManager
        .login(userID: userID, userSig: userSig);
    if (loginRes.code == 0) {
      // 登录成功逻辑
      if (isProduction) print("登录成功 UserID: $userID");
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
      if (isProduction) print("登出成功");
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
      if (isProduction) print("查询失败");
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
      if (isProduction) print("修改成功");
    } else {
      // 修改失败
      if (isProduction)
        print("修改失败，错误码: ${setSelfInfoRes.code}, 错误信息: ${setSelfInfoRes.desc}");
    }
  }
}
