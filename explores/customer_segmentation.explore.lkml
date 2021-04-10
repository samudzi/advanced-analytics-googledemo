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

  extends: [order_items, bqml_k_means]
  view_name: order_items

  join: k_means_predict {
    type: left_outer
    sql_on: ${k_means_predict.item_id} = ${users.id} ;;
    relationship: one_to_one
  }
}
