import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_friend_info.dart';

class FriendInfoPageViewModel with ChangeNotifier{

  static FriendInfoPageViewModel instance = FriendInfoPageViewModel._();

  FriendInfoPageViewModel._();

  late V2TimFriendInfo friendInfo;

}