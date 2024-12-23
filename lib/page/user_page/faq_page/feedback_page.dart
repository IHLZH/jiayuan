import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/user_page/faq_page/faq_page_vm.dart';
import 'package:provider/provider.dart';

import '../../order_page/evaluation_page/evalutation_vm.dart';

class FeedBackPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return FaqViewModel();
        },
        child: Scaffold(),
    );
  }
}

