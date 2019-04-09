view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

  filter: FilteringYTD {
    type: string
  }

#   dimension: is_before_ytd {
#     type: yesno
#     sql: DAYOFYEAR(${date_date}) < DAYOFYEAR(CURRENT_DATE);;
#   }

  dimension: date_is_ytd {
    type: yesno
    sql:
    current_date() ;;

  }

  measure: count_filter {
    type: date
    sql:
    case
    when ${date_is_ytd} = yes
    then max(${created_date})
    else null
    end
  ;;

    }

}
