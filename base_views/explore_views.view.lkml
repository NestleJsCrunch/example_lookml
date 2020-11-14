include: "/base_views/[!explore_views]*.view.lkml"


view: orders {
  extends: [base_orders]

  dimension: status {}

  # dimension: test {
  #   type:
  #   sql: 'foo' ;;
  # }
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
