view: workflow_parameters {

  parameter: select_model_name {
    view_label: "BQML K-Means Clustering Workflow"
    label: "BQML Model Name (required)"
    description: "Enter a unique name to create a new BQML model or select an existing model to use in your analysis"
    type: unquoted
    suggest_explore: bqml_k_means_model_metadata
    suggest_dimension: bqml_k_means_model_metadata.model_name
    suggest_persist_for: "0 minutes"
  }

}
