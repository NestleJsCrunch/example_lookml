include: "*.view.lkml"

view: users {
  sql_table_name: demo_db_generator.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    html: <a href="https://docs.google.com/document/d/1u9Aqozwtf4xEW1rBcjEJN4CtHVuTd9TAISeA6aGO0ik/edit?usp=sharing" target="_blank"></a><img src="http://drive.google.com/uc?export=view&id=1iG8jB0h5z1yGOHJuOZNSd6ugfNj7XCZU" alt="test" width="300" height="100" align="left"> ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }

  dimension: con_id {
    type: string
    sql: @{reuse_sql1} + 5 and @{reuse_sql2} ;;
  }


  filter: pp_dates{
    type: date
  }

  filter: cp_dates {
    type:  date
  }

}

explore: users_test {
  from: users
  join: orders {
    sql_on: ${users_test.id} = ${orders.user_id} ;;
  }
}

#   dimension: current_or_previous {
#     type: string
#     sql: CASE
#     WHEN {% date_start pp_dates %} <= ${created_date} AND {% date_end pp_dates %} >= ${created_date}
#     THEN "Previous Period"
#     WHEN {% date_start cp_dates %} <= ${created_date} AND {% date_end cp_dates %} >= ${created_date}
#     THEN "Current Period"
#     ELSE
#     "Not in either period"
#     END
#     ;;
#   }


#   dimension: previous_period {
#     type: string
#     description: "The reporting period as selected by the Previous Period Filter"
#     sql:
#         CASE
#           WHEN {% date_start previous_period_filter %} is not null AND {% date_end previous_period_filter %} is not null /* date ranges or in the past x days */
#             THEN
#               CASE
#                 WHEN ${created_raw} >=  {% date_start previous_period_filter %}
#                   AND ${created_raw} <= {% date_end previous_period_filter %}
#                   THEN 'This Period'
#                 WHEN ${created_raw} >= DATEADD(day,-1*DATEDIFF(day,{% date_start previous_period_filter %},
#                 {% date_end previous_period_filter %} ) + 1, DATEADD(day,-1,{% date_start previous_period_filter %} ) )
#                   AND ${created_raw} < DATEADD(day,-1,{% date_start previous_period_filter %} ) + 1
#                   THEN 'Previous Period'
#               END
#           WHEN {% date_start previous_period_filter %} is null AND {% date_end previous_period_filter %} is null /* has any value or is not null */
#             THEN CASE WHEN ${created_raw} is not null THEN 'Has Value' ELSE 'Is Null' END
#           WHEN {% date_start previous_period_filter %} is null AND {% date_end previous_period_filter %} is not null /* on or before */
#             THEN
#               CASE
#                 WHEN  ${created_raw} <=  {% date_end previous_period_filter %} THEN 'In Period'
#                 WHEN  ${created_raw} >   {% date_end previous_period_filter %} THEN 'Not In Period'
#               END
#          WHEN {% date_start previous_period_filter %} is not null AND {% date_end previous_period_filter %} is null /* on or after */
#            THEN
#              CASE
#                WHEN  ${created_raw} >= {% date_start previous_period_filter %} THEN 'In Period'
#                WHEN  ${created_raw} < {% date_start previous_period_filter %} THEN 'Not In Period'
#             END
#         END ;;
#   }
# }
