import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/dialog/loading.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/page/chat_page/chat/chat_page_vm.dart';
import 'package:jiayuan/page/chat_page/group_info/group_info_page_vm.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/enum/v2_tim_conversation_marktype.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common_ui/styles/app_colors.dart';
import '../../../repository/model/commission_data1.dart';
import '../../../route/route_utils.dart';

class ChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage>{

  ChatPageViewModel _chatViewModel = ChatPageViewModel.instance;

  @override
  void initState() {
    super.initState();
    _chatViewModel.initScorllListener();
  }

  Future<void> _initChatMessage() async {
    await _chatViewModel.refreshChatMessage();
  }

  dispose(){
    super.dispose();
    _chatViewModel.clear();
    print("================= chatpage销毁 ====================");
  }

  bool getHasShowTime(int currentTimestamp, int previousTimestamp){
    // 获取当前时间和消息时间的日期对象
    final currentTime = DateTime.fromMillisecondsSinceEpoch(currentTimestamp * 1000);
    final previousTime = DateTime.fromMillisecondsSinceEpoch(previousTimestamp * 1000);
    final now = DateTime.now();

    // 判断是否显示时间
    bool shouldShowTime = false;
    if (previousTimestamp == 0) {
      // 如果没有上一条消息，则默认显示时间
      shouldShowTime = true;
    } else {
      // 计算时间差异
      final duration = currentTime.difference(previousTime);
      if (now.year == currentTime.year) {
        // 本年的消息，相差超过 1 分钟则显示时间
        shouldShowTime = duration.inMinutes > 1;
      } else {
        // 更久之前的消息，相差超过 1 个月则显示时间
        shouldShowTime = duration.inDays > 1;
      }
    }

    return shouldShowTime;
  }

