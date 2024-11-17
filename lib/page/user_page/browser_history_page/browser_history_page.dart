import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../repository/model/Housekeeper _data.dart';
import '../../../route/route_path.dart';
import '../../../route/route_utils.dart';
import '../../../utils/global.dart';
import 'browser_history_vim.dart';


class BrowseHistoryPage extends StatefulWidget {
  const BrowseHistoryPage({super.key});

  @override
  State<BrowseHistoryPage> createState() => _BrowseHistoryPageState();
}

class _BrowseHistoryPageState extends State<BrowseHistoryPage> {
  BrowseHistoryViewModel browseHistoryViewModel = BrowseHistoryViewModel();
  void initState() {
    super.initState();
    browseHistoryViewModel.getBrowseHistory();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: browseHistoryViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text("浏览过的家政员"),
          centerTitle: true,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Consumer<BrowseHistoryViewModel>(
            builder: (context,value,child){
              return ListView.builder(
                itemCount: value.browseHistory.length,
                itemBuilder: (context,index){
                  return _buildHousekeeperCard(value.browseHistory[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  //家政员推荐卡片
  Widget _buildHousekeeperCard(Housekeeper housekeeper) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3,
        borderOnForeground: true,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () async{
            housekeeper.createdTime = DateTime.now();
            housekeeper.userId = Global.userInfo?.userId;
            await Global.dbUtil?.db.insert('browser_history', housekeeper.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
            RouteUtils.pushForNamed(
                context,
                RoutePath.KeeperPage,
                arguments: housekeeper.keeperId
            );
          },
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      height: 70,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(housekeeper.avatar!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(housekeeper.realName!,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("工作经验：${housekeeper.workExperience}年",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                                Text(
                                  "服务评分：${housekeeper.rating}分",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ],
                            )))
                  ]),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(233, 247, 237, 1), // 起始颜色
                          Color.fromRGBO(233, 247, 237, 0.3), // 结束颜色，透明度较低
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 5),
                        Text(
                          "亮点: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(87, 191, 169, 1),
                              fontSize: 12),
                        ),
                        Expanded(
                            child: Text(
                              " ${housekeeper.highlight}",
                              style: TextStyle(color: Colors.black45,
                                  fontSize: 12),
                            ))
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

}
