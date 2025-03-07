view: customers {
  sql_table_name: `ben-sandbox-env.internal.customers` ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension: company_size {
    type: string
    sql: ${TABLE}.Company_Size ;;
  }
  dimension: company_vertical {
    type: string
    sql: ${TABLE}.Company_Vertical ;;
  }
  dimension_group: create {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Create_Date ;;
    drill_fields: [detail*]
  }
  dimension: customer_name {
    type: string
    sql: ${TABLE}.Customer_Name ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }
  measure: count {
    type: count_distinct
    sql: ${customer_id} ;;
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  customer_id,
  customer_name,
  account_invoice.count,
  billability.count,
  subscriptions.count,
  customer_xp.count
  ]
  }

}
