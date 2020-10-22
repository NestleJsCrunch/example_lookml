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

explore: model_complexity {}

### derived table example

view: windowedalt {
  derived_table: {
    sql:

    SELECT
    *, rank() over (partition by join_count order by instance desc) as ranking
    FROM `potent-arcade-167816.performance_benchmarking.model_complexity`
    ;;
  }
  extends: [model_complexity]

  dimension: ranking {}
}
