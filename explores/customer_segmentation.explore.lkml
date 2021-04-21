# include relevant bqml k-means block files from imported project
include: "//bqml_k_means_block/explores/bqml_k_means.explore"
include: "//bqml_k_means_block/use_case_refinements/customer_segmentation/*"

# include relevant files from this project
include: "/views/ecommerce_dataset/**/*.view"
include: "/datagroups/ecommerce_etl.datagroup"


explore: customer_segmentation {
  label: "BQML K-Means: Customer Segmentation"
  description: "Use this Explore to create BQML K-means Clustering models for customer segmentation analysis"

  persist_with: ecommerce_etl

  extends: [bqml_k_means]
  view_name: users

  join: k_means_predict {
    type: left_outer
    sql_on: ${users.id} = ${k_means_predict.item_id} ;;
    relationship: one_to_one
  }

  join: user_order_facts {
    view_label: "Users"
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: order_facts {
    type: left_outer
    view_label: "Orders"
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: repeat_purchase_facts {
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
    relationship: many_to_one
  }
}
