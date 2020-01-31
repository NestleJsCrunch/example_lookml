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

}

explore: fresh_prince {}

### FR: Create a Parameter that can filter based on "Max" values in a table

# base table
view: fp0 {
  derived_table: {
    sql:
    select *
    from demo_db_generator.orders o
    ;;
  }
}

# grab max/min values from table
view: fp1 {
  derived_table: {
    sql:
  select Max(YEAR(created_at)) as MxYEAR,
         Min(YEAR(created_at)) as MnYEAR,
         Max(created_at) as MxDATE,
         Min(created_at) as MnDATE
  from demo_db_generator.orders o
  ;;
  }

parameter: thing1 {}

dimension: MxYEAR {}

dimension: MnYEAR {}

dimension: MxDATE {}

dimension: MnDATE {}


dimension: thing2 {
  type: string
  sql:
  {% if thing1._parameter_value == "'MxYEAR'" %}
  ${MxYEAR}
  {% elsif thing1._parameter_value == "'MnYEAR'" %}
  ${MnYEAR}
  {% elsif thing1._parameter_value == "'MxDATE'" %}
  ${MxDATE}
  {% else %}
  ${MnDATE}
  {% endif %} ;;
}

dimension: filtered {
  type: string
  sql:
  case when ${thing2} = ${fresh_prince.created_year}
  then ${fresh_prince.created_year}
  else null ;;
}

}

explore: fp {
  from: fresh_prince
  join: fp1 {
    sql_on: 1=1 ;;
  }
}
