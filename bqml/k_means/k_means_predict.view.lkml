view: k_means_predict {
  label: "BQML 3 - Model Predictions"

  sql_table_name: ML.PREDICT(MODEL looker_pdts.{% parameter workflow_parameters.select_model_name %},
                      TABLE looker_pdts.{% parameter workflow_parameters.select_model_name %}_training_data
                    )
  ;;

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
