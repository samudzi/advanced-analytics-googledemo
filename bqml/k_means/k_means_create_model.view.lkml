view: k_means_create_model {
  label: "1. BQML K-Means: Create or Replace Model"

  derived_table: {
    datagroup_trigger: bqml_model_creation

    create_process: {
      sql_step: CREATE OR REPLACE MODEL looker_pdts.{% parameter model_name %}
                  OPTIONS(MODEL_TYPE = 'KMEANS'
                  {% if number_of_clusters._parameter_value == 'null' %}
                  {% else %}
                  , NUM_CLUSTERS = {% parameter number_of_clusters %}
                  {% endif %}
                  , KMEANS_INIT_METHOD = 'KMEANS++'
                  , STANDARDIZE_FEATURES = TRUE)
                  AS (SELECT * EXCEPT({{ _filters['k_means_training_data.item_id'] | sql_quote | replace: '"','' | remove: "'" }})
                      FROM ${k_means_training_data.SQL_TABLE_NAME})
      ;;
    }
  }

  parameter: model_name {
    label: "Name Your BQML Model"
    description: "Enter a unique name for your BQML model"
    type: unquoted
  }

  parameter: number_of_clusters {
    label: "Select Number of Clusters (optional)"
    description: "Enter the number of clusters you want to create"
    type: number
    default_value: "null"
  }

}

view: create_table {
  derived_table: {
    datagroup_trigger: bqml_model_creation
    sql_create: CREATE TABLE IF NOT EXISTS ${k_means_create_model.SQL_TABLE_NAME} (col_1 INT64) ;;
  }
}
