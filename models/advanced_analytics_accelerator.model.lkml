## define connections
include: "/env/connections"
include: "/env/datagroups"

# define accessible explores
include: "/explores/ecommerce_data.explore"
include: "/explores/cdnow.explore"
include: "/explores/ga.explore"

include: "/explores/bqml_k_means.explore"
include: "/explores/bqml_k_means_model_metadata.explore"
include: "/explores/bqml_k_means_jt_test.explore"
include: "/explores/bqml_k_means_jt_test2.explore"

include: "/explores/bqml_arima.explore"
include: "/explores/bqml_arima_model_metadata.explore"

#include relevant dashboards
include: "/dashboards/clv_demo_1.dashboard"
include: "/dashboards/clv_demo_2.dashboard"

############ Model Configuration #############

persist_with: ecommerce_etl
