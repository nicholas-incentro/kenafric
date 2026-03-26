view: billing_transactions {

  sql_table_name: `still-sensor-360721.roke_telkom_dw.billing_transactions` ;;

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

  measure: total_revenue {
    type: sum
    sql: ${amount_ugx} ;;
    value_format: "#,##0"
    label: "Total Revenue (UGX)"
    drill_fields: [customers.full_name, products.product_name, billing_month, total_revenue]
  }

  measure: total_revenue_billions {
    type: sum
    sql: ${amount_ugx} / 1000000000.0 ;;
    value_format: "0.00\"B\""
    label: "Revenue (UGX B)"
  }

  measure: avg_transaction {
    type: average
    sql: ${amount_ugx} ;;
    value_format: "#,##0"
    label: "Avg Transaction (UGX)"
  }

  measure: transaction_count {
    type: count
    drill_fields: [tx_id, customers.full_name, billing_month, amount_ugx, payment_status]
  }

  measure: unique_customers {
    type: count_distinct
    sql: ${customer_id} ;;
    label: "Paying Customers"
  }

  measure: arpu {
    type: number
    sql: ${total_revenue} / NULLIF(${unique_customers}, 0) ;;
    value_format: "#,##0"
    label: "ARPU (UGX)"
  }

  measure: overdue_count {
    type: count
    filters: [payment_status: "overdue"]
    label: "Overdue Transactions"
  }

  measure: overdue_rate {
    type: number
    sql: 1.0 * ${overdue_count} / NULLIF(${transaction_count}, 0) ;;
    value_format: "0.0%"
  }
}
