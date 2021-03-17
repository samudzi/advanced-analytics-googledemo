## define connections
include: "/env/connections"
include: "/env/datagroups"

# define accessible explores
include: "/explores/ecommerce_data.explore"
include: "/explores/cdnow.explore"
include: "/explores/ga.explore"
include: "/explores/bqml_customer_segmentation.explore"
include: "/explores/bqml_k_means.explore"

#include relevant dashboards
include: "/dashboards/clv_demo_1.dashboard"
include: "/dashboards/clv_demo_2.dashboard"

############ Model Configuration #############

persist_with: ecommerce_etl

############ Base Explores #############

include: "/bqml/k_means_cluster/k_means_training_data.view"
