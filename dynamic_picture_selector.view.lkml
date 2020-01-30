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
### we're starting with this field, which references your database column with brands
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  parameter: brand_selector {
    ### labels are arbitrary, can be whatever the user will recognize when filtering
    ### values are not arbitrary, needs to match what you have in the database column
    type: string
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

### brand_selector here needs to be the name of your parameter
### status_img needs to be the name of your html img dimension
  dimension: matches_brand {
    type: yesno
    sql: {% parameter brand_selector %} = ${status_img} ;;
  }

  dimension: status_img {
    type: string
    sql: ${TABLE}.status ;;
    ### each if statement should be evaluating the field, then spitting out a corresponding image
    ### replace status here with the name of your field
    ### replace cancelled, pending, and complete with the names of your brands
    ### insert elsif statements for more brands
    html:
    {% if status._value == "cancelled" %}
    <img src="http://designbeep.designbeep.netdna-cdn.com/wp-content/uploads/2014/03/1.Brand-Logos-with-Hidden-Messages.jpg" />
    {% elsif status._value == "pending" %}
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
