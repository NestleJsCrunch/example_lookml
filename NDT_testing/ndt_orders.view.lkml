include: "/NDT_testing/*.view.lkml"
# If necessary, uncomment the line below to include explore_source.
#include: "athena.model.lkml"
# include: "/models/athena.model"
# include: "/views/source_report.view"
#
# include: "/generic_source_report.dashboard"

view: source_report_top_10 {

  # parameter: data_split_parameter {

  derived_table: {
    explore_source: source_report {
      column: created_date {}
      column: count_thing {field: orders.count
      }
      column: status {}
      derived_column: top_rank { sql: RANK() OVER (ORDER BY count DESC) ;; }
#      bind_all_filters: yes
#Rquires ALL fields used in filters & parameters from all explores and dashboards that reference this NDT
#       bind_filters: {
#         to_field: data_split_parameter
#         from_field: data_split_parameter
#         to_field: data_split_raw
#         from_field: data_split_raw
#         to_field: publisher_company_id
#         from_field: publisher_company_id
#         to_field: lookup_company_publisher.publisher_salesperson
#         from_field: lookup_company_publisher.publisher_salesperson
#         to_field: advertiser_company_id
#         from_field: advertiser_company_id
#         to_field: source_id
#         from_field: source_id
#         to_field: container_type
#         from_field: container_type
#         to_field: date_granularity
#         from_field: source_report.date_granularity
#         to_field: device
#         from_field: source_report.device
#         to_field: device_simple
#         from_field: device_simple
#       }


    }
  }
  dimension: count_thing {}
  dimension: top_rank {type: number}
  dimension: data_split {
    sql: CASE WHEN ${top_rank} >= 11 THEN 'Other' ELSE ${count_thing} END ;;
#     sql: CASE WHEN ${top_rank} >= 11 THEN 'Other' ELSE ${data_split_raw} END ;;
  }
  # dimension: total_impressions {
  #   type: number
  # }
  # dimension: total_conversions {
  #   type: number
  # }
  # dimension: total_clicks {
  #   type: number
  # }
  # dimension: gross_eCPA {
  #   type: number
  # }
  # dimension: avg_CPC {
  #   type: number
  # }
  # dimension: click_CVR {
  #   type: number
  # }
  # dimension: item_RPM {
  #   type: number
  # }
  # dimension: item_CVR {
  #   type: number
  # }
  # dimension: item_CTR {
  #   type: number
  # }
}
