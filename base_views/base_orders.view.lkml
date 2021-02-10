
view: base_orders {
  extension: required
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
    link: {
      label: "test"
      url: "/dashboards/87"
    }
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
  }

parameter: test {
  type: string
  allowed_value: {label:"a" value:"a"}
  allowed_value: {label: "b" value:"b"}
}

dimension: testy {
  type: string
  sql:
  {% if test._parameter_value == "'a'"%}
  'success'
  {% else %}
  'get owned sucker'
  {% endif %} ;;
}

measure: ag {
  type: average
  sql: ${id} ;;
}
}
