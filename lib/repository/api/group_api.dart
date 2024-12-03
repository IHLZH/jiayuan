import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';

class GroupApi {
  static final GroupApi _instance = GroupApi._internal();

  GroupApi._internal();

  factory GroupApi() {
    return _instance;
  }

  Future<String> createGroup(String groupName, List<String> userList) async {
    List<V2TimGroupMember> memberList;

    // V2TIM_GROUP_MEMBER_ROLE_MEMBER 	群成员 	1
    // V2TIM_GROUP_MEMBER_ROLE_ADMIN 	群管理员 	2
    // V2TIM_GROUP_MEMBER_ROLE_OWNER 	群主 	3

    memberList = userList
        .map((e) => V2TimGroupMember(
            userID: e,
            role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_MEMBER))
        .toList(); //设置群成员

    memberList.add(V2TimGroupMember(
        userID: Global.userInfo!.userId.toString(),
        role: GroupMemberRoleTypeEnum.V2TIM_GROUP_MEMBER_ROLE_OWNER)); //自己设置群主

    String res =
        await ImChatApi.getInstance().createGroup(groupName, memberList);

    return res;
  }
}
