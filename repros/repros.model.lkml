connection: "@{alternate_connection}"
# connection: "thelook"

include: "/repros/*.view.lkml"                # include all views in the views/ folder in this project

### this is the primary explore to test ui bugs in explores
explore: uibugs {}





### example explores

explore: date_table {
  join: bikeshare_trips_copy {
    type: full_outer
    sql_on: ${bikeshare_trips_copy.end_date} = ${date_table.generated_date_date} ;;
  }
}
