import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiayuan/page/chat_page/conversation_page_vm.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';

import '../../common_ui/styles/app_colors.dart';
import '../../route/route_utils.dart';

class ConversationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ConversationPageState();
  }
}

class _ConversationPageState extends State<ConversationPage>{

  ConversationPageViewModel _conversationViewModel = ConversationPageViewModel.instance;

  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  Future<void> _initConversation() async {
    await _conversationViewModel.initConversationList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _conversationViewModel,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(70, 219, 201, 1), // 渐变起始颜色
                      Colors.white,      // 渐变结束颜色
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.sp),
                  height: 250.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        child: Text(
                          "消息",
                          style: TextStyle(
                              color: AppColors.textColor2b,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Builder(
                          builder: (context) =>GestureDetector(
                            onTap: () async {
                              final RenderBox button = context.findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;

                              // 获取按钮的全局位置
                              final Offset buttonPosition = button.localToGlobal(Offset.zero);
                              final Size buttonSize = button.size;

                              // 弹出菜单
                              final result = await showMenu<String>(
                                context: context,
                                position: RelativeRect.fromRect(
                                  // 菜单显示在图标正下方，稍微偏移按钮高度
                                  Rect.fromLTRB(
                                    buttonPosition.dx,
                                    buttonPosition.dy + buttonSize.height,
                                    buttonPosition.dx + buttonSize.width,
                                    buttonPosition.dy + buttonSize.height + 1,
                                  ),
                                  Offset.zero & overlay.size, // 屏幕范围
                                ),
                                items: [
                                  const PopupMenuItem<String>(
                                    value: '0',
                                    child: Text('好友/群组'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: '1',
                                    child: Text('加好友'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: '2',
                                    child: Text('创建群组'),
                                  ),
                                ],
                                color: Colors.white,
                                popUpAnimationStyle: AnimationStyle.noAnimation
                              );

                              if (result != null) {
                                switch(result){
                                  case '0':
                                    RouteUtils.pushForNamed(context, RoutePath.friendList);
                                    break;
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.more_horiz),
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                )
            )
        ),
        body: Consumer<ConversationPageViewModel>(
            builder: (context, vm, child){
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor3
                ),
                child: SmartRefresher(
                  controller: vm.refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  header: MaterialClassicHeader(
                    color: AppColors.appColor,
                    backgroundColor: AppColors.endColor,
                  ),
                  footer: ClassicFooter(
                    canLoadingText: "松开加载更多~",
                    loadingText: "努力加载中~",
                    noDataText: "已经到底了~",
                  ),
                  onLoading: vm.onLoading,
                  onRefresh: vm.onRefresh,
                  child: ListView.builder(
                      itemCount: vm.conversationList.length,
                      itemBuilder: (context, index){
                        return ConversationItem(vm.conversationList[index] ?? V2TimConversation(conversationID: "0"));
                      }
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget ConversationItem(V2TimConversation conversation){
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: (){
          RouteUtils.pushForNamed(context, RoutePath.chatPage, arguments: conversation);
        },
        child: Container(
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: AppColors.backgroundColor3
                    )
                )
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor3,
                    backgroundImage: conversation.faceUrl != "默认头像" ? CachedNetworkImageProvider(conversation.faceUrl!) : null
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conversation.showName ?? "",
                            style: TextStyle(
                                color: AppColors.textColor2b,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            conversation.lastMessage?.textElem?.text ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textColor7d,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        conversation.lastMessage != null ? _conversationViewModel.formatTimestamp(conversation.lastMessage!.timestamp!) : "",
                        style: TextStyle(
                          color: AppColors.textColor9A,
                          fontSize: 14.sp,
                        ),
                      ),
                      (conversation.unreadCount ?? 0) > 0 ? Container(
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.red
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp
                          ),
                        ),
                      ) : Container(
                        width: 16,
                        height: 16,
                      )
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}