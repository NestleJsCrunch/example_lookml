view: triggering {

derived_table: {
  sql:
  select * from demo_db.order_items limit 100 ;;
  persist_for: "1000 hours"
  indexes: ["id"]
}

dimension: id {
  type: number
  sql: ${TABLE}.id ;;
}
}

datagroup: newtrigger {
  sql_trigger: count(*) from triggering.SQL_TABLE_NAME ;;
}

explore: testing_these_things{
  from: triggering
}

view: triggering2 {

  derived_table: {
    sql:
      select * from demo_db.order_items limit 100 ;;
    persist_for: "1000 hours"
    indexes: ["id"]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }
}

datagroup: newtrigger2 {
  sql_trigger: count(*) from triggering.SQL_TABLE_NAME ;;
}

explore: testing_these_things2{
  from: triggering
}
