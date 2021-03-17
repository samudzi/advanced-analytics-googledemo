include: "/bqml/**/*.view"
include: "/explores/ecommerce_data.explore"

explore: bqml_k_means {
  extends: [order_items]
  view_name: order_items
  label: "BQML K-Means Clustering"
  description: "Use this Explore to build a BQML K-means Clustering model"

  join: k_means_training_data {
    sql: ;;
    relationship: one_to_one
  }
  join: k_means_model {
    sql:;;
    relationship: one_to_one
  }

  join: k_means_predictions {
    type: left_outer
    sql_on: ${users.id} = ${k_means_predictions.user_id} ;;
    relationship: one_to_one
  }
}

explore: field_suggestions { hidden: yes }
