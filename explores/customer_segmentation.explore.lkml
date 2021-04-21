# include relevant bqml k-means block files from remote project
include: "//bqml_k_means_block/explores/bqml_k_means.explore"
include: "//bqml_k_means_block/use_case_refinements/customer_segmentation/*"

# include relevant local project files for use case
include: "/explores/order_items.explore"
include: "/datagroups/ecommerce_etl.datagroup"

explore: customer_segmentation {
  label: "BQML K-Means: Customer Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for customer segmentation analysis"

  persist_with: ecommerce_etl

  extends: [bqml_k_means]
  view_name: users
  fields: [ALL_FIELDS*, -order_items.gross_margin, -order_items.days_until_next_order]

  join: order_items {
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: user_order_facts {
    view_label: "Users"
    type: inner
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }

  join: k_means_predict {
    type: full_outer
    sql_on: ${users.id} = ${k_means_predict.item_id} ;;
    relationship: one_to_one
  }
}
