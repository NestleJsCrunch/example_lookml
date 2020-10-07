
project_name: "derpinthesme"

constant: project_name {
  value: "staging"
}

##### Constants for table names / connection name

constant: connection_name {
  value: "thelook"
}

constant: table_orders {
  value: "demo_db.orders"
}

constant: table_users {
  value: "demo_db.users"
}

constant: table_items {
  value: "demo_db.order_items"
}

constant: table_products {
  value: "demo_db.products"
}

constant: table_events {
  value: "demo_db.events"
}

constant: uuid_begin{
  value: "select GENERATE_UUID() as true_pk, *"
}
