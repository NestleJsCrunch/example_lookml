# view: testing_constants {
#   derived_table: {
#     sql:
#     SELECT
#     *
#     FROM
#     {% if cast(@{project_name} as char) == 'staging' %}
#     demo_db.orders
#     {% else %}
#     demo_db.users
#     {% endif %}
#     WHERE
#     ;;
#   }
#
#   dimension: id {
#     type: string
#     sql: ${TABLE}.id ;;
#   }
#
#   }
#   explore: testing_constants {}
