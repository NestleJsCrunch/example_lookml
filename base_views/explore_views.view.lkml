include: "/base_views/[!explore_views]*.view.lkml"

### ### ### ### ###
### test  views ###
### ### ### ### ###

view: orders {
  extends: [base_orders]
}
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


### adding comment does another user on this branch see it ###

view: testing_liquidity {
  sql_table_name:
  {% if testing_liquidity.a._in_query %}
  success
  {% else %}
  failure
  {% endif %} ;;

  dimension: a {}
}

explore: testing_liquidit {
  from: orders
  join: testing_liquidity {
    sql_on: ${testing_liquidity.a} = ${testing_liquidit.status} ;;
  }
}

view: 2b {
  derived_table: {
    explore_source: testing_liquidit {
      column: a {
        field: .a
      }
    }
  }

  dimension: a {}
}

explore: 2b {}
