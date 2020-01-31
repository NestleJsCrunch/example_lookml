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

  dimension: good_date {
    type: date_time
    sql: date_add(${created_raw},1) ;;
  }

  measure: filtered_measure {
    type: count
    filters: {field:status value: "'complete','pending'"}
  }


  filter: date_filter {
    type: date
  }

  dimension: filtered_date {
    type: date
    sql: {% condition date_filter %} ${created_date} {% endcondition %} ;;
  }

  dimension: filtered_date2 {
    type: date
    sql: {% if date_filter._value == created_date %} ${created_date}
    {% endif %};;
  }

  dimension: filtered_date3 {
    type: date
    sql: case when  {{ }}date_filter._value }} = ${created_date} then ${created_date} else null end;;
  }

  set: bigbad {
    fields: [created_date,id,count]
  }

  set: bigbad2 {
    fields: [count,id,created_date]
  }

  measure: first_drill {
    type: count
    drill_fields: [bigbad*]
  }

  measure: 2_drill {
    type: count
    drill_fields: [bigbad2*]
  }


}

explore: new_orders {
  from: orders
}
