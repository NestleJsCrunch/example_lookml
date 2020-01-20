include: "base_users.view.lkml"
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
    convert_tz: no
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
    }


  dimension: year_num {
    type: number
    sql: ${created_year} ;;
  }

  measure: max_year {
    type: max
    sql: ${year_num} ;;
  }

}
