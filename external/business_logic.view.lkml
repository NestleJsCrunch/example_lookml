view: business_logic {

# let's start with some simple metrics

measure: sum_sales {
  type: sum
  sql: ${sc_order_items.sale_price} ;;
}

measure: dcount_orders {
  type: count_distinct
  sql: ${sc_orders.id} ;;
}

measure: dcount_users {
  type: count_distinct
  sql: ${sc_users.id} ;;
}


# bringing some stuff in from the

# now let's do some cool stuff

parameter: metric_selector{
  type: string
  allowed_value: {
    label: "Total Sales"
    value: "sales"
  }
  allowed_value: {
    label: "Number of Orders"
    value: "orders"
  }
  allowed_value: {
    label: "Number of Users"
    value: "users"
  }
}

parameter: grouping_selector {
  type: string
  allowed_value: {
    label: "Status of Order"
    value: "status"
  }
  allowed_value: {
    label:  "Destination State"
    value: "state"
  }
  allowed_value: {
    label: "Users Gender"
    value: "gender"
  }
  allowed_value: {
    label: "No Metric Grouping"
    value: "no"
  }
  }

  parameter: time_grouping_selector {
    type: string
    allowed_value: {
      label: "Order Creation"
      value: "order"
    }
    allowed_value: {
      label: "User Creation"
      value: "user"
    }
    allowed_value: {
      label: "No Time Grouping"
      value: "no"
    }
  }

  parameter: timeframe_selector {
    type: string
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
    allowed_value: {
      label: "No Timeframe"
      value: "no"
    }

  }

  filter: year_selector {
    label: "Year to Analyze"
    type: date
    sql:

    {% if time_grouping_selector._is_filtered and time_grouping_selector._value== 'order' %}
    {% condition year_selector %} ${sc_orders.created_date} {% endcondition %}
    {% elsif time_grouping_selector._is_filtered and time_grouping_selector._value== 'user' %}
    {% condition year_selector %} ${sc_users.created_date} {% endcondition %}
    {% else %}
    1=1
    {% endif %}

    ;;
  }

  dimension: output_dim {
    type: string
    label_from_parameter: grouping_selector
    sql:

CONCAT(
        -- convert all to string
      CAST(
    {% if time_grouping_selector._is_filtered  %}
      case
      when {% parameter time_grouping_selector %} = 'order'
      and {% parameter timeframe_selector %} = 'day'
      then ${sc_orders.created_date}
      when {% parameter time_grouping_selector %} = 'order'
      and {% parameter timeframe_selector %} = 'week'
      then ${sc_orders.created_week}
      when {% parameter time_grouping_selector %} = 'order'
      and {% parameter timeframe_selector %} = 'month'
      then ${sc_orders.created_month}
      when {% parameter time_grouping_selector %} = 'order'
      and {% parameter timeframe_selector %} = 'year'
      then ${sc_orders.created_year}
      when {% parameter time_grouping_selector %} = 'user'
      and {% parameter timeframe_selector %} = 'day'
      then ${sc_users.created_date}
      when {% parameter time_grouping_selector %} = 'user'
      and {% parameter timeframe_selector %} = 'week'
      then ${sc_users.created_week}
      when {% parameter time_grouping_selector %} = 'user'
      and {% parameter timeframe_selector %} = 'month'
      then ${sc_users.created_month}
      when {% parameter time_grouping_selector %} = 'user'
      and {% parameter timeframe_selector %} = 'year'
      then ${sc_users.created_year}
      else
      ''
      end

      {% endif %}

        AS CHAR),

        -- convert all to string
        CAST(
    {% if grouping_selector._is_filtered %}
      case
      when {% parameter grouping_selector %} = 'status'
      then CONCAT(' ', ${sc_orders.status})
      when {% parameter grouping_selector %} = 'state'
      then CONCAT(' ', ${sc_users.state})
      when {% parameter grouping_selector %} = 'gender'
      then CONCAT(' ', ${sc_users.gender})
      else ''
      end

    {% endif %}
        AS CHAR)
)
    ;;
  }

  measure: output_measure {
    type: number
    label_from_parameter: metric_selector
    sql:
    {% if metric_selector._is_filtered %}
    case
    when {% parameter metric_selector %} = 'sales'
    then ${sum_sales}
    when {% parameter metric_selector %} = 'orders'
    then ${dcount_orders}
    when {% parameter metric_selector %} = 'users'
    then ${dcount_users}
    end
    {% else %}
    'Please select a metric to populate this field'
    {% endif %}
    ;;

  }

set: dynamic_fields {
  fields: [output_dim,output_measure,grouping_selector,metric_selector,time_grouping_selector, timeframe_selector, year_selector]
}
}
