include: "/*/*.view.lkml"


view: orders {
  sql_table_name:@{connection} ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;

  }

dimension: date_month {
  type: date_month
  sql: ${TABLE}.created_at ;;
}

dimension: offset_month {
  type: date_month
  sql:  DATE_ADD(${TABLE}.created_at, INTERVAL 1 month) ;;
}

dimension: createdstring {
  type: string
  sql: ${TABLE}.created_at ;;
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
      month_num
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_date {
    type: time
    timeframes: [
      raw,
      month,
      quarter,
      year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.created_at ;;
    datatype: date
  }

  dimension: status {
    type: string
    case: {
    when: { sql:${TABLE}.status = "complete" ;; label:"complete" }
    when: { sql:${TABLE}.status = "pending" ;; label:"pending" }
    when: { sql:${TABLE}.status = "cancelled" ;; label:"cancelled" }
    when: { sql:${TABLE}.status = "other" ;; label:"other" }
  }
  link: {url: "/explore/derpinthesme/orders?fields=orders.status,orders.created_year&f[orders.status]={{ value }}"
        label:"my link"}
  }

  dimension: long_status {
    type: string
    case: {
      when: { sql:${TABLE}.status = "complete" ;; label:"complete lorum ipsum florum blorum selenum oasfdghasbfkj" }
      when: { sql:${TABLE}.status = "pending" ;; label:"pending foo florum ipsum certum asdgqsgasasddfaswfawefsafeasefasefasefasdfas fasefesfsfds" }
      when: { sql:${TABLE}.status = "cancelled" ;; label:"cancelled carum lorum ipsum doum" }
      when: { sql:${TABLE}.status = "other" ;; label:"other" }
    }
    link: {url: "/explore/derpinthesme/orders?fields=orders.status,orders.created_year&f[orders.status]={{ value }}"
      label:"my link"}
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }


  measure: count {
    type: count
    drill_fields: [id,created_date,user_id]
    }

    dimension: test_link {
      type: string
      sql: ${TABLE}.id ;;
      html: Link to call ;;
      link: {label:"link out"
        url:"https://www.google.com?q={{ value }}"}
    }


    dimension: test {
      type: string
      sql: @{liquid} ;;
    }

parameter: d1 {
  type: date
}

parameter: d2 {
  type: date_time
}

dimension: d1a {
  type: string
  sql: {% parameter d1 %} ;;
}

dimension: d2a {
  type: string
  sql: {% parameter d2 %} ;;
}



# measure: test_drill {
#   type: count
#   drill_fields: [user_id]
# }
#   dimension: selfserve_dashboardurl_creative{
#     view_label: " Transaction Event"
#     type: string
#     sql: ${TABLE}.id;;

#     link: {label: "drill out" url: "https://advertiser.vungle.com/creatives?search={{ value }}" }
#   }

#   dimension_group: previous_created {
#     type: time
#     sql: date_add(${created_date_date},interval -1 day) ;;
#   }

#   dimension: tend {
#     type: yesno
#     sql: case
#     when ${created_date_date} < extract_date(now()) then 'yes'
#     else 'no'
#     ;;
#   }
#   dimension: tstart {
#     type: yesno
#     sql: case
#           when ${created_date_date} > date_sub(extract_date(now()),interval 90) then 'yes'
#           else 'no'
#           ;;
#   }


### scratchpad

# parameter: test {
#   type: unquoted
#   allowed_value: {
#     label: "Select Sum"
#     value: "SUM"
#   }
#   allowed_value: {
#     label: "Select Count"
#     value: "COUNT"
#   }
# }

# filter: test2 {
#   type: string
# }

# measure: dynamic {
#   type: number
#   sql: {$ parameter test %}(${id}) ;;
# }

# dimension: dynamic2 {
#   type: string
#   sql: {% condition test2 %} ${status} {% endcondition %} ;;
# }


# dimension: link {
#   type: string
#   sql: ${TABLE}.id ;;
#   html: <a href="{{ value }}">{{ orders.status._value }}</a> ;;
#   link: {
#     label: "Listen to Call"
#     url: "{{ value }}"
#     icon_url: "https://twilio-cms-prod.s3.amazonaws.com/original_images/twilio-mark-red.png"
# # icon_url: "https://www.twilio.com/marketing/bundles/company-brand/img/logos/red/twilio-logo-red.png"
#   }

# }



# measure: drilling_from {
#   type: count
#   link: {
#     label: "link out"
#     url: "https://dcl.dev.looker.com/explore/derpinthesme/orders?fields=orders.created_date,orders.id&f[orders.status]=complete&limit=500&query_timezone=America%2FNew_York&vis=%7B%7D&filter_config=%7B%22orders.status%22%3A%5B%7B%22type%22%3A%22is%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22{{ status._value }}%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%7D%5D%7D&origin=share-expanded"
#   }
# }


# measure: percentile_test {
#   type: percentile
#   sql: ${user_id} ;;
#   percentile: 25
# }



}


# view: orders2 {
#   derived_table: {sql: select ${orders.count} as "one" from ${orders.SQL_TABLE_NAME}} ;;
# }

# dimension: test {
#   type: string
#   sql:${TABLE}."one" ;;
# }

# ### liquid label

# dimension: test_test {
#   # label: "Derpity Derp Derp"
#   type: string
#   sql: 1=1 ;;
# }

# dimension: test_test_test {
#   type: string
#   sql: 1=1 ;;
#   label: "{{_view._name._rendered_value}}"
# }
#   dimension: test_test_test2 {
#     type: string
#     sql: 1=1 ;;
#     label: "{{_view._name}}"
#   }

# parameter: view_name {
#   type: unquoted
# }

# parameter: rank_field {
#   type: unquoted
# }

# dimension: coalesce {
#   type: string
#   sql: COALESCE({% parameter view_name %}.{% parameter rank_field %},null) ;;
# }
# }
# explore: orders2 {
#   label: "This is my explore name"
#   join: orders_second {
#     from: orders2
#     sql_on: 1=1 ;;
#   }
# }
