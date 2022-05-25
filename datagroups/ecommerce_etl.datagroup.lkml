datagroup: ecommerce_etl {
  sql_trigger: select max(created_at) from looker-private-demo.ecomm.order_items ;;
  max_cache_age: "24 hours"
}
