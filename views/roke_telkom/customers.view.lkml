view: customers {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.customers` ;;

  # ─── Drill Sets (cascading: segment → customer → detail) ───
  set: customer_drill {
    fields: [
      segment,
      full_name,
      products.product_name,
      monthly_fee_ugx,
      status,
      regions.region_name
    ]
  }

  set: churn_drill {
    fields: [
      segment,
      full_name,
      status,
      monthly_fee_ugx,
      signup_date,
      regions.region_name
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
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
    link: {
      label: "Customer 360° View"
      url: "/explore/roke_telkom/customers?fields=customers.full_name,customers.segment,products.product_name,customers.monthly_fee_ugx,customers.status,churn_predictions.risk_tier,churn_predictions.churn_probability,churn_predictions.recommended_action&f[customers.full_name]={{ value }}"
    }
  }

  dimension: customer_type {
    type: string
    sql: ${TABLE}.customer_type ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
    link: {
      label: "View all {{ value }} customers"
      url: "/explore/roke_telkom/customers?fields=customers.full_name,products.product_name,customers.monthly_fee_ugx,customers.status&f[customers.segment]={{ value }}"
    }
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

  # ─── Measures ───────────────────────────────────────────────
  measure: count {
    type: count
    drill_fields: [customer_drill*]
  }

  measure: active_count {
    type: count
    filters: [status: "active"]
    drill_fields: [customer_drill*]
  }

  measure: churned_count {
    type: count
    filters: [status: "churned"]
    drill_fields: [churn_drill*]
  }

  measure: total_monthly_fees {
    type: sum
    sql: ${monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Total Monthly Fees (UGX)"
    drill_fields: [segment, full_name, products.product_name, monthly_fee_ugx]
  }

  measure: avg_monthly_fee {
    type: average
    sql: ${monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Avg Monthly Fee (UGX)"
    drill_fields: [segment, full_name, products.product_name, monthly_fee_ugx]
  }

  measure: churn_rate {
    type: number
    sql: 1.0 * ${churned_count} / NULLIF(${count}, 0) ;;
    value_format: "0.0%"
    drill_fields: [segment, full_name, status, monthly_fee_ugx, products.product_name]
  }
}
