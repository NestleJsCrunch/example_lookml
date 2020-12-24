include: "/base_views/[!explore_views]*.view.lkml"


### adding comment 2

view: orders {
  extends: [base_orders]

  dimension: status {
  }
  measure: count {
    type: count
    link: {
      label: "drill"
      url: "https://dcl.dev.looker.com/dashboards-next/1036?Status={{ orders.status._value | url_encode }}"
    }
  }

  dimension: none {
    type: string
    sql: @{none} ;;
  }

  dimension: optional {
    type: string
    sql: @{optional} ;;
  }

  dimension: required {
    type: string
    sql: @{required} ;;
  }

  parameter: test {
    type: string
    suggest_dimension: status
  }

  measure: counta {
    type: count
    filters: [
      status: "{{ orders.test._parameter_value }}"
    ]
  }

  dimension_group: test1 {
    type: time
    timeframes: [date, week]
  }
  dimension_group: test2 {
    type: time
    timeframes: [week,date]
  }

  dimension: 2_date {
    group_label: "test"
  }

  dimension: 1_week {
    group_label: "test"

  }

  dimension: 4_date {
    label: "date"
    group_label: "test"

  }

  dimension: 3_week {
    label: "week"
    group_label: "test"

  }

  # dimension: test {
  #   type:
  #   sql: 'foo' ;;
  # }
}

### adding thing

view: users {
  extends: [base_users]
}
view: events {
  extends: [base_events]
}
view: inventory_items {
  extends: [base_inventory_items]
}
view: order_items {
  extends: [base_order_items]
}
view: products {
  extends: [base_products]
}
view: user_data {
  extends: [base_user_data]
}

view: bad_ndt {
    sql_table_name:
    (
  select '2016-01-11T07:00:00.000+00:00' as a
  union all
  select '2016-01-11T07:15:00.000+00:00' as a
  union all
  select '2016-01-11T07:30:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T07:45:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T11:00:00.000+00:00' as a
  union all
  select '2016-01-11T11:15:00.000+00:00' as a
  union all
  select '2016-01-11T11:30:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T11:45:00.000+00:00' as a
  )
  ;;

  dimension_group: test {
    type: time
    sql: ${TABLE}.a ;;
    convert_tz: no
  }

  dimension: workingat7am {
    type: string
    sql:
    case when
    cast(substring(${test_time_of_day},1,2) as signed) >=7 and cast(substring(${test_time_of_day},3,2) as signed) < 7
    then 'working at 7am'
    else 'undefined'
    end;;
  }
}
explore: bad_ndt {
  cancel_grouping_fields: [bad_ndt.workingat7am]
}

# adding breaking comment
#add comment


# deploy webhook

# curl -i -X POST -H "X-Looker-Deploy-Secret:cc05580a685c42bbb92ba9a7c10541db" https://dcl.dev.looker.com/webhooks/projects/derpinthesme/deploy/ref/96c484
