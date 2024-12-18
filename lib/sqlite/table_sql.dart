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

  static final String createTableSql_commission_browser_history = '''
      CREATE TABLE IF NOT EXISTS commission_history (
      commissionId INTEGER,
      userId INTEGER,
      keeperid INTEGER,
      )
  ''';

  static final String createTableSql_commission_history = '''
      CREATE TABLE IF NOT EXISTS commission_browser_history (
      uid INTEGER,
      userId INTEGER,
      keeperId INTEGER,
      commissionId INTEGER PRIMARY KEY,
      commissionBudget DOUBLE,
      commissionDescription TEXT,
      province VARCHAR(255), 
      city VARCHAR(255), 
      county VARCHAR(255),
      commissionAddress VARCHAR(255),
      userName VARCHAR(255),
      userAvatar VARCHAR(255),
      typeId INTEGER,
      typeName VARCHAR(255),
      userPhoneNumber VARCHAR(255),
      createTime VARCHAR(255),
      updatedTime VARCHAR(255),
      expectStartTime VARCHAR(255),
      realStartTime VARCHAR(255),
      endTime VARCHAR(255),
      browerTime VARCHAR(255),
      commissionStatus INTEGER,
      distance DOUBLE,
      isLong INTEGER,
      days INTEGER,
      specifyServiceTime INTEGER
      )
  ''';

  Map<String, String> getAllTables() {
    Map<String, String> map = Map<String, String>();
    map['search_history'] = createTableSql_search_history;
    map['tbl_user'] = createTableSql_tbl_user;
    map['browser_history'] = createTableSql_browser_history;
    map['commission_history'] = createTableSql_commission_history;
    return map;
  }
}
