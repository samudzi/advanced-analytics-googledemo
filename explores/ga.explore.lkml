include: "/views/google_analytics/*.view"
include: "/views/ecommerce_dataset/**/*.view"

explore: ga_clusters {
  view_label: "Advanced Analytics Accelerator"
  label: "GA predictions"

  join: inventory_items {
    relationship: many_to_many
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    type: inner
  }

  join: repeat_purchase_facts {
    relationship: one_to_one
    sql_on:  ${repeat_purchase_facts.order_id} = ${orders.order_id} ;;
    type: inner
  }

  join: users {
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id} ;;
    type: inner
  }

  join: ga_clvpred {
    relationship: one_to_one
    type: inner
    sql_on: ${ga_clusters.id} = ${ga_clvpred.id} ;;
  }

  join: order_items {
    relationship: many_to_one
    type: inner
    sql_on: ${order_items.user_id} = ${ga_clvpred.id} ;;
  }

  join: orders {
    relationship: many_to_one
    type: inner
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
  }
}
