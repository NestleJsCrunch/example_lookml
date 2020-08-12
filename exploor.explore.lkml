include: "dynamic_picture_selector.view.lkml"
include: "/*/*.view.lkml"

explore: base_ndt_explore {
  from: orders
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${base_ndt_explore.user_id} ;;
  }

}
