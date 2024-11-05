///数据表定义
class CreateTableSqls{
  //关系表语句
  static final String createTableSql_search_history = '''
    CREATE TABLE IF NOT EXISTS search_history (
    search_msg VARCHAR(255) NOT NULL
    );
    ''';

  Map<String,String> getAllTables(){
    Map<String,String> map = Map<String,String>();
    map['search_history'] = createTableSql_search_history;
    return map;
  }
}