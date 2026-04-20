view: revenue_forecast {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.revenue_forecast` ;;

  # ─── Drill Sets (cascading: segment → month → forecast detail) ─
  set: forecast_drill {
    fields: [
      segment,
      forecast_month,
      predicted_revenue_ugx_m,
      lower_bound_ugx_m,
      upper_bound_ugx_m,
      confidence
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
  dimension: primary_key {
    primary_key: yes
    type: string
    hidden: yes
    sql: CONCAT(${TABLE}.forecast_month, '-', ${TABLE}.segment) ;;
  }

  dimension: forecast_month {
    type: string
    sql: ${TABLE}.forecast_month ;;
    link: {
      label: "View {{ value }} forecast breakdown"
      url: "/explore/roke_telkom/revenue_forecast?fields=revenue_forecast.segment,revenue_forecast.predicted_revenue_ugx_m,revenue_forecast.lower_bound_ugx_m,revenue_forecast.upper_bound_ugx_m,revenue_forecast.confidence&f[revenue_forecast.forecast_month]={{ value }}&sorts=revenue_forecast.predicted_revenue_ugx_m+desc"
    }
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
    link: {
      label: "View {{ value }} forecast trend"
      url: "/explore/roke_telkom/revenue_forecast?fields=revenue_forecast.forecast_month,revenue_forecast.predicted_revenue_ugx_m,revenue_forecast.lower_bound_ugx_m,revenue_forecast.upper_bound_ugx_m,revenue_forecast.confidence&f[revenue_forecast.segment]={{ value }}&sorts=revenue_forecast.forecast_month"
    }
  }

  dimension: predicted_revenue_ugx_m {
    type: number
    sql: ${TABLE}.predicted_revenue_ugx_m ;;
    value_format: "#,##0"
    label: "Predicted Revenue (UGX M)"
  }

  dimension: lower_bound_ugx_m {
    type: number
    sql: ${TABLE}.lower_bound_ugx_m ;;
    value_format: "#,##0"
  }

  dimension: upper_bound_ugx_m {
    type: number
    sql: ${TABLE}.upper_bound_ugx_m ;;
    value_format: "#,##0"
  }

  dimension: confidence {
    type: number
    sql: ${TABLE}.confidence ;;
    value_format: "0.0%"
  }

  dimension: model_type {
    type: string
    sql: ${TABLE}.model_type ;;
  }

  # ─── Measures ───────────────────────────────────────────────
  measure: total_predicted_revenue {
    type: sum
    sql: ${predicted_revenue_ugx_m} ;;
    value_format: "#,##0"
    label: "Total Predicted Revenue (UGX M)"
    drill_fields: [forecast_drill*]
  }

  measure: avg_confidence {
    type: average
    sql: ${confidence} ;;
    value_format: "0.0%"
    drill_fields: [segment, forecast_month, confidence, predicted_revenue_ugx_m]
  }

  measure: count {
    type: count
    drill_fields: [forecast_drill*]
  }
}
