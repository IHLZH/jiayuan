import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    viewModel.loadCachedMessages();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AiCustomerServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI智能助手'),
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
                        color: message.isSelf ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            message.isSelf ? '我' : 'AI',
                            style: TextStyle(fontSize: 12.0, color: Colors.grey),
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
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await viewModel.sendMessage(_messageController.text);
                      _messageController.clear();
                      await viewModel.saveMessagesToCache();
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration.collapsed(hintText: "发送消息"),
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
