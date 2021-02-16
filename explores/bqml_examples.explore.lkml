include: "/explores/ecommerce_data.explore"
include: "/bqml/**/*.view"

explore: bqml_order_items {
  extends: [order_items]
  view_name: order_items
  label: "BQML: Order Items"

  join: k_means_predictions {
    type: left_outer
    sql_on: ${users.id} = ${k_means_predictions.users_id} ;;
    relationship: one_to_one
  }
}
