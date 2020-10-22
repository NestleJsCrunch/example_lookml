view: bikeshare_stations_copy {
  sql_table_name: @{table_phillip_bike}
    ;;

  dimension: dockcount {
    type: number
    sql: ${TABLE}.dockcount ;;
  }

  dimension_group: installation {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.installation_date ;;
  }

  dimension: landmark {
    type: string
    sql: ${TABLE}.landmark ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: station_id {
    type: number
    sql: ${TABLE}.station_id ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}

view: windowed {
  derived_table: {
  sql:
  select *, rank() over (partition by landmark order by installation_date desc) as ranking
  from @{table_phillip_bike}
  ;;
}
extends: [bikeshare_stations_copy]

dimension: ranking {
  type: number
}

  measure: max_date {
    type: date
    sql: max(installation_date) ;;
  }

  measure: min_date {
    type: date
    sql: min(installation_date) ;;
  }


}

explore: windowed {
  # if we want to only show most recent ranking
  sql_always_where: ${ranking} = 1 ;;
}
