///数据表定义
class CreateTableSqls{
  //关系表语句
  static final String createTableSql_search_history = '''
    CREATE TABLE IF NOT EXISTS search_history (
    search_msg VARCHAR(255) NOT NULL
    );
    ''';

  static final String createTableSql_tbl_user = '''
  CREATE TABLE IF NOT EXISTS tbl_user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    userName TEXT NOT NULL,
    nickName TEXT NOT NULL,
    userPassword TEXT NOT NULL,
    userAvatar TEXT NOT NULL,
    userSex INTEGER NOT NULL,
    userPhoneNumber TEXT NOT NULL,
    dailyPhoneNumber TEXT,
    email TEXT,
    createdTime TEXT NOT NULL,
    updatedTime TEXT NOT NULL,
    lng TEXT,
    lat TEXT,
    loginIp TEXT NOT NULL,
    loginTime TEXT NOT NULL,
    userType INTEGER NOT NULL,
    userStatus INTEGER NOT NULL
  )
  ''';

  Map<String,String> getAllTables(){
    Map<String,String> map = Map<String,String>();
    map['search_history'] = createTableSql_search_history;
    map['tbl_user'] = createTableSql_tbl_user;
    return map;
  }
}