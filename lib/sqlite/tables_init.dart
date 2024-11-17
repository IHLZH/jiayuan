import 'package:jiayuan/sqlite/table_sql.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/constants.dart';

class TablesInit {
  static late Database db;
  static final version = 2;

  //是否更新数据库
  bool isUpdate = true;

  Future init() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, Constants.DB_NAME);
    print('数据库存储路径path:' + path);
    //所有的sql语句
    CreateTableSqls sqlTables = CreateTableSqls();
    //所有的sql语句
    Map<String, String> allTableSqls = sqlTables.getAllTables();
    try {
      db = await openDatabase(path);
    } catch (e) {
      print('CreateTables init Error $e');
    }
    //检查需要生成的表
    List<String> noCreateTables = await getNoCreateTables(allTableSqls);
    print('noCreateTables:' + noCreateTables.toString());
    if (noCreateTables.length > 0 || isUpdate) {
      //创建新表
      // 关闭上面打开的db，否则无法执行open
      db.close();
      db = await openDatabase(path, version: version,
          onCreate: (Database db, int version) async {
        print('db created version is $version');
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion <  2) {
          await db.execute('DROP TABLE browser_history');
          await db.execute(CreateTableSqls.createTableSql_browser_history);
        }
      }, onOpen: (Database db) async {
        noCreateTables.forEach((sql) async {
          await db.execute(allTableSqls[sql] ?? "");
        });
        print('db补完表已打开');
      });
    } else {
      print("表都存在，db已打开");
    }
    List tableMaps = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    print('所有表:' + tableMaps.toString());
    //browser_history 表的所有字段名
    List columnMaps = await db.rawQuery('PRAGMA table_info(browser_history)');
    print('browser_history 所有字段:' + columnMaps.toString());
    db.close();
    print("db已关闭");
  }

  // 检查数据库中是否有所有有表,返回需要创建的表
  Future<List<String>> getNoCreateTables(Map<String, String> tableSqls) async {
    Iterable<String> tableNames = tableSqls.keys;
    //已经存在的表
    List<String> existingTables = [];
    //要创建的表
    List<String> createTables = [];
    List tableMaps = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    print('tableMaps:' + tableMaps.toString());
    tableMaps.forEach((item) {
      existingTables.add(item['name']);
    });
    tableNames.forEach((tableName) {
      if (!existingTables.contains(tableName)) {
        createTables.add(tableName);
      }
    });
    return createTables;
  }
}
