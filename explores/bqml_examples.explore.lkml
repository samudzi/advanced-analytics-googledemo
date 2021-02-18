include: "/bqml/**/*.view"

include: "/explores/ecommerce_data.explore"

explore: bqml_order_items {
  extends: [order_items]
  view_name: order_items
  label: "Looker + BQML Examples"

  join: customer_segmentation_create {
    sql_on: 1=1 ;;
    relationship: one_to_one
  }

  join: customer_segmentation_results {
    type: left_outer
    sql_on: ${users.id} = ${customer_segmentation_results.user_id} ;;
    relationship: one_to_one
  }
}
