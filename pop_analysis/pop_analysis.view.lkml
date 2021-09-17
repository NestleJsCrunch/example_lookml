include: "/calendar_table/calendar_table.view"

view: dynamic_dates {

  extends: [calendar_table]

  # redefine to add condition

  dimension_group: calendar {
    type: time
    sql:  {% condition date_filter %} ${dt} {% endcondition %};;
    datatype: date
    timeframes: [date, day_of_month, day_of_week, day_of_week_index, day_of_year, week, week_of_year, month, month_name, month_num, fiscal_month_num, year, fiscal_year, fiscal_quarter_of_year, quarter_of_year, quarter, raw]
    convert_tz: no
  }

  parameter: time_frame {
    type: string
    allowed_value: { label:"Day" value:"date" }
    allowed_value: { label:"Month" value:"month"}
    allowed_value: {label:"Quarter" value:"quarter"}
    allowed_value: {label:"Year" value:"year"}
  }

  filter: date_filter {}

  dimension: output_dim {
    type: string
    sql:
    {% if time_frame._parameter_value == "'date'" %}
    ${calendar.date}
    {% elsif timeframe._parameter_value == '"month"' %}
    ${calendar.month}
    {% elsif timeframe._parameter_value == '"quarter"' %}
    ${calendar.quarter}
    {% elsif timeframe._parameter_value == '"year"' %}
    ${calendar.year}
    {% else %}
    'Select a timeframe'
    {% endif %}
    ;;
  }

  }
