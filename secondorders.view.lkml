view: secondorders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
#     label: "this should be the second explore"
    html: <font color="#42a338 ">{{ rendered_value }}</font> ;;
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;

  }

  dimension: user_id {
    type: number
#     label: "this should be the second explore"
    html: <font color="#42a338 ">{{ rendered_value }}</font> ;;
    link: {
      label: "liquid linking out"
      url: "/dashboards/402?
      date%20liquid={{ _filters['secondexplore.created_date'] }}
      &status%20liquid={{ value }}
      &id%20liquid={{ secondexplore.id | url_encode }}"
    }
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }
}
