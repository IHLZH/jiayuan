import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/common_ui/input/app_input.dart';
import 'package:jiayuan/page/chat_page/chat/chat_page_vm.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../../common_ui/styles/app_colors.dart';
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
    await _chatViewModel.getChatMessage();
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

  @override
  Widget build(BuildContext context) {

    _chatViewModel.conversation = ModalRoute.of(context)?.settings.arguments as V2TimConversation;
    _initChatMessage();

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
                                    vm.conversation.showName ?? "",
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
                            if(message.isSelf ?? true){
                              return selfMessage(message, hasShowTime);
                            }else{
                              return otherMessage(message, hasShowTime);
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
                                  _chatViewModel.sendSingMessage();
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
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
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
                          child: Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    message.textElem?.text ?? "",
                                    style: TextStyle(
                                      color: AppColors.textColor2b,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              )
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(width: 10,),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: message.faceUrl != null ? Image.network(message.faceUrl!) : Image.asset("assets/images/upload.png"),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget otherMessage(V2TimMessage message,bool hasShowTime){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: message.faceUrl != null ? Image.network(message.faceUrl!) : Image.asset("assets/images/upload.png"),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  message.textElem?.text ?? "",
                                  style: TextStyle(
                                    color: AppColors.textColor2b,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            )
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ],
      )
    );
  }
}