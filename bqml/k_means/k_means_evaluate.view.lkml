view: k_means_evaluate {
  label: "2 - Evaluate Model"

  derived_table: {
    sql: SELECT * FROM ML.EVALUATE(MODEL looker_pdts.{% parameter model_name %}) ;;
  }

  parameter: model_name {
    label: "Select an Existing BQML Model"
    description: "Which BQML model do you want to evaluate?"
    type: unquoted
  }

  dimension: davies_bouldin_index {
    type: number
    sql: ${TABLE}.davies_bouldin_index ;;
  }

  dimension: mean_squared_distance {
    type: number
    sql: ${TABLE}.mean_squared_distance ;;
  }

}
