connection: "thelook"

include: "*.view.lkml"                       # include all views in this project
# include: "//derpinthesme/*.view"
# # include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # # Select the views that should be a part of this model,
# # # and define the joins that connect them together.
# #
explore: orders {}
#   join: liquid_waterfalls {
#     relationship: many_to_one
#     sql_on: ${orders.created_2_date} = ${liquid_waterfalls.created_date} ;;
#   }

#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: orderz {
  from:  orders
}

explore: orderzs {
  from:  orders
}

explore: orders_s {
  from:  orders
}

explore: order_s {
  from:  orders
}

explore: orders_ss {
  from:  orders
}

explore: order_sS {
  from:  orders
}
