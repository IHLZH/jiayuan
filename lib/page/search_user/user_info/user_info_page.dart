import 'package:flutter/material.dart';
import 'package:jiayuan/repository/model/searchUser.dart';

class UserInfoPage extends StatefulWidget {
  final SearchUser user;

  const UserInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.user.nickName),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户头像和昵称
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: widget.user.userAvatar == '默认头像'
                                ? AssetImage('assets/images/ikun1.png')
                                : NetworkImage(widget.user.userAvatar +
                                    '?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
                            onBackgroundImageError: (_, __) {
                              // 显示默认头像
                              print('显示默认头像');
                            },
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.nickName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${widget.user.userName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 用户其他信息
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                          Icons.phone, '手机号', widget.user.userPhoneNumber),
                      _buildInfoRow(
                          Icons.email, '邮箱', widget.user.email ?? '未绑定'),
                      _buildInfoRow(Icons.person, '性别',
                          widget.user.userSex == 1 ? '男' : '女'),
                      // _buildInfoRow(Icons.location_on, '最近登录地点',
                      //     '${widget.user.lng ?? "未知"}, ${widget.user.lat ?? "未知"}'),
                      _buildInfoRow(
                          Icons.access_time, '最近登录时间', widget.user.loginTime),
                      const SizedBox(height: 20),

                      // 用户状态和类型
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                          Icons.account_box, '用户类型', _getUserTypeLabel()),
                      _buildInfoRow(
                          Icons.verified, '用户状态', _getUserStatusLabel()),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // 底部操作按钮
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 如果用户是家政员，显示家政员信息按钮
                        if (widget.user.userType == 1) ...[
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: Icons.info,
                            label: '家政员',
                            color: Colors.orange,
                            onPressed: () {
                              // TODO: 实现家政员信息功能
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('家政员信息功能开发中')),
                              );
                            },
                          ),
                          const Expanded(child: SizedBox()),
                        ],

                        _buildActionButton(
                          icon: Icons.person_add,
                          label: '加好友',
                          color: Colors.blue,
                          onPressed: () {
                            // TODO: 实现加好友功能
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('加好友功能开发中')),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.message,
                          label: '发信息',
                          color: Colors.green,
                          onPressed: () {
                            // TODO: 实现发信息功能
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('发信息功能开发中')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助方法：构建一行用户信息
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 辅助方法：构建操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  // 根据用户类型返回标签
  String _getUserTypeLabel() {
    switch (widget.user.userType) {
      case 0:
        return '普通用户';
      case 1:
        return '家政员';
      default:
        return '未知类型';
    }
  }

  // 根据用户状态返回标签
  String _getUserStatusLabel() {
    switch (widget.user.userStatus) {
      case 1:
        return '正常';
      case 2:
        return '封禁';
      default:
        return '未知状态';
    }
  }
}
