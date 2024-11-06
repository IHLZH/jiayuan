import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/dialog/loading.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';




class ChatPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatPage();
  }
}

class _ChatPage extends State<ChatPage>{
  @override
  Widget build(BuildContext context) {
    return Text("ChatPage");
  }
}

class LoadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<ChatPage>{

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Text("ChatPage");
  }
}
