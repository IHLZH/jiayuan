///数据表定义
class CreateTableSqls {
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

  static final String createTableSql_browser_history = '''
      CREATE TABLE IF NOT EXISTS browser_history (
      keeperid INTEGER ,
      realName VARCHAR(255) NOT NULL,
      age INTEGER NOT NULL,
      avatar VARCHAR(255) NOT NULL,
      workExperience INTEGER NOT NULL,
      highlight VARCHAR(255) NOT NULL,
      rating DOUBLE NOT NULL,
      createdTime VARCHAR(255) NOT NULL,
      userId INTEGER,
      PRIMARY KEY (userId,keeperid))
      ''';

  Map<String, String> getAllTables() {
    Map<String, String> map = Map<String, String>();
    map['search_history'] = createTableSql_search_history;
    map['tbl_user'] = createTableSql_tbl_user;
    map['browser_history'] = createTableSql_browser_history;
    return map;
  }
}
