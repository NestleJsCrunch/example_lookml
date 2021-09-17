include: "/dynamicfields/base_dynamic.view"

view: simple_logic {

### sc_orders contains all the base fields we will be using in our dynamic fields
  extends: [base_dynamic]

### Not defining a sql_table_name, because this view is inheriting it from sc_orders
  # sql_table_name:


######################
### 1. Dynamic Measure
######################

## the aggregation_type parameter lets the user select the calculation they want to perform on measure_field
# type: unquoted because we will be injecting the value directly into SQL
# unquoted injects a literal value instead of a string. can be used to inject a function or object reference
parameter: aggregation_type {
  type: unquoted

  allowed_value: {label:"Smallest Value" value:"MIN"}
  allowed_value: {label:"Largest Value" value:"MAX"}
  allowed_value: {label:"Average of Values" value:"AVG"}
  allowed_value: {label:"Sum of Values" value:"SUM"}
  allowed_value: {label:"Count of Values" value:"COUNT"}

}

## the measure_field parameter lets the user select the field they want the calculation from aggregation_type performed on
# type: string because we will not be injecting the value into SQL, instead we will evaluate the value with a case when

parameter: measure_field {
  type: string

  allowed_value: {}
}
