import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/repository/model/searchUser.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:oktoast/oktoast.dart';

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
}
