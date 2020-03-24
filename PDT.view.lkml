# view: pdt {
#  derived_table: {
#    sql:
# select "id","bad_column", "arbitrary_number", "other_number"
# UNION
# select 1,"word",'', 0
# UNION
# select 2,"bad",'', 0
# UNION
# select 3,"thing",'', 0
# UNION
# select 4,"",'', 5
# UNION
# select 5,"",2,34
# UNION
# select 6,"",1,0
# UNION
# select 7,"word",2,0
# UNION
# select 8,"something",1,32
# ;;
#  }
# dimension: id {primary_key:yes}
# dimension: bad_column {}
# dimension: arbitrary_number {}
# measure: other_number {
#   type:count_distinct
#   sql_distinct_key: ${id} ;;
#   }
# }

view: pdt {
  derived_table: {
    sql:
    select 'date', 'string', 'number'
    union
    select '2019-01-01', 'dd', 1
    union
    select '2019-02-02 10:00:00', 'ff', 2
    union
    select '2019-03-03 11:00:00 f', 'gg', 3
    union
    select '2019-01-01', 'hh', 3
    union
    select '2019-02-02 10:00:00', 'jj', 4
    union
    select '2019-03-03 11:00:00 f', 'kk', 5
    ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }
  dimension: string {
    type: string
    sql: ${TABLE}.string ;;
  }
  dimension: number {
    type: number
    sql: ${TABLE}.number ;;
  }

  dimension: date_drill {
    type: string
    sql: ${TABLE}.date ;;
    link: {
label: "please break"
url: "/explore/derpinthesme/pdt?fields=pdt.date_drill,pdt.date,pdt.number,pdt.string&f[pdt.date_drill]={{ rendered_value }}&sorts=pdt.date&limit=500&query_timezone=UTC&vis=%7B%7D&filter_config=%7B%22pdt.date_drill%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22{{ rendered_value }}%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&dynamic_fields=%5B%5D&origin=share-expanded"
    }
    }

}
explore: pdt {}
