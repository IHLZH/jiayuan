import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/certified_page/keeper/keeper_certified_page_vm.dart';
import 'package:provider/provider.dart';

import 'cert_certified_page_vm.dart';
/*
证书认证页面
 */
class CertCertifiedPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CertCertifiedPageState();
  }
}

class _CertCertifiedPageState extends State<CertCertifiedPage>{
  CertCertifiedPageViewModel _CertViewModel = CertCertifiedPageViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){
        return _CertViewModel;
      },
      child: Consumer<CertCertifiedPageViewModel>(
          builder: (context, vm, child){
            return Scaffold(

            );
          }
      ),
    );
  }
}