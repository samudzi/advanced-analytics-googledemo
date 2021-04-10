connection: "advanced_analytics_accelerator"


############ Include Declarations #############

#include relevant explores
include: "/explores/order_items.explore"
include: "/explores/cdnow.explore"
include: "/explores/ga.explore"
include: "/explores/customer_segmentation.explore"


#include relevant dashboards
include: "/dashboards/clv_demo_1.dashboard"
include: "/dashboards/clv_demo_2.dashboard"


############ Model Configuration #############

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

persist_with: ecommerce_etl
