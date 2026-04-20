view: billing_transactions {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.billing_transactions` ;;

  # ─── Drill Sets (cascading: broad → narrow) ─────────────────
  set: revenue_drill {
    fields: [
      products.segment,
      products.product_name,
      regions.region_name,
      customers.full_name,
      billing_month,
      total_revenue
    ]
  }

  set: transaction_drill {
    fields: [
      tx_id,
      customers.full_name,
      products.product_name,
      billing_month,
      amount_ugx,
      payment_status,
      payment_method
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
  dimension: tx_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.tx_id ;;
  }

  dimension: customer_id {
    type: number
    hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: billing_month {
    type: string
    label: "Billing Month"
    sql: ${TABLE}.billing_month ;;
    link: {
      label: "Drill into this month"
      url: "/explore/roke_telkom/billing_transactions?fields=products.segment,billing_transactions.total_revenue&f[billing_transactions.billing_month]={{ value }}"
    }
  }

  dimension_group: billing {
    type: time
    timeframes: [raw, date, quarter, year]
    datatype: date
    sql: ${TABLE}.billing_date ;;
  }

  dimension: amount_ugx {
    type: number
    sql: ${TABLE}.amount_ugx ;;
    value_format: "#,##0"
    hidden: yes
  }

  dimension: payment_status {
    type: string
    sql: ${TABLE}.payment_status ;;
    html:
      {% if value == 'paid' %}
        <span style="color: #34a853;">{{ value }}</span>
      {% elsif value == 'overdue' %}
        <span style="color: #ea4335;">{{ value }}</span>
      {% else %}
        <span style="color: #fbbc04;">{{ value }}</span>
      {% endif %} ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  # ─── Measures ───────────────────────────────────────────────
  measure: total_revenue {
    type: sum
    sql: ${amount_ugx} ;;
    value_format: "#,##0"
    label: "Total Revenue (UGX)"
    drill_fields: [revenue_drill*]
  }

  measure: total_revenue_billions {
    type: sum
    sql: ${amount_ugx} / 1000000000.0 ;;
    value_format: "0.00\"B\""
    label: "Revenue (UGX B)"
    drill_fields: [revenue_drill*]
  }

  measure: avg_transaction {
    type: average
    sql: ${amount_ugx} ;;
    value_format: "#,##0"
    label: "Avg Transaction (UGX)"
    drill_fields: [customers.full_name, products.product_name, billing_month, amount_ugx, payment_status]
  }

  measure: transaction_count {
    type: count
    drill_fields: [transaction_drill*]
  }

  measure: unique_customers {
    type: count_distinct
    sql: ${customer_id} ;;
    label: "Paying Customers"
    drill_fields: [customers.segment, customers.full_name, products.product_name, customers.monthly_fee_ugx]
  }

  measure: arpu {
    type: number
    sql: ${total_revenue} / NULLIF(${unique_customers}, 0) ;;
    value_format: "#,##0"
    label: "ARPU (UGX)"
    drill_fields: [products.segment, regions.region_name, unique_customers, total_revenue]
  }

  measure: overdue_count {
    type: count
    filters: [payment_status: "overdue"]
    label: "Overdue Transactions"
    drill_fields: [customers.full_name, products.product_name, billing_month, amount_ugx, payment_method]
  }

  measure: overdue_rate {
    type: number
    sql: 1.0 * ${overdue_count} / NULLIF(${transaction_count}, 0) ;;
    value_format: "0.0%"
    drill_fields: [products.segment, billing_month, overdue_count, transaction_count]
  }
}
