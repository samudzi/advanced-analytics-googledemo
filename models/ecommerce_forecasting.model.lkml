connection: "advanced_analytics_accelerator"

# include relevant bqml k-means block files from imported project
include: "//bqml_arima_block/explores/bqml_arima.explore"
include: "//bqml_arima_block/use_case_refinements/ecommerce_forecasting/*"

# # include relevant files from this project
include: "/views/ecommerce_dataset/**/*.view"
include: "/datagroups/ecommerce_etl.datagroup"


explore: ecommerce_revenue_forecasting {
  label: "BQML ARIMA Plus: eCommerce Forecasting"
  description: "Use this Explore to create BQML ARIMA Plus models to forecast various revenue metrics using Looker's eCommerce dataset"

  persist_with: ecommerce_etl

  extends: [bqml_arima]
  view_name: order_items

  join: arima_explain_forecast {
    type: full_outer
    relationship: many_to_one
    sql_on: ${order_items.created_date} = ${arima_explain_forecast.time_series_date} ;;
  }

  join: order_facts {
    type: left_outer
    view_label: "Orders"
    relationship: many_to_one
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
  }

  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: user_order_facts {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id} ;;
    relationship: many_to_one
  }
}

# hide explores used by native derived tables

explore: +order_items {
  hidden: yes
}
