view: customer_segmentation_results {
  label: "BQML K-Means: Get Results"
  sql_table_name: looker_pdts.{% parameter customer_segmentation_create.model_name %}_predict ;;

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: centroid_id {
    label: "Segment ID"
    type: number
    sql: ${TABLE}.CENTROID_ID ;;
  }

  # dimension: nearest_centroids_distance {
  #   label: "Nearest Segment Distance"
  #   type: string
  #   sql: ${TABLE}.NEAREST_CENTROIDS_DISTANCE ;;
  # }
}
