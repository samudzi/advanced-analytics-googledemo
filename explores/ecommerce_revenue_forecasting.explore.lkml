# include relevant bqml k-means block files from imported project
include: "//bqml_arima_block/explores/bqml_arima.explore"
include: "//bqml_arima_block/use_case_refinements/ecommerce_revenue_forecasting/*"

# include relevant files from this project
include: "/views/ecommerce_dataset/**/*.view"
include: "/datagroups/ecommerce_etl.datagroup"
