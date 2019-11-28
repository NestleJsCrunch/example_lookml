include: "testing_blank_extends.view.lkml"

view: view_me {
  extends: [testing_blank_extends]
  sql_table_name: demo_db.events ;;


 }

explore: view_me {}
