# include: "/*/*.view.lkml"

view: fresh_prince {
derived_table: {
  sql:
  select created_at, o.id as ooid, user_id, status, oi.id as oid, order_id, sale_price
  from demo_db_generator.orders o
  join demo_db_generator.order_items oi on oi.id = o.id
  ;;
}

dimension: ooid {}

measure: count {
  type: count
}

dimension_group: created_at {
  type: time
  sql: ${TABLE}.created_at ;;
}

dimension: user_id {}

dimension: status {}

dimension: oid {}

measure: sale_price {
  type: sum
  sql: ${TABLE}.sale_price;;
}

measure: liquid_nodim {
  type: sum
  sql: ${TABLE}.sale_price ;;
  html:
  {% if liquid_nodim._value > 100 %}
  <p style = "color: blue; font-size: 100%">{{rendered_value}}</p>
  {% endif %}
;;
}

  measure: liquid_hasdim {
    type: sum
    sql: ${TABLE}.sale_price ;;
    html:
  {% if status._value == "cancelled" %}
  <p style = "color: blue; font-size: 100%">{{rendered_value}}</p>
  {% elsif status._value == "pending" %}
  <p style = "color: red; font-size: 100%">{{rendered_value}}</p>
  {% elsif status._value == "complete" %}
  <p style = "color: green; font-size: 100%">{{rendered_value}}</p>
  {% endif %}
;;
 }
  dimension: status_copy {
    type: string
    sql: ${TABLE}.status ;;
  }

#   dimension: year_num {
#     type: number
#     sql: ${created_year} ;;
#   }

#   measure: max_year {
#     type: max
#     sql: ${year_num} ;;
#   }

  dimension: dimension_fill {
    type: string
    case:
    {
      when: { sql: ${status}='complete';; label:"complete"}
      when: { sql: ${status}='pending';; label:"pending"}
      when: { sql: ${status}='cancelled';; label:"cancelled"}
      when: { sql: ${status}='other';; label:"other"}

    }
  }

  parameter: bad_param {
    type: string
    default_value: "Charles Schwab & Co., Inc.,"
  }
  dimension: bad_sql {
    type: string
    sql: 'Charles Schwab & Co., Inc.,' ;;
  }

}
