import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/commission_page/detail/commission_detail_vm.dart';
import 'package:provider/provider.dart';

class CommissionDetailPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CommissionDetailPageState();
  }
}

class _CommissionDetailPageState extends State<CommissionDetailPage>{
  CommissionDetailViewModel _commissionDetailViewModel = CommissionDetailViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _commissionDetailViewModel;
        },
        child: Consumer(
            builder: (context, vm, child){
              return Scaffold(

              );
            }
        ),
    );
  }
}