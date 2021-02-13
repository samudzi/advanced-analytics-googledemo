view: cdnow_clvpred {
  sql_table_name: `advanced-analytics-accelerator.GMP_demo.cdnow_clvpred`
    ;;

  dimension: id {
    type: number
    sql: cast(${TABLE}.cust as INT64) ;;
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

  dimension: churn_risk {

    type: string

    html: {% if value == 'LOW' %}
    <p style="color: white; background-color: darkgreen; font-size:100%; text-align:center">{{ rendered_value }}</font>
    {% elsif value == 'MEDIUM' %}
    <p style="color: white; background-color: goldenrod; font-size:100%; text-align:center">{{ rendered_value }}</font>
    {% else %}
    <p style="color: white; background-color: darkred; font-size:100%; text-align:center">{{ rendered_value }}</font>
    {% endif %} ;;

    case: {
      when: {
        label: "HIGH"
        sql: ${predicted_fut_transactions} <= 1 ;;
      }

      when: {
        label: "MEDIUM"
        sql: ${predicted_fut_transactions} > 1 and ${predicted_fut_transactions} <= 2 ;;
      }

      when: {
        label: "LOW"
        sql: ${predicted_fut_transactions} > 2 ;;
      }
    }

  }

  ### Added measures

  measure: clv_variance {
    sql:(${cdnow.Gross_sales}-${predicted_clv}) / ${cdnow.Gross_sales};;
    type: number
  }

    measure: freq_variance {
    sql:(${cdnow.count}-${predicted_fut_transactions}) / ${cdnow.count};;
    type: number
  }



  measure: average_predicted_clv {
    type: average
    sql: ${predicted_clv} ;;
  }

  measure: average_sum_future_transactions {
    type: average
    sql: ${predicted_fut_transactions} ;;
  }
}
