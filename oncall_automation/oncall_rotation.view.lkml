view: oncall_rotation_sheet {
  sql_table_name: `lookerdcl.on_call_notifs.oncall_rotation4`
    ;;

  dimension: amer_business_hours_9am_5pm_pacific {
    type: string
    sql: ${TABLE}.AMER_Business_Hours_9am_5pm_Pacific ;;
  }

  dimension: apac_business_hours_9am_5pm_tokyo {
    type: string
    sql: ${TABLE}.APAC_Business_Hours_9am_5pm_Tokyo ;;
  }

  dimension: emea_business_hours_9am_5pm_dublin {
    type: string
    sql: ${TABLE}.EMEA_Business_Hours_9am_5pm_Dublin ;;
  }

  dimension_group: week_of_ {
    type: time
    description: "%m/%d/%E4Y"
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
    sql: ${TABLE}.Week_Of_ ;;
  }

  dimension: weekend_hours_friday_5pm_sunday_8pm_pacific {
    type: string
    sql: ${TABLE}.Weekend_Hours_Friday_5pm_Sunday_8pm_Pacific ;;
  }

}
