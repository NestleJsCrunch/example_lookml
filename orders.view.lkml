view: orders {
  sql_table_name: demo_db.orders ;;

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
    convert_tz: no
  }

  dimension_group: created_2 {
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
    sql: CONVERT_TZ(${TABLE}.created_at, 'UTC', 'PST') ;;
  }

measure:doesthisworkoutofthebox{
  type: number
  sql: ${count} ;;
  html: {% assign seconds=value | modulo: 60 %}
  {{ value | divided_by: 60 | floor }}:{% if seconds < 10 %}0{% endif %}{{seconds }} ;;
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

  measure: thecount {
    type: count
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {url: "{{ id._value }}" label: "link out in liquid"
    }

  }

  measure: list_agg {
    type: list
    list_field: user_id
  }

  filter: FilteringYTD {
    type: string
  }

#   dimension: is_before_ytd {
#     type: yesno
#     sql: DAYOFYEAR(${date_date}) < DAYOFYEAR(CURRENT_DATE);;
#   }

#   dimension: date_is_ytd {
#     type: yesno
#     sql:
#     current_date() ;;
#
#   }
#
#   measure: count_filter {
#     type: date
#     sql:
#     case
#     when ${date_is_ytd} = yes
#     then max(${created_date})
#     else null
#     end
#   ;;
#
#     }

### weird stuff i dont think works ###
dimension: ashish {
  type: string
  sql:

{% if orders.status._value =='complete' %}
 'j'
{% elsif 'f'=='f' %}
  'f'
{% else %}
  'fuck'
{% endif %}
        ;;
}

dimension: stupid_season_codes {
  type: string
  sql:  ${id};;
#   required_access_grants: [testing_bad_things]
  hidden: yes
}

set: stuff {
  fields:[orders.list_agg,things.count]}

set: stuff2 {
  fields:[things.id,things.created_date]}



dimension: nownow {
  type: string
  sql: now() ;;
}

dimension: is_current_date {
  type: yesno
  sql: {{ nownow._value }} = ${created_date}  ;;
}

dimension: what_quarter {
  type: string
  sql:
  case when EXTRACT(MONTH FROM ${TABLE}.created)
 IN('01','02','03')
  THEN 'Q1'
  WHEN EXTRACT(MONTH FROM ${TABLE}.created) IN('04','05','06')
    THEN 'Q2'
      case when EXTRACT(MONTH FROM ${TABLE}.created) IN('07','08','09')
  THEN 'Q3'
  WHEN EXTRACT(MONTH ${TABLE}.created) IN('10','11','12')
    THEN 'Q4'
    END
    ;;
}

dimension: testing_wildcards {
  view_label: "(1) Adwords Ad"
group_label: "Extended Text Ads"
label: "Does Ad Copy Contain the Campaign Theme?"
description: "Returns yes if the first 3 letters of the campaign theme are in either the headline 1, headline 2 or description"
type: yesno
sql: CASE
WHEN ${status} LIKE %${nownow}% OR ${status} LIKE %${nownow}% OR ${status} LIKE %${nownow}% THEN 1
ELSE 0
END ;;
}

### end weird stuff ###


### begin stuff for sme-lookml ###




}
