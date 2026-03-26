view: customers {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.customers` ;;

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: account_no {
    type: string
    sql: ${TABLE}.account_no ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: customer_type {
    type: string
    sql: ${TABLE}.customer_type ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: region_id {
    type: number
    hidden: yes
    sql: ${TABLE}.region_id ;;
  }

  dimension_group: signup {
    type: time
    timeframes: [raw, date, month, quarter, year]
    datatype: date
    sql: ${TABLE}.signup_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html:
      {% if value == 'active' %}
        <span style="color: #34a853;">{{ value }}</span>
      {% elsif value == 'churned' %}
        <span style="color: #ea4335;">{{ value }}</span>
      {% else %}
        <span style="color: #fbbc04;">{{ value }}</span>
      {% endif %} ;;
  }

  dimension: monthly_fee_ugx {
    type: number
    label: "Monthly Fee (UGX)"
    sql: ${TABLE}.monthly_fee_ugx ;;
    value_format: "#,##0"
  }

  measure: count {
    type: count
    drill_fields: [customer_id, full_name, segment, status, monthly_fee_ugx]
  }

  measure: active_count {
    type: count
    filters: [status: "active"]
  }

  measure: churned_count {
    type: count
    filters: [status: "churned"]
  }

  measure: total_monthly_fees {
    type: sum
    sql: ${monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Total Monthly Fees (UGX)"
  }

  measure: avg_monthly_fee {
    type: average
    sql: ${monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Avg Monthly Fee (UGX)"
  }

  measure: churn_rate {
    type: number
    sql: 1.0 * ${churned_count} / NULLIF(${count}, 0) ;;
    value_format: "0.0%"
  }
}
