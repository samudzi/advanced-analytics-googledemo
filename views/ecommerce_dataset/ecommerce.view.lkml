include: "thelook_event.view"


view: +user_order_facts {
  #extends: [user_order_facts]

  dimension: is_active_customer {
    type: yesno
    sql: ${latest_order_date} >= DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) ;;
  }


  measure: active_user_count {
    type: count_distinct
    filters: [is_active_customer: "yes"]
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



}
