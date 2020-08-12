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

# use a constant to create a liquid variable

  parameter: liquid_param {
    type: string
    allowed_value: {label: "cancelled" value: "cancelled"}
    allowed_value: {label: "pending" value: "pending"}
    allowed_value: {label: "complete" value: "complete"}
  }

  dimension: satisfies_filter {
    type: yesno
    sql:
    @{filtered_measure_check}
    end ;;
  }

  measure: filtered_by_param {
    type: count
    # filters: [satisfies_filter1: "yes"]
  }

  # dimension: case_case {
  #   type: string
  #   sql: case when @{filtered_measure_check} = 'yes' then ${created_date_date}
  #     else ${id}
  #     end
  #   ;;
  # }


# use a constant to bring in lexp stuff

dimension: expressions {
  type: string
  expression: @{filtered_measure_check} ;;
}

# use a constant to create a massive liquid if

# use a constant to create consistant sets of formatting

  dimension: con_id {
    type: string
    sql: @{reuse_sql1} + 5 and @{reuse_sql2} ;;
  }

  dimension: con_id2 {
    type: string
    sql: @{reuse_sql1} + 2 and @{reuse_sql2} ;;
  }

  dimension: con_id6 {
    type: string
    sql: @{reuse_sql1} + 6 and @{reuse_sql2} ;;
  }
}

# explore: fw_constants {}

# search in a list with constants in your derived table

# use a constant to define a derived table
