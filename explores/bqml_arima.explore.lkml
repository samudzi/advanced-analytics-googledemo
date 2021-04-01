include: "/explores/ecommerce_data.explore"
include: "/bqml/arima/*.view"

explore: bqml_arima_order_items {
  extends: [order_items]
  view_name: order_items
  group_label: "Advanced Analytics with BQML"
  label: "BQML ARIMA: eCommerce"
  description: "Use this Explore to build, evaluate and operationalize a BQML ARIMA model entirely from the Looker Explore interface"

  persist_for: "0 minutes"

  always_filter: {
    filters: [arima_workflow_parameters.select_model_name: ""]
  }

  join: arima_workflow_parameters {
    sql: ;;
    relationship: one_to_one
  }

join: arima_training_data {
  sql: ;;
  relationship: one_to_one
}

join: arima_create_model {
  sql: ;;
  relationship: one_to_one
}

# join: arima_evaluate {
#   type: cross
#   relationship: many_to_one
# }
}
