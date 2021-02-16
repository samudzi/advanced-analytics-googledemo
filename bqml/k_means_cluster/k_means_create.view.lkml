view: k_means_create {
  derived_table: {
    datagroup_trigger: bqml_model_creation
    sql:  CREATE OR REPLACE MODEL looker_pdts.user_segmentation OPTIONS(model_type='kmeans',
            num_clusters=3) AS
          SELECT * FROM ${k_means_training_data.SQL_TABLE_NAME}
    ;;
  }
}
