include: "/explores/ecommerce_data.explore"
include: "/bqml/k_means/*.view"

explore: bqml_k_means_order_items {
  extends: [order_items]
  view_name: order_items
  group_label: "Advanced Analytics with BQML"
  label: "BQML K-Means: eCommerce"
  description: "Use this Explore to build, evaluate and operationalize a BQML K-means Clustering model entirely from the Looker Explore interface"

  persist_for: "0 minutes"

  always_filter: {
    filters: [workflow_parameters.select_model_name: ""]
  }

  join: workflow_parameters {
    sql: ;;
  relationship: one_to_one
  }

  join: k_means_training_data {
    sql: ;;
    relationship: one_to_one
  }

  join: k_means_create_model {
    sql: ;;
    relationship: one_to_one
  }

  join: k_means_evaluate {
    type: cross
    relationship: many_to_one
  }

  join: k_means_predict {
    type: left_outer
    sql_on: ${users.id} = ${k_means_predict.user_id} ;;
    relationship: one_to_one
  }

  join: k_means_centroids {
    type: left_outer
    sql_on: ${k_means_predict.centroid_id} = ${k_means_centroids.centroid_id} ;;
    relationship: many_to_one
  }

  join: centroid_categorical_value {
      sql: LEFT JOIN UNNEST(k_means_centroids.categorical_value) as centroid_categorical_value ;;
      relationship: one_to_many
  }
}
