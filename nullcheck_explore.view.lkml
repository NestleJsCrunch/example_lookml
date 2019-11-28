view: nullcheck_explore {
  # You can specify the table name if it's different from the view name:
sql_table_name: demo_db.order_items ;;

### Automatically generated dimensions from your sql_table specified above
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }

### Let's build the nullcheck!

dimension: nullcheck {
  type: yesno
  sql: isnull(${orders.id})
  ;;
}

measure: nullcheck_measure {
  type: sum
  sql: CASE
  WHEN ${nullcheck} = 'yes'
  THEN 1
  ELSE 0
  END;;
}

measure: nullcheck_percent {
  type: number
  sql: ${nullcheck_measure} / ${count} ;;
}
  }
