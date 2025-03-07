view: cash_management {
  sql_table_name: `ben-sandbox-env.internal.cash_management` ;;

  dimension: amount_usd {
    type: number
    sql: ${TABLE}.amount_USD_ ;;
  }
  dimension: balance_usd {
    type: number
    sql: ${TABLE}.Balance__USD_ ;;
  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension_group: create {
    type: time
    description: "%d/%m/%E4Y"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.create_date ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }
  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }
  measure: amount {
    type: sum
    sql:  amount_USD_;;
  }
  measure: balance {
    type: sum
    sql:  Balance__USD_;;
  }
}
