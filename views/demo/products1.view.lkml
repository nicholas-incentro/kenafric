view: products1 {
  sql_table_name: `ben-sandbox-env.internal.products` ;;
  drill_fields: [product_id]

  dimension: product_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Product_ID ;;
  }
  dimension: business_line {
    type: string
    sql: ${TABLE}.Business_Line ;;
  }
  dimension: product_name {
    type: string
    sql: ${TABLE}.Product_Name ;;
  }
  measure: count {
    type: count
    drill_fields: [product_id, product_name, account_invoice.count]
  }
}
