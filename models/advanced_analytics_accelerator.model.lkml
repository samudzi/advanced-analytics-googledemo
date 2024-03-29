connection: "advanced_analytics_accelerator"


############ Include Declarations #############

# include relevant explores
# include: "/explores/order_items.explore"
# include: "/explores/cdnow.explore"
# include: "/explores/ga.explore"


# include: "/explores/bqml_k_means.explore"
# include: "/explores/bqml_k_means_model_metadata.explore"
# include: "/explores/bqml_k_means_jt_test.explore"
# include: "/explores/bqml_k_means_jt_test2.explore"

# include relevant datagroups
include: "/datagroups/default.datagroup"
include: "/datagroups/ecommerce_etl.datagroup"

# include relevant dashboards
# include: "/dashboards/clv_demo_1.dashboard"
# include: "/dashboards/clv_demo_2.dashboard"


############ Model Configuration #############

persist_with: default
