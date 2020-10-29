view: orders {
  sql_table_name:
 @{table_orders}
  ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: formatting {
    type: sum
    sql: ${id} * 1.1 ;;
    html:
    {% if value>0 %}
    <div style="background-color:green;color:white">{{ rendered_value }}</div>
    {% elsif value<0 %}
    <div style="background-color:red;color:white">{{ rendered_value }}</div>
    {% elsif value==0 %}
    <div style="background-color:yellow;color:white">{{ rendered_value }}</div>
    {% endif %};;
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

  dimension: yesno_field {
    type: yesno
    sql: ${status} = 'complete';;
  }

  dimension: some_other_field {
    type: yesno
    sql: ${status} = 'complete';;
  }

  measure: only_complete {
    type: count
    filters: [yesno_field: "yes",some_other_field: "yes"]
  }

  parameter: yesnoparam {
    type: yesno
    default_value: "yes"
  }

  parameter: yesnoparam2 {
    type: yesno
    default_value: "Yes"
  }

  dimension: yesnoparam3 {
    type: string
    sql:
    {% parameter yesnoparam %};;
  }

  dimension: yesnoparam4 {
    type: string
    sql:
    {% parameter yesnoparam2 %};;
  }

  dimension: yesnodim {
    type: yesno
    sql:
    {% if yesnoparam._is_filtered %}
    {% parameter yesnoparam %}
    {% else %}
    yes
    {% endif %}
    ;;
  }

  dimension: testarray {
    type: string
    sql:  JSON_ARRAY(orders.status, 'foo') ;;
  }

}
