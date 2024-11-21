import 'package:flutter/cupertino.dart';
import 'package:jiayuan/page/chat_page/chat/chat_page_vm.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage>{

  ChatPageViewModel _chatViewModel = ChatPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}