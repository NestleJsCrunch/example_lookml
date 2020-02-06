include: "ndt_explore_base.model"

view: ndt_orders_top10 {
  derived_table: {
    explore_source: source_report_base
    {
      derived_column: top_rank { sql: RANK() OVER (ORDER BY count DESC) ;; }
      column: count {}
      column: created_date {}
      column: status {}
    }

    }

  dimension: top_rank {
    type: number }

  dimension: data_split {
    type: string
    sql: CASE WHEN ${top_rank} >= 11 THEN 'Other' ELSE ${top_rank} END ;;
    }

  dimension: status {}

  measure: sum_count {
    type: sum
    sql: ${TABLE}.count ;;
  }


    }
