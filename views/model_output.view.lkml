view: model_output {
  sql_table_name: `asoba-stocktrading.stocks_ml.model_2`
    ;;

  dimension: primary_key {
    type: string
    sql: concat(${date},${ticker},${close}) ;;
    primary_key: yes
  }

  dimension: adj_close {
    type: number
    sql: ${TABLE}.adj_close ;;
  }

  dimension: close {
    type: number
    sql: ${TABLE}.close ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: dema_9_period_dema {
    type: number
    sql: ${TABLE}.DEMA_9_period_DEMA ;;
  }

  dimension: ema_9_period_ema {
    type: number
    sql: ${TABLE}.EMA_9_period_EMA ;;
  }

  dimension: er_10_period_er {
    type: number
    sql: ${TABLE}.ER_10_period_ER ;;
  }

  dimension: ev_macd_macd {
    type: number
    sql: ${TABLE}.EV_MACD_MACD ;;
  }

  dimension: ev_macd_signal {
    type: number
    sql: ${TABLE}.EV_MACD_SIGNAL ;;
  }

  dimension: evwma_20_period_evwma_ {
    type: number
    sql: ${TABLE}.EVWMA_20_period_EVWMA_ ;;
  }

  dimension: high {
    type: number
    sql: ${TABLE}.high ;;
  }

  dimension: hma_16_period_hma_ {
    type: number
    sql: ${TABLE}.HMA_16_period_HMA_ ;;
  }

  dimension: ift_rsi_ift_rsi {
    type: number
    sql: ${TABLE}.IFT_RSI_IFT_RSI ;;
  }

  dimension: int64_field_0 {
    type: number
    sql: ${TABLE}.int64_field_0 ;;
  }

  dimension: kama_20_period_kama_ {
    type: number
    sql: ${TABLE}.KAMA_20_period_KAMA_ ;;
  }

  dimension: low {
    type: number
    sql: ${TABLE}.low ;;
  }

  dimension: macd_macd {
    type: number
    sql: ${TABLE}.MACD_MACD ;;
  }

  dimension: macd_signal {
    type: number
    sql: ${TABLE}.MACD_SIGNAL ;;
  }

  dimension: mom_mom {
    type: number
    sql: ${TABLE}.MOM_MOM ;;
  }

  dimension: open {
    type: number
    sql: ${TABLE}.open ;;
  }

  dimension: percent_change {
    type: number
    sql: ${TABLE}.percent_change ;;
  }

  dimension: ppo_histo {
    type: number
    sql: ${TABLE}.PPO_HISTO ;;
  }

  dimension: ppo_ppo {
    type: number
    sql: ${TABLE}.PPO_PPO ;;
  }

  dimension: ppo_signal {
    type: number
    sql: ${TABLE}.PPO_SIGNAL ;;
  }

  dimension: roc_roc {
    type: number
    sql: ${TABLE}.ROC_ROC ;;
  }

  dimension: rsi_14_period_rsi {
    type: number
    sql: ${TABLE}.RSI_14_period_RSI ;;
  }

  dimension: sma_41_period_sma {
    type: number
    sql: ${TABLE}.SMA_41_period_SMA ;;
  }

  dimension: smm_9_period_smm {
    type: number
    sql: ${TABLE}.SMM_9_period_SMM ;;
  }

  dimension: smma_smma {
    type: number
    sql: ${TABLE}.SMMA_SMMA ;;
  }

  dimension: sp_percent_change {
    type: number
    sql: ${TABLE}.sp_percent_change ;;
  }

  dimension: ssma_9_period_ssma {
    type: number
    sql: ${TABLE}.SSMA_9_period_SSMA ;;
  }

  dimension: tema_9_period_tema {
    type: number
    sql: ${TABLE}.TEMA_9_period_TEMA ;;
  }

  dimension: ticker {
    type: string
    sql: ${TABLE}.ticker ;;
  }

  dimension: trima_18_period_trima {
    type: number
    sql: ${TABLE}.TRIMA_18_period_TRIMA ;;
  }

  dimension: trix_20_period_trix {
    type: number
    sql: ${TABLE}.TRIX_20_period_TRIX ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  dimension: vama_8_period_vama {
    type: number
    sql: ${TABLE}.VAMA_8_period_VAMA ;;
  }

  dimension: volume {
    type: number
    sql: ${TABLE}.volume ;;
  }

  dimension: vw_macd_macd {
    type: number
    sql: ${TABLE}.VW_MACD_MACD ;;
  }

  dimension: vw_macd_signal {
    type: number
    sql: ${TABLE}.VW_MACD_SIGNAL ;;
  }

  dimension: vwap_vwap_ {
    type: number
    sql: ${TABLE}.VWAP_VWAP_ ;;
  }

  dimension: wma_9_period_wma_ {
    type: number
    sql: ${TABLE}.WMA_9_period_WMA_ ;;
  }

  dimension: zlema_26_period_zlema {
    type: number
    sql: ${TABLE}.ZLEMA_26_period_ZLEMA ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
