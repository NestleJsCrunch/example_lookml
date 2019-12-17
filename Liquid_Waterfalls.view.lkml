explore: liquid_waterfalls {}

view: liquid_waterfalls {
  sql_table_name: demo_db.orders ;;
  view_label: "Liquid_testing"

dimension: case_when_should_error {
  type: string
  case: {
    when: {
      label: "foo is foo"
      sql: ${TABLE}.id = "foo" ;;
    }
  }
  case: {
    when: {
      label: "foo is not foo"
      sql: ${TABLE}.id != "foo" ;;
      }
  }
}
  parameter: week_or_month {
    type: unquoted
    allowed_value: { label: "Week" value: "week"}
    allowed_value: { label: "Month" value: "month"}
    allowed_value: { label: "Quarter" value: "quarter"}
    default_value: "quarter"
  }

  dimension: period_select {
    type: string
    label_from_parameter: week_or_month
    sql:
    {% if liquid_waterfalls.week_or_month._parameter_value == 'week' %}
"week selected"
    {% elsif liquid_waterfalls.week_or_month._parameter_value == 'month' %}
"month selected"
    # ${created_month}
    {% elsif liquid_waterfalls.week_or_month._parameter_value == 'quarter' %}
"quarter selected"
    # ${created_quarter}
    {% else %}
"hit else condition"
    # ${created_quarter}
    {% endif %}
    ;;
  }

  dimension: escape_liquid_1 {
    type: string
    sql: case when 1=1
    then "\{\{test\}\}"
    end;;
  }

  dimension: escape_liquid_2 {
    type: string
    sql: case when 1=1
          then "' {{ test }} '"
          end;;
  }


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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: intervals {
    type: duration
    timeframes: [week]
    sql_start: ${created_date} ;;
    sql_end: ${created_date} ;;
  }

  measure:testing_for_anish {
    type: sum
    sql:
    case when
    {% if liquid_waterfalls.created_date._value > STR_TO_DATE("2018-01-01", '%Y-%m-%d') %}
    then 1
    else 0
    end ;;
  }

  measure: testing {
    type: sum
    sql: case when 1=1
    then 1
    else 0
    end ;;
    filters: {
      field: created_date
      value: "before '2019-01-01'"
    }
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "does it link"
      url: "https://www.{{ value }}.com"
      }

  }


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {url: "/explore/derpinthesme/orders?fields=orders.created_date,orders.count&f[orders.created_date]={{ value }}&sorts=count+desc"
    }
    }
  dimension: dumby_date {
    type: string
    sql: "2019-01","2019-03","2019-05" ;;
  }

  measure: sum_counts {
    type: sum
    expression: sum(${count}) ;;
  }

    ### SECRET STUFF TESTING

    dimension: contains_jeff {
      type: string
      expression: replace(${status},"comp", "Jeff") ;;
    }

    dimension: does_it_contain_jeff {
      type: yesno
      expression: contains(${contains_jeff},"Jeff") ;;
    }


    ## to string and to number do not work
    dimension: stringify {
      type: string
      expression: to_string(${count}) ;;
    }

    ### LIQUID SHENNANIGAN


  dimension: going_to_be_cool {
    type: number
    sql: case
    when ${status} = "cancelled"
    then 5
    when ${does_it_contain_jeff} = "complete"
    then 2
    when ${status} = "pending"
    then 1
    end
;;
  }

  parameter: liquidity {
    type: unquoted
    label: "measure type"
    allowed_value: {
      value: "sum"
    }
    allowed_value: {
      value: "count"
    }
    allowed_value: {
      value: "avg"
    }

  }

  # parameter: liquidity_injection {
  #   type: unquoted
  #   label: "nothing to see here"

  # }

  parameter: the_field {
    type: unquoted
    allowed_value: {value: "${going_to_be_cool}"}
  }


#   measure: liquidity_measure{
#     type: number
#     sql: {% parameter liquidity %}{% parameter the_field %}
#
#     # ${going_to_be_cool};;
#
#   }
#
#   measure: injection_1 {
#     type: number
#     sql: {% parameter liquidity_injection %} ;;
#   }

}
