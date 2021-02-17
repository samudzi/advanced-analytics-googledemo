include: "/bqml/**/*.view"

include: "/explores/ecommerce_data.explore"

explore: bqml_order_items {
  extends: [order_items]
  view_name: order_items
  label: "Looker + BQML Examples"

  # join: k_means_training_data {
  #   type: left_outer
  #   sql_on: ${users.id} = ${k_means_training_data.user_id} ;;
  #   relationship: one_to_one
  # }

  # join: k_means_create {
  #   type: cross
  #   relationship: one_to_one
  # }

  # join: k_means_predictions {
  #   type: left_outer
  #   sql_on: ${users.id} = ${k_means_predictions.users_id} ;;
  #   relationship: one_to_one
  # }

  join: customer_segmentation {
    type: left_outer
    sql_on: ${users.id} = ${customer_segmentation.user_id} ;;
    relationship: one_to_one
  }
}
