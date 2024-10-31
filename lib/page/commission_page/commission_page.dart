import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jiayuan/common_ui/app_bar/app_search_bar.dart';
import 'package:jiayuan/common_ui/navigation/navigation_bar_widget.dart';
import 'package:jiayuan/page/Test.dart';
import 'package:jiayuan/page/commission_page/commission_vm.dart';
import 'package:provider/provider.dart';

class CommissionPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionPageState();
  }
}

class _CommissionPageState extends State<CommissionPage>{

  final CommissionViewModel _viewModel = CommissionViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _viewModel;
        },
        child: Scaffold(
          body: Column(
            children: [

            ],
          ),
        ),
    );
  }
}