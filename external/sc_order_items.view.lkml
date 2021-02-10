view: sc_order_items {

  # adding pk and etc
  sql_table_name: @{table_oitems}
  ;;

# --  (
# --  @{uuid_begin} from @{table_items}
# --  )

    # dimension: true_pk {
    #   type: string
    #   hidden: yes
    #   primary_key: yes
    #   sql: ${TABLE}.true_pk ;;
    # }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    primary_key: yes
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

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, inventory_items.id, orders.id]
  }
}
