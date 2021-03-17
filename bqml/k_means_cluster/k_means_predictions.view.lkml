view: k_means_predictions {
  label: "4. BQML K-Means: Get Predictions"
  derived_table: {
    sql:  SELECT *
          FROM ml.PREDICT(MODEL looker_pdts.{% parameter k_means_model.model_name %},
              (SELECT * FROM ${k_means_training_data.SQL_TABLE_NAME}
              )
            )
    ;;
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: centroid_id {
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  dimension: nearest_centroids_distance {
    type: string
    sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  }

}
