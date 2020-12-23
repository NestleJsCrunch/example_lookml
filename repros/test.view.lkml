view: test {
 derived_table: {
   sql: select * from foo ;;
 }
}

view: test2 {
  derived_table: {
    sql: select * from ${test.SQL_TABLE_NAME} ;;
  }
dimension: bar {}
}

explore: test2 {}
