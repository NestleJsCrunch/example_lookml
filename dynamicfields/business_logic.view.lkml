view: business_logic {

### Add fields to the set
set: dynamic_fields {
  fields: [output_dim,output_measure,grouping_selector,metric_selector,time_grouping_selector, timeframe_selector, year_selector, grouping_selector_2,output_dim2]
}


# let's start with some simple metrics
# these are going to be what the end user gets to select from
#

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


### s1

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

TRIM(
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
      else ''
      end

      {% else %}
      'No field selected'
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

    {% else %}
    'No field selected'

    {% endif %}
        AS CHAR)
)
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
    'No field selected'
    {% endif %}
    ;;

  }

  ### s2

  parameter: grouping_selector_2 {
    type: unquoted
    allowed_value: {
      label: "Order Status"
      value: "sc_orders.status"
    }
    allowed_value: {
      label: "User State"
      value: "sc_users.state"
    }
    allowed_value: {
      label: "User Gender"
      value: "sc_users.gender"
    }
  }

  dimension: output_dim2 {
    type: string
    sql: {% parameter grouping_selector_2 %} ;;
  }

  parameter: aggregation_selector {
    type: unquoted
    allowed_value: {
      label: "Max"
      value: "MAX"
    }
    allowed_value: {
      label: "Min"
      value: "MIN"
    }
    allowed_value: {
      label: "Sum"
      value: "SUM"
    }
    allowed_value: {
      label: "Count"
      value: "COUNT"
    }
    allowed_value: {
      label: "Sum Distinct"
      value: "Count Distinct"
    }
  }

  parameter: metric_selector2 {
    type: unquoted
    allowed_value: {
      label:  "Sales"
      value: "sales"
    }
    allowed_value: {
      label: "Orders"
      value: "orders"
    }
    allowed_value: {
      label: "Users"
      value: "users"
    }
    allowed_value: {
      label: "Order Date"
      value:""
    }
  }

  measure: output_measure2 {
    type: number
    sql:
    {% parameter aggregation_selector %}({% parameter metric_selector2 %})
    ;;

  }


}
