view: arima_workflow_parameters {

  parameter: select_model_name {
    view_label: " BQML ARIMA Workflow"
    label: "BQML Model Name (REQUIRED)"
    description: "Enter a unique name to create a new BQML model or select an existing model to use in your analysis"
    type: unquoted
    suggest_explore: bqml_arima_model_metadata
    suggest_dimension: bqml_arima_model_metadata.model_name
    suggest_persist_for: "0 minutes"
  }
}
