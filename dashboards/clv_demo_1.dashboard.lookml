# - dashboard: customer_lifetime_value_demo
#   title: Customer Lifetime Value Demo
#   layout: newspaper
#   preferred_viewer: dashboards-next
#   elements:
#   - title: M - Cluster Analysis
#     name: M - Cluster Analysis
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_boxplot
#     fields: [cdnow_clusters.cluster_id, cdnow_clusters.minimum_monetary, cdnow_clusters.monetary_25_percentile,
#       cdnow_clusters.median_monetary, cdnow_clusters.monetary_75_percentile, cdnow_clusters.maximum_monetary]
#     sorts: [cdnow_clusters.cluster_id]
#     limit: 500
#     x_axis_gridlines: false
#     y_axis_gridlines: true
#     show_view_names: false
#     show_y_axis_labels: true
#     show_y_axis_ticks: true
#     y_axis_tick_density: default
#     y_axis_tick_density_custom: 5
#     show_x_axis_label: true
#     show_x_axis_ticks: true
#     y_axis_scale_mode: linear
#     x_axis_reversed: false
#     y_axis_reversed: false
#     plot_size_by_field: false
#     series_types: {}
#     defaults_version: 1
#     listen: {}
#     row: 4
#     col: 16
#     width: 8
#     height: 6
#   - title: F Cluster Analysis
#     name: F Cluster Analysis
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_boxplot
#     fields: [cdnow_clusters.cluster_id, cdnow_clusters.minimum_frequency, cdnow_clusters.frequency_25_percentile,
#       cdnow_clusters.frequency_75_percentile, cdnow_clusters.median_frequency, cdnow_clusters.maximum_frequency]
#     sorts: [cdnow_clusters.maximum_frequency desc]
#     limit: 500
#     x_axis_gridlines: false
#     y_axis_gridlines: true
#     show_view_names: false
#     show_y_axis_labels: true
#     show_y_axis_ticks: true
#     y_axis_tick_density: default
#     y_axis_tick_density_custom: 5
#     show_x_axis_label: true
#     show_x_axis_ticks: true
#     y_axis_scale_mode: linear
#     x_axis_reversed: false
#     y_axis_reversed: false
#     plot_size_by_field: false
#     series_types: {}
#     defaults_version: 1
#     listen: {}
#     row: 4
#     col: 8
#     width: 8
#     height: 6
#   - title: R - Cluster Analysis
#     name: R - Cluster Analysis
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_boxplot
#     fields: [cdnow_clusters.cluster_id, cdnow_clusters.minimum_recency, cdnow_clusters.recency_25_percentile,
#       cdnow_clusters.median_recency, cdnow_clusters.recency_75_percentile, cdnow_clusters.maximum_recency]
#     sorts: [cdnow_clusters.recency_75_percentile desc]
#     limit: 500
#     x_axis_gridlines: false
#     y_axis_gridlines: true
#     show_view_names: false
#     show_y_axis_labels: true
#     show_y_axis_ticks: true
#     y_axis_tick_density: default
#     y_axis_tick_density_custom: 5
#     show_x_axis_label: true
#     show_x_axis_ticks: true
#     y_axis_scale_mode: linear
#     x_axis_reversed: false
#     y_axis_reversed: false
#     plot_size_by_field: false
#     show_row_numbers: true
#     transpose: false
#     truncate_text: true
#     hide_totals: false
#     hide_row_totals: false
#     size_to_fit: true
#     table_theme: white
#     limit_displayed_rows: false
#     enable_conditional_formatting: false
#     header_text_alignment: left
#     header_font_size: 12
#     rows_font_size: 12
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     defaults_version: 1
#     series_types: {}
#     listen: {}
#     row: 4
#     col: 0
#     width: 8
#     height: 6
#   - name: RFM Cluster Analysis
#     type: text
#     title_text: RFM Cluster Analysis
#     subtitle_text: ''
#     body_text: |-
#       Recency, frequency, monetary value is a marketing analysis tool used to identify a company's or an organization's best customers by using certain measures. The RFM model is based on three quantitative factors:

#       1. Recency: How recently a customer has made a purchase
#       2. Frequency: How often a customer makes a purchase
#       3. Monetary Value: How much money a customer spends on purchases

#       RFM analysis numerically ranks a customer in each of these three categories, generally on a scale of 1 to 5 (the higher the number, the better the result). The "best" customer would receive a top score in every category.

