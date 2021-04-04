
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
      day_of_week_index,
      week_of_year
    ]
    sql: ${TABLE}.created_at ;;
    }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "foo"
      url: "/explore/derpinthesme/orders?blahblah"
    }
}

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

parameter: arbitrary {
  type: string
  allowed_value: {label:"a" value:"a"}
  allowed_value: {label:"b" value:"b"}

}
  measure: count {
    type: count
    }

### scratchpad ###

parameter: foo {
  type: string
  allowed_value: {
    label: "FU Bar"
    value: "fubar"
  }
  allowed_value: {
    label: "Bu Far"
    value: "bu_far"
  }
}

dimension: doesitwork {
  type: string
  sql: {% parameter foo %} ;;
}

measure: badmaybe {
  type: date_time
  sql: max(${created_time}) ;;
  html: {{rendered_value | date: "%D %r"}} ;;

}
}
