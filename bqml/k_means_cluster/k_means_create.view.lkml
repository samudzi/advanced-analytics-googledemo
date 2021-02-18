view: k_means_create {
  derived_table: {
    datagroup_trigger: bqml_model_creation
    sql_create: CREATE OR REPLACE MODEL looker_pdts.{% parameter k_means_training_data.model_name %} OPTIONS(model_type='kmeans',
                  num_clusters = {% parameter k_means_training_data.number_of_clusters %}) AS (
                SELECT * FROM ${k_means_training_data.SQL_TABLE_NAME}
    ;;
  }

}
