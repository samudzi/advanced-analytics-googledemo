view: k_means_centroids {
  label: "BQML 3.2 - Centroid Info"

  derived_table: {
    sql: SELECT * FROM ML.CENTROIDS(MODEL looker_pdts.{% parameter k_means_predict.model_name %}) ;;
  }

  dimension: centroid_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.centroid_id ;;
  }

  dimension: feature {
    type: string
    sql: ${TABLE}.feature ;;
  }

  dimension: numerical_value {
    type: number
    sql: ${TABLE}.numerical_value ;;
  }

  dimension: categorical_value {
    type: string
    sql: ${TABLE}.categorical_value ;;
  }

  measure: count {
    type: count
  }

}
