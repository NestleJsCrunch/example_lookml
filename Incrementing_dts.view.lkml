view: incrementing_dts {
derived_table: {
  sql:
  select id
  from demo_db.orders ;;
  datagroup_trigger: new_datagroup
}
dimension: id {}
measure: count {
  type: count
}
}
view: incrementing_dts2 {
  derived_table: {
    sql: select *
    from ${incrementing_dts.SQL_TABLE_NAME} ;;
    datagroup_trigger: new_datagroup
  }
  dimension: id {}
}
explore: incrementing_dts2 {}

datagroup: new_datagroup {
  sql_trigger: SELECT HOUR(CURTIME())
 ;;
}
