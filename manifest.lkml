project_name: "tsr_example_base"

constant: project_name {
  value: "staging"
}

### --- connection names --- ###

constant: connection_name {
  value: "thelook"
}

### --- table names --- ###

# mysql
constant: table_orders {
  value: "demo_db.orders"
}

constant: table_users {
  value: "demo_db.users"
}

constant: table_oitems {
  value: "demo_db.order_items"
}

constant: table_iitems {
  value: "demo_db.inventory_items"
}

constant: table_products {
  value: "demo_db.products"
}

constant: table_events {
  value: "demo_db.events"
}

constant: table_udata {
  value: "demo_db.user_data"
}

constant: table_flights {
  value: "demo_db.flights"
}

#### -------- sql snippets -------- ###

constant: bq_updt_begin{
  value: "select GENERATE_UUID() as true_pk, *"
}

constant: mysql_updt_begin {
  value: "select ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY 1) as true_pk, *"
}
