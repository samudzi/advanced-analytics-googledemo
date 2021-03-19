explore: bqml_k_means_model_metadata {
  group_label: "Advanced Analytics Workflows"
  label: "BQML K-Means Model Metadata"
  persist_for: "0 minutes"
}

view: bqml_k_means_model_metadata {
  label: "BQML K-Means Model Metadata"
  sql_table_name: `advanced-analytics-accelerator.looker_pdts.BQML_K_MEANS_MODEL_INFO` ;;

  dimension: model_name {
    suggest_persist_for: "0 minutes"
    primary_key: yes
    type: string
    sql: ${TABLE}.model_name ;;
  }

  dimension: number_of_clusters {
    type: string
    sql: ${TABLE}.number_of_clusters ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: features {
    type: string
    sql: ${TABLE}.features ;;
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
