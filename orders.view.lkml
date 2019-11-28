view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    label: "comes through drill"
    sql: ${TABLE}.id ;;
  }

  filter: timeframe_picker_create {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_create {
    label: " report created at"
    type: date
    sql:
    CASE
    WHEN {% condition timeframe_picker_create %} 'day' {% endcondition %} THEN ${orders.created_date}
    WHEN {% condition timeframe_picker_create %} 'week' {% endcondition %} THEN ${orders.created_week}
    WHEN {% condition timeframe_picker_create %} 'month' {% endcondition %} THEN ${orders.created_month}
    WHEN {% condition timeframe_picker_create %} 'quarter' {% endcondition %} THEN ${orders.created_quarter}
    WHEN {% condition timeframe_picker_create %} 'year' {% endcondition %} THEN ${orders.created_year}
    else ${orders.created_quarter}
    END ;;
  }

dimension: date_month {
  type: date_month
  sql: ${TABLE}.created_at ;;
}
dimension: offset_month {
  type: date_month
  sql:  DATE_ADD(${TABLE}.created_at, INTERVAL 1 month) ;;
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
    convert_tz: no
  }

  dimension: monthday {
    type: string
    sql: concat(${created_month_num},"/",${created_day_of_month}) ;;
  }

 dimension: to_12_time {
   type: string
   sql:
  concat(
    LEFT(CAST(${TABLE}.created_at AS CHAR), 10),
  CASE WHEN
  CAST(SUBSTRING(CAST(${TABLE}.created_at AS CHAR),11,2) AS SIGNED) > 12
      THEN CONCAT(CAST((CAST(SUBSTRING(CAST(${TABLE}.created_at AS CHAR),11,9) AS SIGNED) - 12) AS CHAR), " PM")
      WHEN CAST(SUBSTRING(CAST(${TABLE}.created_at AS CHAR),11,2) AS SIGNED) = 12
      THEN CONCAT(SUBSTRING(CAST(${TABLE}.created_at AS CHAR),11,9), " PM")
      ELSE CONCAT(SUBSTRING(CAST(${TABLE}.created_at AS CHAR),11,9), " AM")
      END)
    ;;
 }
dimension: s1_to12 {
  type: string
  sql:
  LEFT(CAST(${TABLE}.created_at AS CHAR), 10);;
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

  measure: sum_test {
    type: sum
    sql: ${user_id} ;;
  }
  measure: number_test {
    type: number
    sql: SUM(${user_id}  ;;
  }
  measure: count {
    type: count
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {label:"my label" url: "/explore/derpinthesme/orders?fields=orders.created_date,orders.count&f[orders.created_date]={{ value }}&sorts=count+desc"
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

measure: count_null {
  type: sum
  sql: case when ${id} = 666238462394 then 1 else 0 end ;;
  html:
  {% if count_null._value == 0 %}
  Null
  {% else %}
  {{ count_null._value }}
  {% endif %}
  ;;
}

### end weird stuff ###

### CIGNA linking dimension/drill
  dimension: interesting_id {
    type: number
    sql: ${TABLE}.id ;;
    html:
      {% assign url_split_at_f = filter_link._link | split: '&amp;f' %}
      {% assign user_filters = '' %}
      {% assign continue_loop = true %}

      {% for url_part in url_split_at_f offset:1 %}
        {% if continue_loop %}
          {% if url_part contains '&amp;sorts' %}
            {% assign part_split_at_sorts = url_part | split: '&amp;sorts' %}
            {% assign last_filter = part_split_at_sorts | first %}
            {% assign user_filters = user_filters | append:'&f' %}
            {% assign user_filters = user_filters | append:last_filter %}
            {% assign continue_loop = false %}
          {% else %}
            {% assign user_filters = user_filters | append:'&amp;f' %}
            {% assign user_filters = user_filters | append:url_part %}
          {% endif %}
        {% endif %}
      {% endfor %}

      {% assign user_filters = user_filters | replace: 'f[orders.created_date]', 'Created Date' %}
      {% assign user_filters = user_filters | replace: 'f[orders.user_id]', '55' %}
      {% assign user_filters = user_filters | replace: 'f[orders.status]', 'Pending' %}

      <a href='/dashboards/12?{{ user_filters }}'>{{ value }}</a>;;
  }

  measure: filter_link {
    type: count_distinct
    hidden: yes
    drill_fields: []
    sql: ${TABLE}.id ;;
}
### begin stuff for sme-lookml ###




}
