view: k_means_create_model {
  label: "BQML 1 - Create or Replace Model"

  derived_table: {
    persist_for: "1 hour"

    create_process: {

      sql_step: CREATE OR REPLACE MODEL looker_pdts.{% parameter name_your_model %}
                  OPTIONS(MODEL_TYPE = 'KMEANS'
                  {% if choose_number_of_clusters._parameter_value == 'auto' %}
                  {% else %}
                  , NUM_CLUSTERS = {% parameter choose_number_of_clusters %}
                  {% endif %}
                  , KMEANS_INIT_METHOD = 'KMEANS++'
                  , STANDARDIZE_FEATURES = TRUE)
                  AS (SELECT * EXCEPT({{ _filters['k_means_training_data.select_item_id'] | sql_quote | replace: '"','' | remove: "'" }})
                      FROM ${k_means_training_data.SQL_TABLE_NAME})
      ;;

      sql_step: CREATE TABLE IF NOT EXISTS looker_pdts.BQML_K_MEANS_MODEL_INFO
                  (model_name STRING,
                  number_of_clusters STRING,
                  item_id STRING,
                  features STRING,
                  created_at TIMESTAMP)
      ;;

      sql_step: INSERT INTO looker_pdts.BQML_K_MEANS_MODEL_INFO
                (model_name,
                number_of_clusters,
                item_id,
                features,
                created_at)

                SELECT '{% parameter name_your_model %}' AS model_name,
                  '{% parameter choose_number_of_clusters %}' AS number_of_clusters,
                  {% assign item_id = _filters['k_means_training_data.select_item_id'] | sql_quote | replace: '"','' | remove: "'" %}
                    '{{ item_id }}' AS item_id,
                  {% assign features = _filters['k_means_training_data.select_features'] | sql_quote | replace: '"','' | remove: "'" %}
                    '{{ features }}' AS features,
                  CURRENT_TIMESTAMP AS created_at
      ;;
    }
  }

  parameter: name_your_model {
    label: "Name Your BQML Model"
    description: "Enter a unique name for your BQML model"
    type: unquoted
    suggest_explore: bqml_k_means_model_info
    suggest_dimension: bqml_k_means_model_info.model_name
  }

  parameter: choose_number_of_clusters {
    label: "Select Number of Clusters (optional)"
    description: "Enter the number of clusters you want to create"
    type: number
    default_value: "auto"
  }

  dimension: model_name {
    type: string
    sql: '{% parameter name_your_model %}' ;;
  }

  dimension: number_of_clusters {
    type: string
    sql: '{% parameter choose_number_of_clusters %}' ;;
  }

  dimension: item_id {
    type: string
    sql: '{{ item_id }}' ;;
  }

  dimension: features {
    type: string
    sql: '{{ features }}' ;;
  }

}
