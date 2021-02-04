include: "//thelook_event/views/*"


view: +user_order_facts {

  dimension: is_active_customer {
    type: yesno
    sql: ${latest_order_date} >= DATE_ADD(${order_items.created_date}, INTERVAL -30 DAY) ;;
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
