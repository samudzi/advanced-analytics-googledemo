datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}
