view: k_means_predict {
  label: "3. BQML K-Means: Run Predictions"

  derived_table: {
    sql:  SELECT *
          FROM ml.PREDICT(MODEL looker_pdts.{% parameter model_name %},
              (SELECT * FROM ${k_means_training_data.SQL_TABLE_NAME}
              )
            )
    ;;
  }

  parameter: model_name {
    label: "BQML Model Name"
    description: "Which BQML Model do you want to use for predictions?"
    type: unquoted
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
