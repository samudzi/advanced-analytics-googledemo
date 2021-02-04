include: "//thelook_event/views/*"


view: +user_order_facts {

  dimension: is_active_customer {
    type: yesno
    sql: ${latest_order_date} >= DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) ;;
  }


  measure: active_user_count {
    type: count_distinct
    filters: [lifetime_orders: "< 2", first_order_date: "before 30 days ago"]
    sql: ${user_id} ;;
  }

  measure: total_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: lost_user_count {
    type: number
    sql:  ${total_users} - ${active_user_count};;
  }

  dimension: is_active_customer {}


}


explore: aaa_analytics {
  group_label: "Advanced Analytics Accelerator"
  label: "e-commerce data"
  view_name: order_items

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
