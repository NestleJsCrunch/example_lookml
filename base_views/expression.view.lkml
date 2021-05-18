include: "/base_views/base_orders.view"

view: expression {
  extends: [base_orders]

  ### math functions
  # https://docs.looker.com/exploring-data/creating-looker-expressions/looker-functions-and-operators#mathematical_functions_and_operators

  dimension:  abs {
    type: number
    expression: abs(${id}) ;;
  }

  dimension: ceiling {
    type: number
    expression: ceiling(${id}) ;;
  }

  dimension: exp {
    type: number
    expression: exp(${id}) ;;
  }

  dimension: floor {
    type: number
    expression: floor(${id}) ;;
  }

  dimension: ln {
    type: number
    expression: ln(${id}) ;;
  }

  dimension: log {
    type: number
    expression: log(${id}) ;;
  }

  dimension: mod {
    type: number
    expression: mod(${id},2) ;;
  }

  dimension:  power {
    type: number
    expression: power(${id},2) ;;
  }



}
