view: account_invoice {
  sql_table_name: `ben-sandbox-env.internal.account_invoice` ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.Amount ;;
    drill_fields: [detail*]
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
  dimension: deductions {
    type: number
    sql: ${TABLE}.Deductions ;;
  }
  dimension_group: invoice {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Invoice_Date ;;
    drill_fields:[detail*]
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
    # hidden: yes
    sql: ${TABLE}.Subscription_ID ;;
  }

  dimension: sale_price {
    type: number
    sql: ${amount}- ${deductions} ;;
    hidden: yes
  }
  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    hidden: yes
  }
  measure: sum_mrr {
    type: sum
    sql: ${TABLE}.MRR ;;
  }
  measure: total_deductions {
    type: sum
    sql: ${cost} + ${deductions} ;;
    hidden: yes
  }
  measure: gross_revenue {
    label: "Gross Revenue"
    type: sum
    sql: ${TABLE}.Amount;;
    value_format_name: decimal_2
    drill_fields: [detail*, gross_revenue]
  }
  measure: sum_sale_price {
    label: "Net Revenue"
    type: sum
    sql: ${sale_price};;
    value_format_name: decimal_2
    drill_fields: [detail*, sum_sale_price]
  }
  measure: gross_margin {
    type: number
    sql: ${gross_revenue} - ${total_cost} ;;
    hidden: yes
    drill_fields: [products.product_name, customers.customer_name]
  }
  measure: percent_gross_margin {
    label: "%Gross Margin"
    type: number
    sql: ${gross_margin}/${sum_sale_price} ;;
    value_format_name: percent_2
    drill_fields: [detail*, percent_gross_margin]
  }
  measure: net_margin {
    type: number
    sql: ${gross_revenue} - ${total_deductions} ;;
    hidden: no
    drill_fields: [detail*]
  }
  measure: percent_net_margin {
    label: "%Net Margin"
    type: number
    sql: ${net_margin}/${sum_sale_price}  ;;
    value_format_name: percent_2
    drill_fields: [detail*, percent_net_margin]
  }
  measure: arr {
    type: number
    sql: ${sum_mrr}*12 ;;
    value_format_name: decimal_2
    drill_fields: [products.business_line, detail*, arr]
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  set: detail {
    fields: [
      products.product_name, customers.customer_name
    ]
  }
}
