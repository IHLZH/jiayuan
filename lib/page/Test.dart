import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';

/*
测试用
 */
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Text("HomePage");
  }
}

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

class MinePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MinePage();
  }
}

class _MinePage extends State<MinePage>{
  @override
  Widget build(BuildContext context) {
    return Text("MinePage");
  }
}