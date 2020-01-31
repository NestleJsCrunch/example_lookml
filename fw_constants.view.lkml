include: "/*/*.view.lkml"
view: fw_constants {
  extends: [orders]

  dimension: some_field {
    type: number
    sql: ${id} ;;
  }

# the goal is to do as much as possible with constants

# use a constant in a filtered measure
  measure: constant_filt {
    type: count
    filters: {field: status value: "@{filter}"}
  }

# use a constant in a liquid link (constant = /dashboard/number_filter={{value}} link = constant)

measure: constant_linked {
  type: count_distinct
  sql: ${id} ;;
  link: {
    label: "link out"
    url: "@{dashboard_link}"
  }
}

# use a constant to create a bunch of subqueries

measure: constant_sub {
  type: sum
  sql: @{subquery} ;;
}

measure: constant_sub2 {
  type: count_distinct
  sql: @{subquery} ;;
}

# use a constant to define a derived table

# use a constant to write an incomplete query

measure: mysql_ddiff {
  type: number
  sql: @{mysql_ddiff}${created_date},NOW()) ;;
}

  measure: bq_ddiff {
    type: number
    sql: @{bq_ddiff}${created_date},NOW()) ;;
  }

# filter in a list with constants
  measure: constant_list1 {
    type: count
    filters: {field: id value: "@{list}"
      }
  }

  measure: constant_list2 {
    type: sum
    sql: ${some_field} ;;
    filters: {field: id value: "@{list}"
    }
  }
# use a constant to define a dimension

# use a constant to partially define a dimension

# use a constant to create a liquid variable

# use a constant to bring in lexp stuff

# use a constant to create a massive liquid if

# use a constant to create consistant sets of formatting

}

# search in a list with constants in your derived table



explore: fw_constants {}