  void _showPickerOptions(BuildContext context, int id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("从相册选择"),
                onTap: () {
                  Navigator.of(context).pop();
                  //_uploadFromGallery(id);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("使用相机拍照"),
                onTap: () {
                  Navigator.of(context).pop();
                  //_uploadFromCamera(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if(_chatViewModel.conversation == null || _chatViewModel.conversation != ModalRoute.of(context)?.settings.arguments as V2TimConversation){
      print("================= chatpage刷新 ====================");
      _chatViewModel.conversation = ModalRoute.of(context)?.settings.arguments as V2TimConversation;
      _chatViewModel.clearUnReadCount(_chatViewModel.conversation!);
      _initChatMessage();
    }

    return ChangeNotifierProvider.value(
        value: _chatViewModel,
        child: Consumer<ChatPageViewModel>(
            builder: (context, vm, child){
              return Scaffold(
                backgroundColor: AppColors.backgroundColor3,
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(45),
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColor3
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios_new),
                                    onPressed: () {
                                      RouteUtils.pop(context);
                                    },
                                  ),
                                  Text(
                                    vm.conversation?.showName ?? "",
                                    style: TextStyle(
                                        color: AppColors.textColor2b,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () {
                                  if(vm.conversation!.type == 1){
                                    vm.gotoFriendInfo(context, vm.conversation!.userID!);
                                  }else{
                                    vm.gotoGroupInfo(context, vm.conversation!.groupID!);
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                    )
                ),
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor3
                      ),
                      child: ListView.builder(
                          controller: vm.scrollController,
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: vm.chatMessageList.length,
                          itemBuilder: (context, index){
                            V2TimMessage message = vm.chatMessageList[index];
                            bool hasShowTime = false;
                            if(index != vm.chatMessageList.length - 1){
                              V2TimMessage preMessage = vm.chatMessageList[index + 1];
                              hasShowTime = getHasShowTime(message.timestamp ?? 0, preMessage.timestamp ?? 0);
                              //hasShowTime = true;
                            }else{
                              hasShowTime = true;
                            }
                            if(message.elemType != MessageElemType.V2TIM_ELEM_TYPE_GROUP_TIPS){
                              if(message.isSelf ?? true){
                                return selfMessage(message, hasShowTime);
                              }else{
                                return otherMessage(message, hasShowTime);
                              }
                            }else{
                              return systemMessage(message);
                            }
                          }
                      ),
                    ),
                    if(vm.isLoading)
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: AppColors.appColor,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.endColor),
                          ),
                        ),
                    ),
                  ],
                ),
                bottomNavigationBar: Builder(
                  builder: (context) {
                    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                    return Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: keyboardHeight),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xffd3d3d3),
                            width: 0.5
                          )
                        ),
                        color: AppColors.backgroundColor5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){

                              },
                              icon: Icon(Icons.add)
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                              ),
                              child: TextField(
                                controller: _chatViewModel.textController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none
                                ),
                              ),
                            )
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.greenAccent[700],
                            ),
                            child: TextButton(
                                onPressed: (){
                                  if(_chatViewModel.conversation!.type! == 1){
                                    _chatViewModel.sendSingMessage();
                                  }else{
                                    _chatViewModel.sendGroupMessage();
                                  }
                                  _chatViewModel.textController.clear();
                                },
                                child: Text(
                                  "发送",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
        ),
    );
  }

  Widget selfMessage(V2TimMessage message,bool hasShowTime){
    return Column(
      children: [
        if(hasShowTime)
          Center(
            child: Text(
              _chatViewModel.formatTimestamp(message.timestamp ?? 0) + " " + (_chatViewModel.formatTimestampToHours(message.timestamp ?? 0) ?? ""),
              style: TextStyle(
                  color: AppColors.textColor7d
              ),
            ),
          ),
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.nickName ?? "",
                              style: TextStyle(
                                  color: AppColors.textColor5a
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r)
                                ),
                                child: checkIfCommission(message.textElem?.text ?? "")
                            )
                          ],
                        )
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () async {
                        _chatViewModel.gotoUserInfo(context, Global.userInfo!.userId.toString());
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: message.faceUrl != "默认头像" ? CachedNetworkImageProvider(message.faceUrl!) : null
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ],
    );
  }

  Widget otherMessage(V2TimMessage message,bool hasShowTime){
    return Column(
      children: [
        if(hasShowTime)
          Center(
            child: Text(
              _chatViewModel.formatTimestamp(message.timestamp ?? 0) + " " + (_chatViewModel.formatTimestampToHours(message.timestamp ?? 0) ?? ""),
              style: TextStyle(
                  color: AppColors.textColor7d
              ),
            ),
          ),
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        _chatViewModel.gotoUserInfo(context, message.sender!);
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: message.faceUrl != "默认头像" ? CachedNetworkImageProvider(message.faceUrl!) : null
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (message.friendRemark != null && message.friendRemark != "") ? message.friendRemark! : message.nickName ?? "",
                              style: TextStyle(
                                  color: AppColors.textColor5a
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r)
                                ),
                                child: checkIfCommission(message.textElem?.text ?? "")
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ],
            )
        )
      ],
    );
  }

  Widget systemMessage(V2TimMessage message){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(180),
        borderRadius: BorderRadius.circular(8.r)
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Wrap(
        children: [
          Text(
            maxLines: null,
            _chatViewModel.getSystemMessage(message),
            style: TextStyle(
                color: AppColors.textColor2b,
                fontSize: 10.sp
            ),
          ),
        ],
      )
    );
  }

  Widget checkIfCommission(String message) {
    const prefixCommission = "@CommissionData:";
    const prefixKeeper = "@KeeperData:";

    if(message.startsWith(prefixCommission)){
      message = message.substring(prefixCommission.length);
      return FutureBuilder(
          future: _chatViewModel.getCommissionDetail(int.parse(message)),
          builder: (context, snapshot){
            // 根据snapshot的状态构建UI
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // 加载中的UI
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 错误时的UI
            } else if (snapshot.hasData) {
              return CommissionCard(snapshot.data!);
            } else {
              return Text('No data'); // 默认状态
            }
          }
      );
    }else if(message.startsWith(prefixKeeper)){
      message = message.substring(prefixKeeper.length);
      return FutureBuilder(
          future: _chatViewModel.getKeeperDetail(int.parse(message)),
          builder: (context, snapshot){
            // 根据snapshot的状态构建UI
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // 加载中的UI
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 错误时的UI
            } else if (snapshot.hasData) {
              return KeeperCard(snapshot.data!);
            } else {
              return Text('No data'); // 默认状态
            }
          }
      );
    }else{
      return Wrap(
        children: [
          Text(
            message ?? "",
            style: TextStyle(
              color: AppColors.textColor2b,
              fontSize: 16.sp,
            ),
          ),
        ],
      );
    }
  }

  Widget CommissionCard(CommissionData1 commission){
    return Container(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () async {
            CommissionData1 commissionDetail = await _chatViewModel.getCommissionDetail(commission.commissionId);
            RouteUtils.pushForNamed(
                context,
                RoutePath.commissionDetail,
                arguments: commissionDetail
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(10),
            height: 125.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          commission.commissionBudget.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "元",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.endColor,
                          borderRadius: BorderRadius.circular(16.r)
                      ),
                      child: Text(
                        commission.typeName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                        child: Text(
                          "内容：" + (commission.commissionDescription ?? "家政员招募中~"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 5.w,),
                    Text(
                      commission.county ?? "",
                      style: TextStyle(
                          color: AppColors.textColor2b,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Expanded(
                      child: Text(
                        commission.commissionAddress ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
                        style: TextStyle(
                            color: AppColors.textColor2b,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget KeeperCard(HousekeeperDataDetail housekeeper){
    return Container(
      //margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          // //设置插入策略
          // housekeeper.createdTime = DateTime.now();
          // housekeeper.userId = Global.userInfo?.userId;
          // await Global.dbUtil?.db.insert(
          //     'browser_history', housekeeper.toMap(),
          //     conflictAlgorithm: ConflictAlgorithm.replace);
          RouteUtils.pushForNamed(context, RoutePath.KeeperPage,
              arguments: housekeeper.keeperId);
        },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(),
            width: double.infinity,
            child: Column(
              children: [
                Row(children: [
                  Container(
                    height: 70,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(housekeeper.avatar!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(housekeeper.realName!,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("工作经验：${housekeeper.workExperience}年",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black)),
                              Text(
                                "服务评分：${housekeeper.rating}分",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ],
                          )))
                ]),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(233, 247, 237, 1), // 起始颜色
                        Color.fromRGBO(233, 247, 237, 0.3), // 结束颜色，透明度较低
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 5),
                      Text(
                        "亮点: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(87, 191, 169, 1),
                            fontSize: 12),
                      ),
                      Expanded(
                          child: Text(
                            " ${housekeeper.highlight}",
                            style: TextStyle(color: Colors.black45, fontSize: 12),
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}