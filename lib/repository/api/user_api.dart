import 'package:dio/dio.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_check_result.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

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

  //非IM获取用户
  Future<SearchUserResult> searchUsers(String query, int page) async {
    String url = UrlPath.searchUser;

    try {
      final response = await DioInstance.instance().get(
          path: url,
          param: {
            "message": query,
            "page": page,
          },
          options: Options(headers: {"Authorization": Global.token}));

      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          if (isProduction) {
            print("搜索用户成功");
            print(response);
            print(response.data['message']);
            print(response.data['data']['items']);
          }
          List<SearchUser> users;

          if (response.data['message'] == '邮箱' ||
              response.data['message'] == '手机号') {
            users = (response.data['data'] != null
                ? [SearchUser.fromJson(response.data['data'])]
                : []);
          } else {
            users = (response.data['data']['items'] != null
                ? (response.data['data']['items'] as List)
                    .map((e) => SearchUser.fromJson(e))
                    .toList()
                : []);
          }

          return SearchUserResult(
              users,
              response.data['message'] == '邮箱' ||
                      response.data['message'] == '手机号'
                  ? users.length
                  : response.data['data']['total']);
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

  // 获取单个用户信息
  Future<SearchUser> getSignalUser(int userID) async {
    String url = UrlPath.getSignalUserInfo;

    try {
      SearchUser user;

      final response = await DioInstance.instance().get(
          path: url,
          param: {
            "userId": userID,
          },
          options: Options(headers: {"Authorization": Global.token}));
      if (response.statusCode == 200) {
        if (response.data["code"] == 200) {
          user = SearchUser.fromJson(response.data['data']);

          if (isProduction) {
            print("获取用户信息成功");
            // print(response.data['data']);
            print(user);
          }

          return user;
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

    throw Exception("获取用户信息失败");
  }

  // 检查是否为好友
  Future<bool> checkFriend(int userID) async {
    bool result = false;

    V2TimFriendCheckResult res =
        await ImChatApi.getInstance().checkFriend(userID.toString());

    result = res.resultType == 3;

    if (isProduction) {
      if (result) {
        print("================ $userID 是好友 =======================");
      } else {
        print("================== $userID 不是好友 =======================");
      }
    }

    return result;
  }

  // 添加好友
  Future<void> addFriend(int userID, String friendRemark) async {
    await ImChatApi.getInstance().addFriend(userID.toString(), friendRemark);
  }

//TODO
// Future<void> logout() async {
//   String url = UrlPath.logoutUrl;
//
//   try {
//     final response = await DioInstance.instance().post(
//       path: url,
//       options: Options(headers: {"Authorization": Global.token}),
//     );
//     if (response.statusCode == 200) {
//       if (response.data["code"] == 200) {
//         showToast("退出登录", duration: Duration(seconds: 1));
//
//         if (isProduction) print("注销");
//
//         Global.isLogin = false;
//         Global.password = null;
//         Global.userInfoNotifier.value = null;
//
//         //IM注销登录
//         await ImChatApi.getInstance().logout();
//
//         await SpUtils.saveString("password", "");
//
//         // RouteUtils.pushNamedAndRemoveUntil(context, RoutePath.loginPage);
//       } else {
//         showToast("退出登录失败", duration: Duration(seconds: 1));
//       }
//     } else {
//       if (isProduction) showToast("服务器连接失败", duration: Duration(seconds: 1));
//     }
//   } catch (e) {
//     if (isProduction) print("error $e");
//   }
// }
}
