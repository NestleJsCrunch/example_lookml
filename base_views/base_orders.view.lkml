include: "/*/*.view.lkml"


view: orders {
  sql_table_name: demo_db_generator.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

dimension: date_month {
  type: date_month
  sql: ${TABLE}.created_at ;;
}

dimension: offset_month {
  type: date_month
  sql:  DATE_ADD(${TABLE}.created_at, INTERVAL 1 month) ;;
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

  dimension_group: created_date {
    type: time
    timeframes: [
      raw,
      date,
      month,
      quarter,
      year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.created_at ;;
    datatype: date
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
    drill_fields: [id,created_date,user_id]
    }


  dimension: year_num {
    type: number
    sql: ${created_year} ;;
  }

  measure: max_year {
    type: max
    sql: ${year_num} ;;
  }


  parameter: bad_param {
    type: string
    default_value: "Charles Schwab & Co., Inc.,"
  }
  dimension: bad_sql {
    type: string
    sql: 'Charles Schwab & Co., Inc.,' ;;
  }

  ### Praveen Test

  dimension: bad_status {
    type: string
    sql: ${status} ;;
    required_fields: [bucket_id]

  }

  dimension: bucket_id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: is_control_bad {
    type: yesno
    sql: ${user_id} > 400   ;;
    required_fields: [bucket_id]
  }

  dimension: is_control_good {
    type: yesno
    sql: ${user_id} > 400   ;;
#     required_fields: [bucket_id]
  }


}
