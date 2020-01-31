view: users_nn {
#   sql_table_name: demo_db.usersNN ;;
sql_table_name:
{% if dynamizm._parameter_value == 'val1' %}
demo_db.usersNN
{% elsif dynamizm._parameter_value == 'val2' %}
demo_db.orders
{% else %}
demo_db.users
{% endif %}
;;

### dynamic sqltablename parameter

parameter: dynamizm {
  type: unquoted
  allowed_value: {label:"usersNN" value: "val1"}
  allowed_value: {label:"orders" value: "val2"}
  allowed_value: {label:"users" value: "val3"}
}

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }
}
