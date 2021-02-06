connection: "looker-private-demo"


include: "/explores/ecommerce_data.explore"
include: "/explores/cdnow.explore"

############ Model Configuration #############

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

persist_with: ecommerce_etl

############ Base Explores #############
