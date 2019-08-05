view: liquid_waterfalls {
  sql_table_name: demo_db.orders ;;
  view_label: "Liquid_testing"

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
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {url: "/explore/derpinthesme/orders?fields=orders.created_date,orders.count&f[orders.created_date]={{ value }}&sorts=count+desc"
    }
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


    ### to string and to number do not work
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
    label: "Can I use liquid in measure type param"
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

  parameter: liquidity_injection {
    type: unquoted
    label: "nothing to see here"

  }

  measure: liquidity_measure{
    type: number
    sql: {% parameter liquidity %}${going_to_be_cool};;

  }

  measure: injection_1 {
    type: number
    sql: {% parameter liquidity_injection %} ;;
  }

}
#
# explore: liquid_waterfalls {}
