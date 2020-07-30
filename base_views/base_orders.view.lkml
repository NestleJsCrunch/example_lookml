include: "/*/*.view.lkml"


view: orders {
  sql_table_name: demo_db_generator.orders ;;

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
      date,
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

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }


  measure: count {
    type: count
    drill_fields: [id,created_date,user_id]
    }

  dimension: selfserve_dashboardurl_creative{
    view_label: " Transaction Event"
    type: string
    sql: ${TABLE}.id;;

    link: {label: "drill out" url: "https://advertiser.vungle.com/creatives?search={{ value }}" }
  }

  dimension_group: previous_created {
    type: time
    sql: date_add(${created_date_date},interval -1 day) ;;
  }

  dimension: tend {
    type: yesno
    sql: case
    when ${created_date_date} < extract_date(now()) then 'yes'
    else 'no'
    ;;
  }
  dimension: tstart {
    type: yesno
    sql: case
          when ${created_date_date} > date_sub(extract_date(now()),interval 90) then 'yes'
          else 'no'
          ;;
  }


### scratchpad

parameter: test {
  type: unquoted
  allowed_value: {
    label: "Select Sum"
    value: "SUM"
  }
  allowed_value: {
    label: "Select Count"
    value: "COUNT"
  }
}

filter: test2 {
  type: string
}

measure: dynamic {
  type: number
  sql: {$ parameter test %}(${id}) ;;
}

dimension: dynamic2 {
  type: string
  sql: {% condition test2 %} ${status} {% endcondition %} ;;
}


dimension: link {
  type: string
  sql: ${TABLE}.id ;;
  html: <a href="{{ value }}">{{ orders.status._value }}</a> ;;
  link: {
    label: "Listen to Call"
    url: "{{ value }}"
    icon_url: "https://twilio-cms-prod.s3.amazonaws.com/original_images/twilio-mark-red.png"
# icon_url: "https://www.twilio.com/marketing/bundles/company-brand/img/logos/red/twilio-logo-red.png"
  }

}



measure: drilling_from {
  type: count
  link: {
    label: "link out"
    url: "https://dcl.dev.looker.com/explore/derpinthesme/orders?fields=orders.created_date,orders.id&f[orders.status]=complete&limit=500&query_timezone=America%2FNew_York&vis=%7B%7D&filter_config=%7B%22orders.status%22%3A%5B%7B%22type%22%3A%22is%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22{{ status._value }}%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%7D%5D%7D&origin=share-expanded"
  }
}


measure: percentile_test {
  type: percentile
  sql: ${user_id} ;;
  percentile: 25
}



}
