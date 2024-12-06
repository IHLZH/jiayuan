import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_ui/styles/app_colors.dart';
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
  AiCustomerServiceViewModel viewModel = AiCustomerServiceViewModel();

  @override
  void initState() {
    super.initState();
    viewModel = AiCustomerServiceViewModel();
    viewModel.loadCachedMessages();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AiCustomerServiceViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor3, // 设置背景颜色
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45), // 设置高度
        child: Container(
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor3, // 设置背景颜色
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textColor2b), // 设置图标颜色
                      onPressed: () {
                        Navigator.of(context).pop(); // 返回上一页
                      },
                    ),
                    Text(
                      'AI智能助手',
                      style: TextStyle(
                        color: AppColors.textColor2b, // 设置标题颜色
                        fontSize: 20, // 设置标题字体大小
                        fontWeight: FontWeight.w500, // 设置标题字体粗细
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.textColor2b), // 设置图标颜色
                  onPressed: () async {
                    await viewModel.clearMessages();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Align(
                    alignment: message.isSelf ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: message.isSelf ? Colors.blue : Colors.grey[300], // 消息气泡颜色
                        borderRadius: BorderRadius.circular(12.0), // 圆角
                      ),
                      child: Column(
                        crossAxisAlignment: message.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: message.isSelf ? Colors.white : Colors.black, // 文字颜色
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            message.isSelf ? '用户' : 'AI',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: message.isSelf ? Colors.white : Colors.grey, // 文字颜色
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xffd3d3d3),
                  width: 0.5,
                ),
              ),
              color: AppColors.backgroundColor5, // 底部导航栏背景颜色
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
                        color: Colors.grey[300]!, // 边框颜色
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.greenAccent[700], // 发送按钮颜色
                  ),
                  child: TextButton(
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        await viewModel.sendMessage(_messageController.text);
                        _messageController.clear();
                        await viewModel.saveMessagesToCache();
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
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
    );
  }
}
