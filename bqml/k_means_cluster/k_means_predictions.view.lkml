view: k_means_predictions {
  derived_table: {
    sql:  SELECT *
          FROM ml.PREDICT(MODEL looker_pdts.user_segmentation,
              (SELECT
                *
              FROM ${k_means_training_data.SQL_TABLE_NAME}
              )
            )
    ;;
  }

  dimension: users_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.users_id ;;
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
