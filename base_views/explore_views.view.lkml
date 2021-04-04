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

view: test {
  derived_table: {
    sql:
    select 'a' as a, 5 as foo, 0 as bar
    union all
    select 'b' as a, 10 as foo, 8 as bar
;;
  }

  dimension: a {}
  measure: foo {
    type: sum
    sql: ${TABLE}.foo ;;
  }
  measure: bar {
    type: sum
    sql: ${TABLE}.bar ;;
  }
}

explore: test {}
