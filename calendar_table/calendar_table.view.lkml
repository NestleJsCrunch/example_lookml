view: calendar_table {

  derived_table: {
    sql_trigger_value: select 7 ;;

    ## create_process https://docs.looker.com/reference/view-params/create_process
    ## we're doing it this way because MySQL doesn't have a GENERATE_DATE_ARRAY like bigquery does, if so we'd do this: https://stackoverflow.com/a/58169269/8859720
    ## instead we're doing this http://www.brianshowalter.com/calendar_tables
    create_process: {
      sql_step:
        CREATE TABLE ${SQL_TABLE_NAME} (
        dt DATE NOT NULL PRIMARY KEY,
        y SMALLINT NULL,
        q tinyint NULL,
        m tinyint NULL,
        d tinyint NULL,
        dw tinyint NULL,
        w tinyint NULL,
        isWeekday BINARY(1) NULL
        );;

      sql_step:
        CREATE TABLE IF NOT EXISTS ints ( i tinyint ) ;;

      sql_step:
        INSERT INTO ints VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9) ;;

      sql_step:
        INSERT INTO ${SQL_TABLE_NAME} (dt)
        SELECT DATE('2010-01-01') + INTERVAL a.i*10000 + b.i*1000 + c.i*100 + d.i*10 + e.i DAY
        FROM ints a JOIN ints b JOIN ints c JOIN ints d JOIN ints e
        WHERE (a.i*10000 + b.i*1000 + c.i*100 + d.i*10 + e.i) <= 11322
        ORDER BY 1 ;;

      sql_step:
        UPDATE ${SQL_TABLE_NAME}
        SET isWeekday = CASE WHEN dayofweek(dt) IN (1,7) THEN 0 ELSE 1 END,
                y = YEAR(dt),
                q = quarter(dt),
                m = MONTH(dt),
                d = dayofmonth(dt),
                dw = dayofweek(dt),
                w = week(dt)  ;;
        }
      }

  dimension: dt {
    type: date_raw
    sql:  ${TABLE}.dt ;;
    convert_tz: no
  }

  dimension_group: calendar {
    type: time
    sql:  ${dt} ;;
    datatype: date
    timeframes: [date, day_of_month, day_of_week, day_of_week_index, day_of_year, week, week_of_year, month, month_name, month_num, fiscal_month_num, year, fiscal_year, fiscal_quarter_of_year, quarter_of_year, quarter, raw]
    convert_tz: no
  }

  }
