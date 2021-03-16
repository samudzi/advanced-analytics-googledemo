## Use this file to define datagroups and caching rules

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

datagroup: bqml_model_creation {
  # sql_trigger: select current_timestamp ;;
  sql_trigger: select 1 ;;
}
