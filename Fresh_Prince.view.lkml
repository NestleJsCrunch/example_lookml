view: fresh_prince {
derived_table: {
  sql:
  select created_at, o.id as ooid, user_id, status, oi.id as oid, order_id, sale_price
  from demo_db_generator.orders o
  join demo_db_generator.order_items oi on oi.id = o.id
  ;;
}

dimension: ooid {}

measure: count {
  type: count
}

dimension_group: created_at {
  type: time
  sql: ${TABLE}.created_at ;;
}

dimension: user_id {}

dimension: status {}

dimension: oid {}

measure: sale_price {
  type: sum
  sql: ${TABLE}.sale_price;;
}


 }

explore: fresh_prince {}
