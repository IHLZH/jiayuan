import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_filter_enum.dart';
import 'package:tencent_cloud_chat_sdk/enum/group_member_role_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_full_info.dart';

class GroupApi {
  static final GroupApi _instance = GroupApi._internal();

  GroupApi._internal();

  factory GroupApi() {
    return _instance;
  }

  // 创建群组
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

  //获取群聊信息
  Future<V2TimGroupInfo> getGroupInfo(String groupId) async {
    V2TimGroupInfo res = await ImChatApi.getInstance().getGroupInfo(groupId);

    return res;
  }

  //获取全部群成员列表
  Future<List<V2TimGroupMemberFullInfo?>> getGroupMemberList(String groupId) async {
    //filter: 群成员过滤类型
    //类型
    // GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL   拉取所有群成员的信息列表
    // GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_OWNER  仅拉取群主的信息列表
    // GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ADMIN  仅拉取群管理员的信息列表
    // GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_COMMON  仅拉取普通群成员的信息列表

    List<V2TimGroupMemberFullInfo?> res =
        await ImChatApi.getInstance().getGroupMemberList(groupId,GroupMemberFilterTypeEnum.V2TIM_GROUP_MEMBER_FILTER_ALL);

    return res;
  }

  // 退出群组
  Future<bool> quitGroup(String groupId) async {
    bool res = await ImChatApi.getInstance().quitGroup(groupId);

    return res;
  }

  //邀请成员入群
  Future<bool> inviteUserToGroup(String groupId,List<String> userList) async {
    bool res = await ImChatApi.getInstance().inviteGroupMember(groupId,userList);

    return res;
  }
}
