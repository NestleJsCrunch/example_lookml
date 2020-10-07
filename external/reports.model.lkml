connection: "thelook"

include: "/external/*.view.lkml"                # include all views in the views/ folder in this project


explore: sc_order_items {
  hidden: yes
  join: sc_orders {
    type: left_outer
    sql_on: ${sc_order_items.order_id} = ${sc_orders.id} ;;
    relationship: many_to_one
  }

  join: sc_users {
    type: left_outer
    sql_on: ${sc_orders.user_id} = ${sc_users.id} ;;
    relationship: many_to_one
  }
  fields: [sc_orders.dynamic_fields*]


}
