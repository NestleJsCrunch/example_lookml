include: "/base_views/[!explore_views]*.view.lkml"


view: orders {
  extends: [base_orders]

  dimension: status {}

  # dimension: test {
  #   type:
  #   sql: 'foo' ;;
  # }
}

### adding thing

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


# deploy webhook

# curl -i -X POST -H "X-Looker-Deploy-Secret:cc05580a685c42bbb92ba9a7c10541db" https://dcl.dev.looker.com/webhooks/projects/derpinthesme/deploy/ref/96c484
