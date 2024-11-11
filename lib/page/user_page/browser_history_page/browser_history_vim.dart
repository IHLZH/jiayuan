import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:sqflite/sqflite.dart';

class BrowseHistoryViewModel with ChangeNotifier{
  List<Housekeeper> browseHistory = [];

  Future<void> insertBrowseHistory(Housekeeper housekeeper)async{
    await Global.dbUtil?.open();
    //设置插入策略
    await Global.dbUtil?.db.insert('browser_history', housekeeper.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await Global.dbUtil?.close();
    notifyListeners();
  }

  Future<void> getBrowseHistory()async{
    await Global.dbUtil?.open();
    final result =  await Global.dbUtil?.db.query('browser_history',orderBy: 'createdTime');
    browseHistory = result!.map((e) => Housekeeper.fromMap(Map.from(e))).toList();
    browseHistory.forEach((item)=> print(item.createdTime));
    await Global.dbUtil?.close();
    notifyListeners();
  }
}