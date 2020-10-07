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
  }

  dimension: output_dim {
    type: string
    label_from_parameter: grouping_selector
    sql:

    {% if time_grouping_selector._is_filtered %}
      case
      when {% parameter time_grouping_selector %} = 'order'
      then ${sc_orders.created_date}
      when {% parameter time_grouping_selector %} = 'user'
      then ${sc_users.created_date}
      end

    {% elsif grouping_selector._is_filtered %}
      case
      when {% parameter grouping_selector %} = 'status'
      then ${sc_orders.status}
      when {% parameter grouping_selector %} = 'state'
      then ${sc_users.state}
      when {% parameter grouping_selector %} = 'gender'
      then ${sc_users.gender}
      end
    {% else %}
        'Please select a grouping to populate this field'
    {% endif %}
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
  fields: [output_dim,output_measure,grouping_selector,metric_selector,time_grouping_selector]
}
}
