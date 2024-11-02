
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/commission_page/type/commission_type_vm.dart';
import 'package:provider/provider.dart';

class CommissionTypePage extends StatefulWidget{

  final int id;

  CommissionTypePage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _CommissionTypePageState();
  }
}

class _CommissionTypePageState extends State<CommissionTypePage>{

  CommissionTypeViewModel _commissionTypeViewModel = CommissionTypeViewModel();

  @override
  void initState() {
    super.initState();
    _commissionTypeViewModel.getType(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return _commissionTypeViewModel;
      },
      child: Consumer<CommissionTypeViewModel>(
          builder: (context, vm, child){
            return Scaffold(
              appBar: AppBar(
                title: Text(vm.typeText ?? "服务"),
              ),
            );
          }
      ),
    );
  }
}