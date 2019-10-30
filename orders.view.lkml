view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
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
  parameter: brand_selector {
    type: unquoted
    allowed_value: {
      label: "brand 1"
      value: "cancelled"
    }
    allowed_value: {
      label: "brand 2"
      value: "pending"
    }
    allowed_value: {
      label: "brand 3"
      value: "complete"
    }
  }

  dimension: matches_brand {
    type: yesno
    sql: {% parameter brand_selector %} = ${status_img} ;;
  }

  dimension: status_img {
    type: string
    sql: ${TABLE}.status ;;
    html:
    {% if brand_selector._parameter_value == "cancelled" %}
    <img src="https://www.canva.com/learn/wp-content/uploads/2019/04/biggest-brand-logos-adidas-2.jpg" />
    {% elsif brand_selector._parameter_value == "pending" %}
    <img src="https://www.canva.com/learn/wp-content/uploads/2019/04/biggest-brand-logos-marvel.jpg" />
    {% else %}
    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhz84LnXfvTBUJTt6Iizpgc1BTxRWMzea23CQdBxE4H7yLv6QM&s" />
    {% endif %} ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

#   measure: test_html {
#     type: count
#     html: {% if value < 1 }
#       <ul>
#       <h1>"TRUE" </h1>
#
#       </ul>
#          {% else %}
#       <p>  "FAlSE" </p>
#         {% endif %} ;;
#   }
}
