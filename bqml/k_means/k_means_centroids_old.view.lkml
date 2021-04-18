view: k_means_centroids {
  label: "BQML 4 - Cluster Centroid Info"

  sql_table_name: ML.CENTROIDS(MODEL looker_pdts.{% parameter workflow_parameters.select_model_name %}) ;;

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
    hidden: yes
    type: string
    sql: ${TABLE}.categorical_value ;;
  }

  dimension: feature_category {
    type: string
    sql: concat(${TABLE}.feature,case when ${centroid_categorical_value.category} is not null then concat(': ',${centroid_categorical_value.category}) else '' end)  ;;
  }

  dimension: value {
    type: number
    sql: coalesce(${numerical_value},${centroid_categorical_value.value})  ;;
  }
}

view: centroid_categorical_value {
  label: "BQML 4 - Cluster Centroid Info: Categorical Value"

  dimension: category {
    primary_key: yes
    required_fields: [k_means_centroids.centroid_id, k_means_centroids.feature]
  }

  dimension: value {
    required_fields: [k_means_centroids.centroid_id, k_means_centroids.feature]
  }
}
