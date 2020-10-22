include: "/external/business_logic.view.lkml"

view: sc_orders {

# adding pk and etc
 sql_table_name: @{table_orders}
;;

# -- (
# -- @{uuid_begin} from @{table_orders}
# -- )

  # pk defined and hidden
  # dimension: true_pk {
  #   type: string
  #   hidden: yes
  #   primary_key: yes
  #   sql: ${TABLE}.true_pk ;;
  # }

  # base dims
  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    primary_key: yes
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
  }


# bring in business logic
extends: [business_logic]
  }
