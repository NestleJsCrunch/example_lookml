view: pdt {
 derived_table: {
   sql: select * from demo_db_generator.orders ;;
  persist_for: "24 hours"
 }

dimension: id {}
}

explore: pdt {}
