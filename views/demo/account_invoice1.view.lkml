view: account_invoice1 {
  sql_table_name: `ben-sandbox-env.internal.account_invoice` ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.Amount ;;
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.Cost ;;
  }
  dimension: customer_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension_group: invoice {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Invoice_Date ;;
  }
  dimension: invoice_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Invoice_ID ;;
  }
  dimension: invoice_type {
    type: string
    sql: ${TABLE}.Invoice_Type ;;
  }
  dimension: mrr {
    type: number
    sql: ${TABLE}.MRR ;;
  }
  dimension: product_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.Product_ID ;;
  }
  dimension: subscription_id {
    type: string
    sql: ${TABLE}.Subscription_ID ;;
  }
  measure: gross_revenue {
    type: sum
    sql: ${TABLE}.Amount;;
    value_format_name: decimal_2
    drill_fields: [products.product_id, products.product_name, customers.customer_name, customers.customer_id]
  }
  measure: percent_net_margin {
    type: number
    sql: ((${amount} - ${cost})/${amount})*100  ;;
    value_format_name: percent_2
  }
  measure: arr {
    type: sum
    sql: ${mrr}*12 ;;
    value_format_name: decimal_2
    drill_fields: [products.product_id, products.product_name, customers.customer_name, customers.customer_id]
  }
  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: decimal_2
  }
  dimension: net_rev {
    type: number
    sql: ${amount}-${cost} ;;
  }
  measure: net_revenue {
    type: sum
    sql: ${net_rev} ;;
    value_format_name: decimal_2
  }
  measure: count {
    type: count
    drill_fields: [products.product_id, products.product_name, customers.customer_name, customers.customer_id]
  }
}
