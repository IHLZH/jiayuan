import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiayuan/http/dio_instance.dart';
import 'package:jiayuan/http/url_path.dart';
import 'package:jiayuan/im/im_chat_api.dart';
import 'package:jiayuan/repository/api/uploadImage_api.dart';
import 'package:jiayuan/repository/model/user.dart';
import 'package:jiayuan/utils/constants.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:jiayuan/utils/image_utils.dart';
import 'package:jiayuan/utils/sp_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

bool isProduction = Constants.IS_Production;

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // 控制器和状态变量声明
  final TextEditingController _nickNameController = TextEditingController();
  int _selectedSex = 0;
  String? _avatarUrl;

  // 添加一个状态变量来存储选择的头像
  XFile? _pickedFile;

  // 添加最大字符限制
  static const int _maxNickNameLength = 20;

  // 添加一个状态变量来跟踪当前输入长度
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _nickNameController.text = Global.userInfo?.nickName ?? '';
    _selectedSex = Global.userInfo?.userSex ?? 0;
    _avatarUrl = Global.userInfo?.userAvatar;

    // 添加文本变化监听器
    _currentLength = _nickNameController.text.length;
    _nickNameController.addListener(() {
      setState(() {
        _currentLength = _nickNameController.text.length;
      });
    });
  }

  Future<void> _jumpToTab() async {
    RouteUtils.pop(context);
  }

  Future<void> _updateUserInfo(User updatedUser) async {
    if (_pickedFile != null) {
      String imageUrl = await UploadImageApi.instance
          .uploadImage(_pickedFile!, UrlPath.uploadAvatarUrl);
      print('头像存储路径 ${imageUrl}');
      updatedUser.userAvatar = imageUrl;

      // 立即更新 userInfoNotifier
      // Global.userInfoNotifier.value = updatedUser;
    }

    String url = UrlPath.updateUserInfoUrl;

    try {
      final response = await DioInstance.instance().post(
        path: url,
        data: updatedUser.toMap(),
        options: Options(headers: {"Authorization": Global.token!}),
      );

      if (response.statusCode == 200) {
        if (response.data['code'] == 200) {
          showToast("更新成功", duration: Duration(seconds: 1));

          setState(() {
            // 更新 userInfoNotifier 以通知监听者
            Global.userInfoNotifier.value =
                User.fromJson(response.data['data']);
          });

          // 保存token
          final List<String> token =
              response.headers["Authorization"] as List<String>;
          Global.token = token.first;

          //持久化
          await SpUtils.saveString("token", Global.token!);

          if (isProduction) print("userInfo: ${Global.userInfo.toString()}");
          if (isProduction) print("token: ${Global.token}");

          await ImChatApi.getInstance().setSelfInfo(
              Global.userInfo!.userId.toString(),
              Global.userInfo!.nickName,
              Global.userInfo!.userAvatar,
              Global.userInfo!.userSex,
              Global.userInfo!.userType);

          _jumpToTab();
        } else {
          if (isProduction) print(response.data['message']);
          showToast(response.data['message'], duration: Duration(seconds: 1));
        }
      } else {
        if (isProduction) print("无法连接服务器");
        showToast("无法连接服务器", duration: Duration(seconds: 1));
      }
    } catch (e) {
      if (isProduction) print('Error: $e');
    }
  }

  Future<bool> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isGranted) {
      return true;
    } else {}
    return false;
  }

  Future<void> _selectAvatar() async {
    requestGalleryPermission();
    // 打开一个弹窗选择本地图片
    final pickedFile = await ImageUtils.getImage();

    // 在选择头像后更新状态
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile; // 更新选择的头像
        _avatarUrl = null; // 清空之前的头像URL，以便显示新选择的头像
      });
    }
  }

  //TODO:服务器上传头像
  //服务器上传头像
  // static Future<String> saveAvatar(
  //   XFile image,
  //   int userId,
  // ) async {
  //   String url = UrlPath.uploadAvatarUrl;
  // }

  void _saveChanges() async {
    // 创建一个新的 User 对象并更新
    User updatedUser = User(
      userId: Global.userInfo?.userId ?? 0,
      userName: Global.userInfo?.userName ?? '',
      nickName: _nickNameController.text,
      userPassword: Global.userInfo?.userPassword ?? '',
      userAvatar: _avatarUrl ?? '默认头像',
      userSex: _selectedSex,
      userPhoneNumber: Global.userInfo?.userPhoneNumber ?? '',
      createdTime: Global.userInfo?.createdTime ?? '',
      updatedTime: Global.userInfo?.updatedTime ?? '',
      loginIp: Global.userInfo?.loginIp ?? '',
      loginTime: Global.userInfo?.loginTime ?? '',
      userType: Global.userInfo?.userType ?? 0,
      userStatus: Global.userInfo?.userStatus ?? 0,
    );

    //更新后端数据
    _updateUserInfo(updatedUser);
  }

  @override
  void dispose() {
    _nickNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('个人资料编辑'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // 头像选择部分
          Center(
            child: GestureDetector(
              onTap: _selectAvatar,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _pickedFile != null // 优化头像显示逻辑
                    ? FileImage(File(_pickedFile!.path)) // 使用选择的头像
                    : _avatarUrl != null && _avatarUrl != '默认头像'
                        ? NetworkImage(_avatarUrl!+'?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                        : null,
                child: _pickedFile == null &&
                        (_avatarUrl == null || _avatarUrl == '默认头像')
                    ? Icon(Icons.person, size: 50)
                    : null, // 如果头像为空，显示默认头像
              ),
            ),
          ),
          SizedBox(height: 20),

          // 修改昵称输入框部分
          TextField(
            controller: _nickNameController,
            maxLength: _maxNickNameLength, // 添加最大长度限制
            decoration: InputDecoration(
              labelText: '昵称',
              border: OutlineInputBorder(),
              counterText:
                  '$_currentLength/$_maxNickNameLength', // 使用状态变量显示当前长度
            ),
          ),
          SizedBox(height: 20),

          // 性别选择
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('性别', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          title: Text('男'),
                          value: 1,
                          groupValue: _selectedSex,
                          onChanged: (value) {
                            setState(() => _selectedSex = value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          title: Text('女'),
                          value: 2,
                          groupValue: _selectedSex,
                          onChanged: (value) {
                            setState(() => _selectedSex = value!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 保存按钮
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white70,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  '保存修改',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
