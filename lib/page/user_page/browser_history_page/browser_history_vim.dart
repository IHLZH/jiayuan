import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:sqflite/sqflite.dart';

class BrowseHistoryViewModel with ChangeNotifier{
  List<Housekeeper> browseHistory = [];


  Future<void> getBrowseHistory()async{
    final result =  await Global.dbUtil?.db.query('browser_history',orderBy: 'createdTime DESC');
    browseHistory = result!.map((e) => Housekeeper.fromMap(Map.from(e))).toList();
    browseHistory.forEach((item)=> print(item.createdTime));
    notifyListeners();
  }
}