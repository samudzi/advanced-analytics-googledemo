view: k_means_model {
  label: "2. BQML K-Means: Create Model"
  derived_table: {
    datagroup_trigger: bqml_model_creation
    sql_create: CREATE OR REPLACE MODEL looker_pdts.{% parameter model_name %}
                OPTIONS(MODEL_TYPE = 'KMEANS'
                , NUM_CLUSTERS = {% parameter number_of_clusters %}
                , KMEANS_INIT_METHOD = 'KMEANS++'
                , STANDARDIZE_FEATURES = TRUE)
                AS (SELECT * EXCEPT({% parameter k_means_training_data.item_id %}) FROM ${k_means_training_data.SQL_TABLE_NAME}) ;;
  }

  parameter: model_name {
    label: "Name Your BQML Model"
    description: "Enter a unique name for your BQML model"
    type: unquoted
  }

  parameter: number_of_clusters {
    label: "Select Number of Clusters"
    description: "Enter the number of clusters you want to create"
    type: unquoted
  }

}
