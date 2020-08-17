connection: "thelook"

include: "/views/*.view.lkml"

# repro steps:
# Create a sql derived table in viewa and an explore for that view

view: sql_derived {
  derived_table: {
    sql: select * from foo_table ;;
  }
dimension: foo {
  type: string
  sql: ${TABLE}.foo ;;
}
}

explore: sql_derived {}

# Create a view that uses viewa's explore as the explore_source

view: derived_view {
  derived_table: {
    explore_source: sql_derived
  }
}
# Extend that ndt into another view and define a new SQL derived table

view: derived_problem {
  extends: [derived_view]
  derived_table: {
    sql:  select * from foo ;;
  }
}

explore: derived_problem {}
