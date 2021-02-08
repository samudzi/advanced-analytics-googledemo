view: cdnow_clvpred {
  sql_table_name: `advanced-analytics-accelerator.GMP_demo.cdnow_clvpred`
    ;;

  dimension: id {
    type: number
    sql: ${TABLE}.cust ;;
  }

  dimension_group: first {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first ;;
  }

  dimension: litt {
    type: number
    sql: ${TABLE}.litt ;;
  }

  dimension: predicted_clv {
    type: number
    sql: ${TABLE}.predicted_clv ;;
  }

  dimension: predicted_fut_transactions {
    type: number
    sql: ${TABLE}.predicted_fut_transactions ;;
  }

  dimension: sales {
    type: number
    sql: ${TABLE}.sales ;;
  }

  dimension: sales_avg {
    type: number
    sql: ${TABLE}.sales_avg ;;
  }

  dimension: salesx {
    type: number
    sql: ${TABLE}.salesx ;;
  }

  dimension: tcal {
    type: number
    sql: ${TABLE}.Tcal ;;
  }

  dimension: tstar {
    type: number
    sql: ${TABLE}.Tstar ;;
  }

  dimension: tx {
    type: number
    sql: ${TABLE}.tx ;;
  }

  dimension: x {
    type: number
    sql: ${TABLE}.x ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  ### Added measures

  measure: average_predicted_clv {
    type: average
    sql: ${predicted_clv} ;;
  }

  measure: average_sum_future_transactions {
    type: average
    sql: ${predicted_fut_transactions} ;;
  }
}
