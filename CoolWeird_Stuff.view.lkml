include: "base_orders.view.lkml"
view: coolweird_stuff {
extends: [orders]

### Cool Liquid Stuff:

# links and fonts
  dimension: user_id {
    type: number
#     label: "this should be the second explore"
    html: <font color="#42a338 ">{{ rendered_value }}</font> ;;
    link: {
      label: "liquid linking out"
      url: "/dashboards/402?
      date%20liquid={{ _filters['coolweird_stuff.created_date'] }}
      &status%20liquid={{ value }}
      &id%20liquid={{ coolweird_stuff.id | url_encode }}"
    }
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # dynamic measure

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
    sql: {% parameter liquidity %}${user_id};;

  }

  # dynamic date format(s)
  parameter: date_type {
    type: string
    allowed_value: { value: "EU" }
    allowed_value: { value: "USA" }
  }

  dimension: formatted_date {
    type: string
    sql:
    case
    when {{ coolweird_stuff.date_type._parameter_value }} = "EU"
    then date_format(${created_date}, "%m/%d/%y")
    when {{ coolweird_stuff.date_type._parameter_value }} = "USA"
    then date_format(${created_date}, "%d/%m/%y")
    else
    'shit didnt work yo'
    end ;;
    group_label: "liquid"
    }

  dimension: formatted_checker {
    type: string
    sql:
    {{ coolweird_stuff.date_type._parameter_value }}
    html:
        {% if coolweird_stuff.date_type._parameter_value == "EU" %}
      {{ rendered_value | date: "%m/%d/%y" }}
    {% elsif coolweird_stuff.date_type._parameter_value == "USA" %}
      {{ rendered_value | date: "%d/%m/%y" }}
    {% endif %} ;;
    group_label: "liquid"
 }

  # dynamic timeframe
  filter: timeframe_picker_create {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_create {
    label: " report created at"
    type: date
    sql:
    CASE
    WHEN {% condition timeframe_picker_create %} 'day' {% endcondition %} THEN ${created_date}
    WHEN {% condition timeframe_picker_create %} 'week' {% endcondition %} THEN ${created_week}
    WHEN {% condition timeframe_picker_create %} 'month' {% endcondition %} THEN ${created_month}
    WHEN {% condition timeframe_picker_create %} 'quarter' {% endcondition %} THEN ${created_quarter}
    WHEN {% condition timeframe_picker_create %} 'year' {% endcondition %} THEN ${created_year}
    else ${created_quarter}
    END ;;
    group_label: "liquid"
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
    {% if coolweird_stuff.week_or_month._parameter_value == 'week' %}
"week selected"
    {% elsif coolweird_stuff.week_or_month._parameter_value == 'month' %}
"month selected"
    # ${created_month}
    {% elsif coolweird_stuff.week_or_month._parameter_value == 'quarter' %}
"quarter selected"
    # ${created_quarter}
    {% else %}
"hit else condition"
    # ${created_quarter}
    {% endif %}
    ;;
    group_label: "liquid"

  }

  # wtf does this do
  measure:doesthisworkoutofthebox{
    type: number
    sql: ${count} ;;
    html: {% assign seconds=value | modulo: 60 %}
      {{ value | divided_by: 60 | floor }}:{% if seconds < 10 %}0{% endif %}{{seconds }} ;;
    group_label: "liquid"
  }

  # how to escape liquid
  dimension: howto_escape_liquid {
    type: string
    sql: case when 1=1
          then "\{\{test\}\}"
          end;;
    group_label: "liquid"
  }


  # count with liquid url
  measure: count {
    type: count
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {label:"my label" url: "/explore/derpinthesme/orders?fields=orders.created_date,orders.count&f[orders.created_date]={{ value }}&sorts=count+desc"
    }
    group_label: "liquid"
  }

  # CIGNA linking dimension/drill
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
    group_label: "liquid"
  }

  # not sure what this does
  measure: thecount {
    type: count
    drill_fields: [id, created_date,users.first_name, users.last_name, users.id, orders.count]
    link: {url: "{{ id._value }}" label: "link out in liquid"
    }
    group_label: "liquid"
    }


  # yesno is current date
  dimension: now_time {
    type: string
    sql: now() ;;
    group_label: "liquid"

  }

  dimension: is_current_date {
    type: yesno
    sql: {{ now_time._value }} = ${created_date}  ;;
    group_label: "liquid"

  }


  ### SQL Stuff

  # Because Why ETL
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
    group_label: "weird sql"

  }


  # Month Day instead of monthdayyear
  dimension: monthday {
    type: string
    sql: concat(${created_month_num},"/",${created_day_of_month}) ;;
    group_label: "weird sql"

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
    group_label: "weird sql"

  }

  dimension: testing_wildcards {
    view_label: "(1) Adwords Ad"
    label: "Does Ad Copy Contain the Campaign Theme?"
    description: "Returns yes if the first 3 letters of the campaign theme are in either the headline 1, headline 2 or description"
    type: yesno
    sql: CASE
      WHEN ${status} LIKE %${now_time}% OR ${status} LIKE %${now_time}% OR ${status} LIKE %${now_time}% THEN 1
      ELSE 0
      END ;;
    group_label: "weird sql"

  }

  measure: testing {
    type: sum
    sql: case when 1=1
          then 1
          else 0
          end ;;
    filters: {
      field: created_date
      value: "before today"
    }
    group_label: "weird sql"
  }


  ### expression

  measure: ccount {
    type: number
    sql: count(*) ;;
    group_label: "expression"
  }

  measure: sum_counts {
    type: sum
    # expression: sum(${ccount}) ;;
    group_label: "expression"
  }

  dimension: contains_jeff {
    type: string
    expression: replace(${status},"comp", "Jeff") ;;
    group_label: "expression"
  }

  dimension: does_it_contain_jeff {
    type: yesno
    expression: contains(${contains_jeff},"Jeff") ;;
    group_label: "expression"
  }


  # to string and to number do not work
  dimension: stringify {
    type: string
    # expression: to_string(${coolweird_stuff.count}) ;;
    group_label: "expression"

  }


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
    group_label: "expression"

  }

}
