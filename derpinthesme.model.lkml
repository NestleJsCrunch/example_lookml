connection: "thelook"

# include all the views
include: "*.view"
include: "doesthishappen.dashboard.lookml"

# datagroup: derpinthesme_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }
#
#
# datagroup: multiple_triggers {
#   sql_trigger: select count(order.id), count(order_items.id), count(inventory_items.id)
#   from demo_db.orders order
#   join demo_db.order_items order_items on order.id = order_items.id
#   join demo_db.inventory_items inventory_items on order.id = inventory_items.id ;;
# }
#
# persist_with: derpinthesme_default_datagroup
#
# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
#
# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
# }
#
# explore: order_items {
#   join: inventory_items {
#     type: left_outer
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }
#
#   join: orders {
#     type: left_outer
#     sql_on: ${order_items.order_id} = ${orders.id} ;;
#     relationship: many_to_one
#   }
#
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
#
#   join: users {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
#
# explore: orders {
#   join: users {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
#
# explore: products {}
#
# explore: schema_migrations {}
#
# explore: user_data {
#   join: users {
#     type: left_outer
#     sql_on: ${user_data.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
#
# explore: users {}
#
# explore: users_nn {
#   join: users {}
# }
#
# explore: firstexplore {
#   from: firstorders
# }
#
explore: secondexplore {
  from: secondorders
}

# explore: testingfield1 {
#   from: orders
#   fields: [stuff*]
# }
# explore: testingfield2 {
#   from: orders
#   fields: [stuff2*]
#   }
#
# explore: multiple_where {
#   from:  orders
#   sql_always_where: ${created_date} > date("2012","05","15") AND ${status} LIKE "complete" ;;
# }

# access_grant: testing_bad_things {
#   user_attribute: Liquitidy
#   allowed_values: ["funk"]
# }
