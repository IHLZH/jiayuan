import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/repository/model/message_comission.dart';
import 'package:provider/provider.dart';

// import 'package:keyboard_avoider/keyboard_avoider.dart';

import '../../common_ui/styles/app_colors.dart';
import '../../repository/model/message_keeper.dart';
import '../../route/route_path.dart';
import '../../route/route_utils.dart';
import '../../utils/constants.dart';
import 'ai_customer_service_vm.dart';

bool isProduction = Constants.IS_Production;

class AiCustomerServicePage extends StatefulWidget {
  const AiCustomerServicePage({Key? key}) : super(key: key);

  @override
  _AiCustomerServicePageState createState() => _AiCustomerServicePageState();
}

class _AiCustomerServicePageState extends State<AiCustomerServicePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AiCustomerServiceViewModel viewModel = AiCustomerServiceViewModel();
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    viewModel = AiCustomerServiceViewModel();
    viewModel.loadCachedMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 滚动到列表底部
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  // 构建委托简要消息
  Widget _buildComissionMessageItem(BuildContext context, Object obj) {
    MessageCommission commissionData;
    if (obj is Map<String, dynamic>) {
      commissionData = viewModel.parseCommission(obj);
    } else {
      commissionData = obj as MessageCommission;
    }
    return GestureDetector(
      onTap: () async {
        // 处理点击事件，跳转到详情页面
        CommissionData1 commissionData1 = await CommissionApi.instance.getCommissionById({'commissionId':commissionData.commissionId});

        RouteUtils.pushForNamed(context, RoutePath.commissionDetail,arguments: commissionData1);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "委托id: ${commissionData.commissionId}",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "服务名称: ${commissionData.serviceName}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "预算: ${commissionData.commissionBudget}元",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "期望开始时间: ${commissionData.expectStartTime.toString().substring(0, 19)}",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 构建家政员简要消息
  Widget _buildKeeperMessageItem(BuildContext context, Object obj) {
    MessageKeeper keeperData;
    if (obj is Map<String, dynamic>) {
      keeperData = MessageKeeper.fromJson(obj);
    } else {
      keeperData = obj as MessageKeeper;
    }

    return GestureDetector(
      onTap: () {
        // 处理点击事件，跳转到详情页面
        final res = RouteUtils.pushForNamed(context, RoutePath.KeeperPage,arguments: keeperData.keeperId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(keeperData.avatar),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keeperData.realName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        'Keeper ID: ${keeperData.keeperId}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '完成任务数: ${keeperData.completeSingularNumber}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '平均评分: ${keeperData.averageRating}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AiCustomerServiceViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor3,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: Container(
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor3,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new,
                          color: AppColors.textColor2b),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'AI智能助手',
                      style: TextStyle(
                        color: AppColors.textColor2b,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.textColor2b),
                  onPressed: () async {
                    await viewModel.clearMessages();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // 点击空白处收起键盘
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 150,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      child: Align(
                        alignment: message.aiMessage.isSelf
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: message.aiMessage.isSelf
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: message.aiMessage.isSelf
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // 使用 switch 语句处理不同类型的消息
                              switch (message.type) {
                                '委托id' => ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: message.data.length,
                                    itemBuilder: (context, index) {
                                      return _buildComissionMessageItem(
                                          context, message.data[index]);
                                    },
                                  ),
                                '家政员id' => ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: message.data.length,
                                    itemBuilder: (context, index) {
                                      return _buildKeeperMessageItem(
                                          context, message.data[index]);
                                    },
                                  ),
                                _ => SelectableText(
                                    message.aiMessage.message,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: message.aiMessage.isSelf
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                              },
                              Text(
                                message.aiMessage.isSelf ? '用户' : 'AI',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: message.aiMessage.isSelf
                                        ? Colors.white
                                        : Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xffd3d3d3),
                      width: 0.1,
                    ),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        child: TextField(
                          enabled: true,
                          controller: _messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.greenAccent[700],
                      ),
                      child: TextButton(
                        onPressed: isSending
                            ? null
                            : () async {
                                if (_messageController.text.isNotEmpty &&
                                    !isSending) {
                                  setState(() {
                                    isSending = true;
                                  });
                                  await viewModel
                                      .sendMessage(_messageController.text);
                                  _messageController.clear();
                                  await viewModel.saveMessagesToCache();
                                  setState(() {
                                    isSending = false;
                                  });
                                  // 发送消息后滚动到底部
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent + 100000,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: isSending
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              )
                            : Text(
                                "发送",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
