# view: testing_dumby_data {
#     derived_table: {
#       explore_source: liquid_waterfalls {
#         column: created_month {}
#       }
#       persist_for: "24 hours"
#     }
#     dimension: created_month {
#       label: "Liquid_testing Created Month"
#       type: string
#       sql: substr(created_month, 1, 7) ;;
#     }
#   }
#   explore: testing_dumby_data {}

#   view: testing {
#     derived_table: {
#       explore_source: testing_dumby_data {
#       column: created_month {}
#       }
#     }
#     dimension: created_month {
#       type: string
#       sql: concat(${TABLE}.created_month, "-01") ;;
#     }
#   }
#   explore: testing {}

# view: testing1 {
#   derived_table: {
#     explore_source: testing {
#       column: created_month {}
#     }
#   }

#   dimension_group: month_group {
#     type: time
#     timeframes: [month]
#     datatype: date
#     sql: ${TABLE}.created_month ;;
#   }
# }

# explore: testing1 {
#   conditionally_filter: {
#     filters: {
#       field: month_group_month
#       value: ">= 1287461847"
#     }
#     unless: []
#   }
# }
