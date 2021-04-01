view: arima_training_data {
  label: "BQML 1 - Create or Replace Model"

  derived_table: {
    persist_for: "1 second"
    sql_create: CREATE OR REPLACE VIEW looker_pdts.{% parameter arima_workflow_parameters.select_model_name %}_training_data
                AS  SELECT {% parameter select_time_column %},
                      {% parameter select_data_column %}
                    FROM ${arima_users_dataset.SQL_TABLE_NAME}
  ;;
  }

  parameter: select_time_column {
    label: "Select a Time Field (REQUIRED)"
    description: "Choose the field that indicates the date or time of the data you want to forecast"
    type: unquoted
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
    suggest_persist_for: "0 minutes"
  }

  parameter: select_data_column {
    label: "Select the Data Field (REQUIRED)"
    description: "Choose the field that contains the data you want to forecast"
    type: unquoted
    suggest_explore: field_suggestions
    suggest_dimension: field_suggestions.column_name
    suggest_persist_for: "0 minutes"
  }
}