#       Links to AI notebooks here: <a href>https://20cf9b43906e2261-dot-us-west1.notebooks.googleusercontent.com/lab?authuser=0</a>
#     row: 0
#     col: 0
#     width: 24
#     height: 6
#   - title: Predicted CLV by Cluster
#     name: Predicted CLV by Cluster
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_grid
#     fields: [cdnow_clusters.cluster_id, cdnow_clvpred.average_predicted_clv]
#     sorts: [cdnow_clvpred.average_predicted_clv desc]
#     limit: 500
#     show_view_names: false
#     show_row_numbers: true
#     transpose: false
#     truncate_text: true
#     hide_totals: false
#     hide_row_totals: false
#     size_to_fit: true
#     table_theme: white
#     limit_displayed_rows: false
#     enable_conditional_formatting: false
#     header_text_alignment: left
#     header_font_size: '12'
#     rows_font_size: '12'
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     show_sql_query_menu_options: false
#     show_totals: true
#     show_row_totals: true
#     series_cell_visualizations:
#       cdnow_clvpred.average_predicted_clv:
#         is_active: true
#     series_value_format:
#       cdnow_clvpred.average_predicted_clv:
#         name: usd
#         format_string: "$#,##0.00"
#         label: U.S. Dollars (2)
#     defaults_version: 1
#     listen: {}
#     row: 12
#     col: 0
#     width: 8
#     height: 3
#   - title: Predicted number of future transactions by cluster
#     name: Predicted number of future transactions by cluster
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_grid
#     fields: [cdnow_clusters.cluster_id, cdnow_clvpred.average_sum_future_transactions]
#     sorts: [cdnow_clvpred.average_sum_future_transactions desc]
#     limit: 500
#     show_view_names: false
#     show_row_numbers: true
#     transpose: false
#     truncate_text: true
#     hide_totals: false
#     hide_row_totals: false
#     size_to_fit: true
#     table_theme: white
#     limit_displayed_rows: false
#     enable_conditional_formatting: false
#     header_text_alignment: left
#     header_font_size: '12'
#     rows_font_size: '12'
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     show_sql_query_menu_options: false
#     show_totals: true
#     show_row_totals: true
#     series_cell_visualizations:
#       cdnow_clvpred.average_sum_future_transactions:
#         is_active: true
#     series_value_format:
#       cdnow_clvpred.average_sum_future_transactions:
#         name: decimal_1
#         format_string: "#,##0.0"
#         label: Decimals (1)
#     defaults_version: 1
#     listen: {}
#     row: 15
#     col: 0
#     width: 8
#     height: 3
#   - title: Top 30 customers by predicted CLV
#     name: Top 30 customers by predicted CLV
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_bar
#     fields: [cdnow_clvpred.id, cdnow_clvpred.average_predicted_clv]
#     sorts: [cdnow_clvpred.average_predicted_clv desc]
#     limit: 500
#     x_axis_gridlines: false
#     y_axis_gridlines: true
#     show_view_names: false
#     show_y_axis_labels: true
#     show_y_axis_ticks: true
#     y_axis_tick_density: default
#     y_axis_tick_density_custom: 5
#     show_x_axis_label: true
#     show_x_axis_ticks: true
#     y_axis_scale_mode: linear
#     x_axis_reversed: false
#     y_axis_reversed: false
#     plot_size_by_field: false
#     trellis: ''
#     stacking: ''
#     limit_displayed_rows: true
#     legend_position: center
#     point_style: none
#     show_value_labels: false
#     label_density: 25
#     x_axis_scale: auto
#     y_axis_combined: true
#     ordering: none
#     show_null_labels: false
#     show_totals_labels: false
#     show_silhouette: false
#     totals_color: "#808080"
#     y_axes: [{label: '', orientation: bottom, series: [{axisId: cdnow_clvpred.average_predicted_clv,
#             id: cdnow_clvpred.average_predicted_clv, name: Average Predicted Clv}],
#         showLabels: true, showValues: true, valueFormat: "$0.00", unpinAxis: false,
#         tickDensity: default, tickDensityCustom: 5, type: linear}]
#     limit_displayed_rows_values:
#       show_hide: show
#       first_last: first
#       num_rows: '30'
#     label_value_format: '"$#.00;($#.00)"'
#     series_types: {}
#     x_axis_datetime_label: ''
#     defaults_version: 1
#     listen: {}
#     row: 12
#     col: 8
#     width: 8
#     height: 6
#   - title: High Value Churn Risk Customers
#     name: High Value Churn Risk Customers
#     model: advanced_analytics_accelerator
#     explore: cdnow_clusters
#     type: looker_grid
#     fields: [cdnow_clvpred.id, cdnow_clvpred.average_predicted_clv, cdnow_clvpred.average_sum_future_transactions]
#     filters:
#       cdnow_clvpred.average_sum_future_transactions: "[0.01, 0.5]"
#     sorts: [cdnow_clvpred.average_predicted_clv desc]
#     limit: 500
#     show_view_names: false
#     show_row_numbers: true
#     transpose: false
#     truncate_text: true
#     hide_totals: false
#     hide_row_totals: false
#     size_to_fit: true
#     table_theme: white
#     limit_displayed_rows: true
#     enable_conditional_formatting: false
#     header_text_alignment: left
#     header_font_size: '12'
#     rows_font_size: '12'
#     conditional_formatting_include_totals: false
#     conditional_formatting_include_nulls: false
#     show_sql_query_menu_options: false
#     show_totals: true
#     show_row_totals: true
#     series_cell_visualizations:
#       cdnow_clvpred.average_predicted_clv:
#         is_active: true
#     limit_displayed_rows_values:
#       show_hide: show
#       first_last: first
#       num_rows: '30'
#     series_value_format:
#       cdnow_clvpred.average_predicted_clv:
#         name: usd
#         format_string: "$#,##0.00"
#         label: U.S. Dollars (2)
#     defaults_version: 1
#     listen: {}
#     row: 12
#     col: 16
#     width: 8
#     height: 6
#   - name: CLV predictions
#     type: text
#     title_text: CLV predictions
#     subtitle_text: Predicting CLV using the Beta-Geometric NBD model over the next
#       365 days
#     body_text: ''
#     row: 10
#     col: 0
#     width: 24
#     height: 2
