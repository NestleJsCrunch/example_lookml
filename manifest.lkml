project_name: "derpinthesme"
constant: project_name {
  value: "staging"
}
# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }


#####

## Constants
constant: sql_snip {
  value: "${id}"
  export: override_optional
}

constant: reuse_sql1 {
  value: "${created_date} < ${orders.created_date}"
}

constant: reuse_sql2 {
  value: "${orders.status} is not null"
}

constant: list {
  value: "1,2,3,4"
}

constant: building {
  value: "@{list},6,7,8,9,10"
}

constant: dashboard_link {
  value: "`/dashboards/580?ID={{ value | url_encode }}`"
}

constant: filter {
  value: "complete"
}

constant: subquery {
  value: "(SELECT MAX(${id}) FROM demo_db_generator.orders WHERE ${status} LIKE 'complete')"
}

constant: mysql_ddiff {
  value: "DATEDIFF("
}
constant: bq_ddiff {
  value: "DATE_DIFF("
}

constant: filtered_measure_check {
  value: "case when ${status} = {[ fw_constants.liquid_param._parameter_value }}
    then yes
    else no"
}

#####

### String Formatting



### String Re-Use



### Experimental
