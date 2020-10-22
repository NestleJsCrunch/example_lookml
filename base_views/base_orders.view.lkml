view: orders {
  sql_table_name:
 @{table_orders}
  ;;

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
      year,
      day_of_month,
      month_num,
      day_of_week,
      day_of_week_index
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

  parameter: t1 {
    type: number
  }

  parameter: t2 {}

  measure: yn {
    type: string
    sql:
    case when
    {% parameter t1 %} > ${count}
    then 'yes'
    else 'no'
    end ;;
  }

  dimension: s {
    type: number
    sql: CAST(${created_year} as INT) ;;
    value_format: "0"
  }

}
