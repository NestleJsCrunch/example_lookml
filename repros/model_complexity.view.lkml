### ### ### ### ### ####
### ### use case ### ###
### date fill table ####
### ### ### ### ### ####

# use this as the base table for your explore(s)
# will do all dates from '2015-06-01'
# source: https://stackoverflow.com/questions/38306016/populating-a-table-with-all-dates-in-a-given-range-in-google-bigquery

view: date_table {
  derived_table: {
    sql:

SELECT generated_date
FROM UNNEST(
    GENERATE_DATE_ARRAY(DATE('2015-06-01'), CURRENT_DATE(), INTERVAL 1 DAY)
) AS generated_date

;;
    }

dimension_group: generated_date {
  type: time
  datatype: date
}
}
