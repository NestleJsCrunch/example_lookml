include: "/base_views/[!exploreviews_base]*.view.lkml"

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
