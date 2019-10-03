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

### adding comment will actually revert
