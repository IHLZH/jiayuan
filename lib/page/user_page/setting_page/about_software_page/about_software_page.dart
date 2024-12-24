import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/user_page/setting_page/about_software_page/about_software_vm.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/constants.dart';

import '../../../../common_ui/styles/app_colors.dart';

bool isProduction = Constants.IS_Production;

class AboutSoftwarePage extends StatefulWidget {
  const AboutSoftwarePage({Key? key}) : super(key: key);

  @override
  _AboutSoftwarePageState createState() => _AboutSoftwarePageState();
}

class _AboutSoftwarePageState extends State<AboutSoftwarePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor5,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("关于软件"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.center,
          height: 800,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 150),
              // 软件图标（图片）
              Image.asset(
                'assets/images/icons/appIcon.png', // 替换为你的图片路径
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              // 软件版本
              Text(
                '版本: ' + (AboutSoftwareVm.version ?? '未知'),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              // 开发人员总览
              Container(
                width: 220,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "开发人员: ",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    ),
                    Container(
                      width: 140,
                      child: Text(
                        '${AboutSoftwareVm.developer!.join(", ")}',
                        style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.9)),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              // 代码仓库地址（可点击的图标按钮）
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: '点击前往代码仓库',
                    icon: Image.asset(
                      'assets/images/icons/github.png', // 替换为你的 GitHub 图标路径
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // 打开代码仓库地址
                      RouteUtils.pushForNamed(context, RoutePath.webViewPage,
                          arguments: {
                            'url': AboutSoftwareVm.repoUrl,
                          });
                    },
                  ),
                  Text(
                    "@jiayuan_code",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
