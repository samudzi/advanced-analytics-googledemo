## define connections
include: "/env/connections"

# define accessible explores
include: "/explores/ecommerce_data.explore"
include: "/explores/cdnow.explore"
include: "/explores/ga.explore"
include: "/explores/bqml_examples.explore"

#include relevant dashboards
include: "/dashboard/clv_demo_1.dashboard"
include: "/dashboard/clv_demo_2.dashboard"

############ Model Configuration #############

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

persist_with: ecommerce_etl

############ Base Explores #############
