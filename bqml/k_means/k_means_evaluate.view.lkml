view: k_means_evaluate {
  label: "BQML 2 - Model Evalution Info"

  sql_table_name: ML.EVALUATE(MODEL looker_pdts.{% parameter workflow_parameters.select_model_name %}) ;;

  # parameter: select_model_name {
  #   label: "Select an Existing BQML Model"
  #   description: "Which BQML model do you want to evaluate?"
  #   type: unquoted
  #   suggest_explore: bqml_k_means_model_info
  #   suggest_dimension: bqml_k_means_model_info.select_model_name
  #   suggest_persist_for: "0 minutes"
  #   }

  dimension: davies_bouldin_index {
    type: number
    sql: ${TABLE}.davies_bouldin_index ;;
  }

  dimension: mean_squared_distance {
    type: number
    sql: ${TABLE}.mean_squared_distance ;;
  }

}
