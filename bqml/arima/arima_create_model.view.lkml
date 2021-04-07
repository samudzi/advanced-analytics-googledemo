# view: arima_create_model {
#   label: "BQML 1 - Create or Replace Model"

#   derived_table: {
#     persist_for: "1 second"

#     create_process: {

#       sql_step: CREATE OR REPLACE MODEL looker_pdts.{% parameter arima_workflow_parameters.select_model_name %}
#                 OPTIONS(MODEL_TYPE = 'ARIMA',
#                         time_series_timestamp_col = '{% parameter arima_training_data.select_time_column %}',
#                         time_series_data_col = '{% parameter arima_training_data.select_data_column %}''
#                         )
#                 AS (SELECT {% parameter arima_training_data.select_time_column %},
#                       {% parameter arima_training_data.select_data_column %}
#                     FROM ${users_dataset.SQL_TABLE_NAME})
#     ;;

#         sql_step: CREATE TABLE IF NOT EXISTS looker_pdts.BQML_ARIMA_MODEL_INFO
#                 (model_name STRING,
#                 time_column STRING,
#                 data_column STRING,
#                 created_at TIMESTAMP)
#     ;;

#           sql_step: INSERT INTO looker_pdts.BQML_ARIMA_MODEL_INFO
#               (model_name,
#               time_column,
#               data_column,
#               created_at)

#               SELECT '{% parameter arima_workflow_parameters.select_model_name %}' AS model_name,
#                 '{% parameter arima_training_data.select_time_column %}' AS time_column,
#                 '{% parameter arima_training_data.select_data_column %}' AS data_column,
#                 CURRENT_TIMESTAMP AS created_at
#     ;;
#         }
#       }

#       dimension: status {
#         label: "Build Status (REQUIRED)"
#         description: "Selecting this field is required to start building your model"
#         type: string
#         sql: 'Complete' ;;
#       }
#     }
