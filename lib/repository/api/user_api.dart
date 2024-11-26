import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/global.dart';
import '../../utils/sp_utils.dart';

bool isProduction = Constants.IS_Production;

class SearchUserResult {
  final List<SearchUser> users;
  final int total;

  SearchUserResult(this.users, this.total);
}

class UserApi {
  static final UserApi _instance = UserApi._internal();

  static UserApi get instance => _instance;

  factory UserApi() => _instance;

  UserApi._internal();

  Future<SearchUserResult> searchUsers(String query, int page) async {
    String url = UrlPath.searchUser;

    try {
      final response = await DioInstance.instance().get(path: url, param: {
        "message": query,
        "page": page,
      });

      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          if (isProduction) {
            print("搜索用户成功");
            print(response);
            print(response.data['data']['items']);
          }

          List<SearchUser> users = (response.data['data']['items'] != null
              ? (response.data['data']['items'] as List)
                  .map((e) => SearchUser.fromJson(e))
                  .toList()
              : []);

          return SearchUserResult(users, response.data['data']['total']);
        } else {
          if (isProduction) print(response.data['message']);
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) print("无法连接服务器");
        showToast("无法连接服务器", duration: Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print("error: $e");
    }
    return SearchUserResult([], 0);
  }

  Future<bool> checkFriend(int userID) async {
    List<V2TimFriendInfo> friendList =
        await ImChatApi.getInstance().getFriendList();

    bool result = false;

    friendList.forEach((element) {
      element.friendRemark; //好友备注
      element.friendGroups; //好友所在分组列表
      element.userID; //用户的id
      element.userProfile
          ?.allowType; //用户的好友验证方式 0:允许所有人加我好友 1:不允许所有人加我好友 2:加我好友需我确认
      element.userProfile?.birthday; //用户生日
      element.userProfile?.customInfo; //用户的自定义状态

      if (isProduction) {
        print("====== checkFriend my and userID : ${element.userID}");
      }
      if (element.userID == userID.toString()) {
        result = true;
      }
    });

    if (isProduction) {
      if (result) {
        print("================ $userID 是好友 =======================");
      } else {
        print("================== $userID 不是好友 =======================");
      }
    }

    return result;
  }

  //TODO
  Future<void> logout() async {
    String url = UrlPath.logoutUrl;

    try {
      final response = await DioInstance.instance().post(
        path: url,
        options: Options(headers: {"Authorization": Global.token}),
      );
      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          showToast("退出登录", duration: Duration(seconds: 1));

          if (isProduction) print("注销");

          Global.isLogin = false;
          Global.password = null;
          Global.userInfoNotifier.value = null;

          //IM注销登录
          await ImChatApi.getInstance().logout();

          await SpUtils.saveString("password", "");

          // RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
        } else {
          showToast("退出登录失败", duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) showToast("服务器连接失败", duration: Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print("error $e");
    }
  }
}
