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
}

constant: reuse_sql1 {
  value: "${created_date} < ${orders.created_date}"
}

constant: reuse_sql2 {
  value: "${orders.status} is not null"
}

#####

### String Formatting



### String Re-Use



### Experimental
