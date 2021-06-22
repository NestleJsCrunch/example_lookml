view: badctegen2 {
  derived_table: {
    sql:
    select foo from bar;;
  }

  dimension: lol {
    sql: foo ;;
  }
}



view: badctegen1 {
  derived_table: {
    sql:
    select foo from ${badctegen2.SQL_TABLE_NAME}
    ;;
  }

  dimension: lol {
    sql: foo ;;
  }

  }

  view: basebad {
    sql_table_name: basebad ;;

    dimension: lol {
      sql: lol ;;
    }
  }

  view: badndt {
    derived_table: {
      explore_source: bad_base {
        column: lol {}
      }
    }
    dimension: lol {}
    }
