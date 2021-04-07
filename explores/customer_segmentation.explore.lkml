include: "//bqml_k_means_block/explores/bqml_k_means.explore"
include: "//bqml_k_means_block/use_case_refinements/customer_segmentation/*"
include: "/explores/order_items.explore"

explore: customer_segmentation {
  label: "BQML K-Means: Customer Segmentation"
  extends: [bqml_k_means]
  fields: [ALL_FIELDS*, -order_items.gross_margin, -order_items.days_until_next_order]

  join: users {
    type: left_outer
    sql_on: ${k_means_predict.item_id} = ${users.id} ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: user_order_facts {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
  }

  join: order_facts {
    type: left_outer
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
  }
}
