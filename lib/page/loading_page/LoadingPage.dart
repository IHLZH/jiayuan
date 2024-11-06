import 'package:flutter/cupertino.dart';

import '../../common_ui/dialog/loading.dart';
import '../Test.dart';

class LoadingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoadingPage();
  }
}

class _LoadingPage extends State<LoadingPage>{

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Text("ChatPage");
  }

  @override
  void dispose() {
    super.dispose();
    Loading.dismissAll();
  }
}