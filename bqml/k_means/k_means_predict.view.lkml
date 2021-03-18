view: k_means_predict {
  label: "BQML 3 - Run Predictions"

  sql_table_name: ML.PREDICT(MODEL looker_pdts.{% parameter model_name %},
                    (SELECT * FROM ${k_means_training_data.SQL_TABLE_NAME})
                  )
  ;;

  parameter: model_name {
    label: "Select an Existing BQML Model"
    description: "Which BQML model do you want to use for predictions?"
    type: unquoted
    suggest_explore: bqml_k_means_model_info
    suggest_dimension: bqml_k_means_model_info.model_name
  }

  dimension: user_id {
    primary_key: yes
    # hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: centroid_id {
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  # dimension: nearest_centroids_distance {
  #   type: string
  #   sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  # }

  measure: count {
    type: count
  }

}
