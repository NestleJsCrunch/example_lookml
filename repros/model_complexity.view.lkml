### base view

view: model_complexity {
  sql_table_name:
  (
  @{bq_updt_begin}
  from @{table_phillip}
  )
    ;;

  dimension: dimension_count {
    type: number
    sql: ${TABLE}.dimension_count ;;
  }

  dimension: explore_count {
    type: number
    sql: ${TABLE}.explore_count ;;
  }

  dimension: field_count {
    type: number
    sql: ${TABLE}.field_count ;;
  }

  dimension: hidden_or_erroring_explore_count {
    type: number
    sql: ${TABLE}.hidden_or_erroring_explore_count ;;
  }

  dimension: instance {
    type: string
    sql: ${TABLE}.instance ;;
  }

  dimension: join_count {
    type: number
    sql: ${TABLE}.join_count ;;
  }

  dimension: measure_count {
    type: number
    sql: ${TABLE}.measure_count ;;
  }

  dimension: model_count {
    type: number
    sql: ${TABLE}.model_count ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}

explore: bad_ndt {}

### derived table example

view: bad_ndt {
  derived_table: {
    persist_for: "30 minutes"
    sql:
  select '2016-01-11T07:00:00.000+00:00' as a
  union all
  select '2016-01-11T07:15:00.000+00:00' as a
  union all
  select '2016-01-11T07:30:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T07:45:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T11:00:00.000+00:00' as a
  union all
  select '2016-01-11T11:15:00.000+00:00' as a
  union all
  select '2016-01-11T11:30:00.000+00:00' as a
  UNION ALL
  select '2016-01-11T11:45:00.000+00:00' as a

  ;; }

    dimension_group: test {
      type: time
      sql: ${TABLE}.a ;;
      convert_tz: no
    }
}
