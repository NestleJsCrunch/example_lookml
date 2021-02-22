
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
    # order_by_field: sort
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    # html:
    # <a href="https://www.thesitewizard.com/" target="_blank"> </a>
    # ;;

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

dimension: foo {
  type: string
  sql:
  case
  when ${created_date} = DATE_ADD(now(), -1)
  then CAST(${created_date} as CHAR)
  else CONCAT(CAST(DATE_ADD(NOW(), -30) as CHAR), ' to ', CAST(DATE_ADD(NOW(), -2) as CHAR))
  end
  ;;
}

measure: ag {
  type: average
  sql: ${id} ;;
}

dimension: sort {
  type: number
  sql:
  case when

  ${status} = 'complete' then 1
  when ${status} = 'pending' then 2
  when ${status} = 'cancelled' then 3
  end;;
}

parameter: param {
  type: string
  allowed_value: {
    label: "v1"
    value: "@{paramval1}"
  }
  allowed_value: {
    label: "v2"
    value: "@{paramval2}"
  }
}

dimension: paramfam {
  type: string
  sql:  {% parameter param %} ;;
}

  parameter: product_code_test {
    type: string
    allowed_value: {
      label: "option 1"
      value: "option 1"
    }
    allowed_value: {
      label: "option 2"
      value: "option 2"
    }
    allowed_value: {
      label: "all"
      value: "option 1, option2"
    }
  }

  dimension: thing {
    type: string
    sql:
    {% if orders.product_code_test._parameter_value == "'option 1'" %}
    'success'
    {% else %}
    'bad'
    {% endif %}

    ;;
  }

}
