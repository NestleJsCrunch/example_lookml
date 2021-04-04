view: uibugs {
  view_label: "if it aint broke dont push it"

  ### ### ### ### ###### ### ### ### ###
  ### ### ### ### ###### ### ### ### ###
  ### the wonderful uibugs of looker ###
  ### ### ### ### ###### ### ### ### ###
  ### ### ### ### ###### ### ### ### ###

  ## 2021 ## {

  ### b1: field picker jumps around when searching {
  # created 30 fields, search for 'a'
  # jira: https://looker.atlassian.net/browse/EX-1123
  dimension: a1 {}
  dimension: a2 {}
  dimension: a3 {}
  dimension: a4 {}
  dimension: a5 {}
  dimension: a6 {}
  dimension: a7 {}
  dimension: a8 {}
  dimension: a9 {}
  dimension: a10 {}
  dimension: a11 {}
  dimension: a12 {}
  dimension: a13 {}
  dimension: a14 {}
  dimension: a15 {}
  dimension: a16 {}
  dimension: a17 {}
  dimension: a18 {}
  dimension: a19 {}
  dimension: a20 {}
  dimension: a21 {}
  dimension: a22 {}
  dimension: a23 {}
  dimension: a24 {}
  dimension: a25 {}
  dimension: a26 {}
  dimension: a27 {}
  dimension: a28 {}
  dimension: a29 {}
  dimension: a30 {}
  ### end b1 }


  ## end 2021 ## }

  }

view: sqlbugs {


  ### ### ### ### ###### ### ### ### ###
  ### ### ### ### ###### ### ### ### ###
  ### oh wonderful sqlbugs of looker ###
  ### ### ### ### ###### ### ### ### ###
  ### ### ### ### ###### ### ### ### ###

  ## 2021 ## {


  ## end 2021 ## }


}

view: jank {
  derived_table: {
    sql:
    select  ROW_NUMBER() OVER() row_number, start_station_id, start_station_name
    from `potent-arcade-167816.SF_BS.bikeshare_trips_copy`
    WHERE (start_station_name ) = 'Japantown' OR (start_station_name ) = 'Mezes'
    ORDER BY 2 {% parameter jank %};;
  }

  parameter: jank {
    type: unquoted
    allowed_value: {label:"a" value:"DESC"}
    allowed_value: {label:"b" value:"ASC"}
  }

  dimension: row_number {}

  dimension: start_station_id {
    type: number
    sql: ${TABLE}.start_station_id ;;
  }

  dimension: start_station_name {
    type: string
    sql: ${TABLE}.start_station_name ;;
    order_by_field: row_number
  }
}

explore: jank {}
