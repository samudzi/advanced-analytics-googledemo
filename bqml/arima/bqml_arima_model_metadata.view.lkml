view: bqml_arima_model_metadata {
  label: "BQML ARIMA Model Metadata"
  sql_table_name: `advanced-analytics-accelerator.looker_pdts.BQML_ARIMA_MODEL_INFO` ;;

  dimension: model_name {
    suggest_persist_for: "0 minutes"
    primary_key: yes
    type: string
    sql: ${TABLE}.model_name ;;
  }

  dimension: time_column {
    type: string
    sql: ${TABLE}.time_column ;;
  }

  dimension: data_column {
    type: string
    sql: ${TABLE}.data_column ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [raw,time,]
    sql: ${TABLE}.created_at ;;
  }

  measure: count {
    type: count
    drill_fields: [model_name, created_at_time]
  }
}
