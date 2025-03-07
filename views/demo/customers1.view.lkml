view: customers1 {
  sql_table_name: `ben-sandbox-env.internal.customers` ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension_group: create {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Create_Date ;;
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
    type: count
    drill_fields: [customer_id, customer_name, customer_xp.count, account_invoice.count]
  }
}
