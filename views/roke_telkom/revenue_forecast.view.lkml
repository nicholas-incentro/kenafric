view: revenue_forecast {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.revenue_forecast` ;;

  dimension: primary_key {
    primary_key: yes
    type: string
    hidden: yes
    sql: CONCAT(${TABLE}.forecast_month, '-', ${TABLE}.segment) ;;
  }

  dimension: forecast_month {
    type: string
    sql: ${TABLE}.forecast_month ;;
    # order_by_field: forecast_month
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
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

  measure: total_predicted_revenue {
    type: sum
    sql: ${predicted_revenue_ugx_m} ;;
    value_format: "#,##0"
    label: "Total Predicted Revenue (UGX M)"
  }

  measure: avg_confidence {
    type: average
    sql: ${confidence} ;;
    value_format: "0.0%"
  }

  measure: count {
    type: count
  }
}
