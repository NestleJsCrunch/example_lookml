#########
# view type: base
# Base view for the dynamic fields views. This contains all base fields and simple transformations that the dynamic views will use.
########


view: base_dynamic {

 derived_table: {

sql:
SELECT orders.id as "order_id", orders.created_at as "order_created", orders.status as "order_status", orders.user_id as "order_user", oitems.id as "item_id", oitems.inventory_item_id as "inventory_id", oitems.returned_at as "returned_date", oitems.sale_price as "sale_price", oitems.sale_price*0.81 as "item_cost"
FROM @{table_orders} orders
LEFT JOIN @{table_oitems} oitems on oitems.order_id = orders.id

;;
}


  # base fields
  dimension: id {
    type: number
    sql: ${TABLE}.order_id ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.order_created ;;
    hidden: yes
  }

  dimension: status {
    type: string
    sql: ${TABLE}.order_status ;;
    hidden: yes
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.order_user ;;
    hidden: yes
  }

  dimension: item_id {
    type: number
    sql:${TABLE}.item_id ;;
    hidden: yes
  }

  dimension: inventory_id {
    type: number
    sql: ${TABLE}.inventory_id ;;
    hidden: yes
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.returned_date ;;
    hidden: yes
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    hidden: yes
  }

  dimension: item_cost {
    type: number
    sql: ${TABLE}.item_cost ;;
    hidden: yes
  }

  # simple transformations

  dimension_group: order_to_returned {
    type: duration
    sql_start: ${created_raw} ;;
    sql_end: ${returned_raw} ;;
    hidden: yes

    description: "The difference between order_created and order_returned"
  }

  measure: average_returned_days {
    type: average
    sql: ${days_order_to_returned} ;;
    hidden: yes

    description: ""
  }

  measure: total_returned_days {
    type: sum
    sql: ${days_order_to_returned} ;;
    hidden: yes

    description: ""
  }



  }
