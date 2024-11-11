import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/certified_page/keeper/keeper_certified_page_vm.dart';
import 'package:provider/provider.dart';
/*
家政员认证页面
 */
class KeeperCertifiedPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _KeeperCertifiedPageState();
  }
}

class _KeeperCertifiedPageState extends State<KeeperCertifiedPage>{
  KeeperCertifiedPageViewModel _keeperViewModel = KeeperCertifiedPageViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context){
          return _keeperViewModel;
        },
        child: Consumer<KeeperCertifiedPageViewModel>(
            builder: (context, vm, child){
              return Scaffold(

              );
            }
        ),
    );
  }
}