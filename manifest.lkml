project_name: "derpinthesme"

constant: project_name {
  value: "staging"
}

### --- connection names --- ###

constant: connection_name {
  value: "thelook"
}

constant: alternate_connection {
  value: "philip_martinelli"
}

### --- table names --- ###

# bigquery

constant: table_phillip {
  value: "`potent-arcade-167816.performance_benchmarking.model_complexity`"
}

constant: table_phillip_bike {
  value: "`potent-arcade-167816.SF_BS.bikeshare_stations_copy`"
}

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

### ----- test constants ------ ###


constant: font {
  value: "<font size=3px>{{ value }}</font>"
}

constant: formatstuff {
  value: "
  {% if value > 1000000000 %}
            ${{value | divided_by: 1000000000 | round:2 }}B
          {% elsif value >= 1000000 and value < 1000000000 %}
            ${{value | divided_by: 1000000 | round:2 }}M
          {% elsif value >= 1000 and value < 1000000 %}
            ${{value | divided_by: 1000 | round:2 }}K
          {% elsif value >= 0 and value < 1000 %}
            ${{value | round:2 }}
          {% elsif value > -1000 and value < 0 %}
               ${{value | round:2 }}
          {% elsif value > -1000000 and value <= -1000 %}
               ${{value | divided_by: 1000 | round:2 }}k
          {% elsif value > -1000000000 and value <= -1000000 %}
               ${{value | divided_by: 1000000 | round:2 }}M
          {% elsif value <= -1000000000 %}
               ${{value | divided_by: 1000000000 | round:2 }}B
          {% else %}
            'fail'
          {% endif %}

  "
}


constant: none {
  value: "none"
  export: none
}

constant: optional {
  value: "optional"
  export: override_optional
}

constant: required {
  value: "required"
  export: "override_required"
}

constant: paramval1 {
  value: "this_is_val1"
}

constant: paramval2 {
  value: "this_is_val2"
}
### ----- Custom JS ----- ###
