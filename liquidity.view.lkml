### for sme-lookml ###

view: liquidity {
  # dynamic derived table
  derived_table: {
  sql:
  select *
  from demo_db.orders
  where
    {% condition status_param %} status {% endcondition %}
 and
    {% condition date_fil %} created_at {% endcondition %};;

}


# dimensions

dimension_group: created {
  type: time
  timeframes: [date]
  sql: ${TABLE}.created_at ;;
  convert_tz: no
}

dimension: status {
  type: string
  sql: ${TABLE}.status ;;
}


  # param/filter for dynamic dt
  filter: date_fil {
    type: date
  }

  parameter: status_param {
    type: string
    allowed_value: { value: "pending" }
    allowed_value: { value: "cancelled" }
    allowed_value: { value: "complete" }
  }

  # dynamic dimension(s)
  parameter: date_type {
    type: string
    allowed_value: { value: "EU" }
    allowed_value: { value: "USA" }
  }

  dimension: formatted_date {
    type: string
    sql:
    case
    when {{ liquidity.date_type._parameter_value }} = "EU"
    then date_format(${created_date}, "%m/%d/%y")
    when {{ liquidity.date_type._parameter_value }} = "USA"
    then date_format(${created_date}, "%d/%m/%y")
    else
    'shit didnt work yo'
    end ;;
    }

  dimension: formatted_checker {
    type: string
    sql:
    {{ liquidity.date_type._parameter_value }}
    html:
        {% if liquidity.date_type._parameter_value == "EU" %}
      {{ rendered_value | date: "%m/%d/%y" }}
    {% elsif liquidity.date_type._parameter_value == "USA" %}
      {{ rendered_value | date: "%d/%m/%y" }}
    {% endif %} ;;
  }

}

explore: liquidity {}
