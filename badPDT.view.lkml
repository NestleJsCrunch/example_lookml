include: "base_orders.view.lkml"

view: badpdt {
  derived_table: {sql: select * from ${orders.SQL_TABLE_NAME} ;;
    persist_for: "30 minutes"}

  dimension: id {}

  }
  explore: badpdt {}
