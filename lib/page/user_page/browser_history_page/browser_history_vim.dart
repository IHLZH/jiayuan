import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/api/commission_api.dart';
import 'package:jiayuan/repository/model/Housekeeper%20_data.dart';
import 'package:jiayuan/repository/model/commission_data1.dart';
import 'package:jiayuan/route/route_path.dart';
import 'package:jiayuan/route/route_utils.dart';
import 'package:jiayuan/utils/global.dart';
import 'package:jiayuan/utils/location_data.dart';
import 'package:sqflite/sqflite.dart';

class BrowseHistoryViewModel with ChangeNotifier{
  List<Housekeeper> browseHistory = [];


  Future<void> getBrowseHistory()async{
    //,
    final result =  await Global.dbUtil?.db.query('browser_history',orderBy: 'createdTime DESC',where: 'userId = ?',whereArgs: [Global.userInfo?.userId]);
    browseHistory = result!.map((e) => Housekeeper.fromMap(Map.from(e))).toList();
    browseHistory.forEach((item)=> print(item.createdTime));
    notifyListeners();
  }

  Future<void> deleteAllBrowseHistory()async{
     final result = await Global.dbUtil?.db.delete('browser_history');
     if(result != null){
       browseHistory.clear();
     }
     notifyListeners();
  }
}