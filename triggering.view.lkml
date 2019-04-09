view: triggering {

derived_table: {
  sql:
  select * from demo_db.order_items ;;
  persist_for: "1000 hours"
}

dimension: id {
  type: number
  sql: ${TABLE}.id ;;
}
}

datagroup: newtrigger {
  sql_trigger: count(*) from triggering.SQL_TABLE_NAME ;;
}
