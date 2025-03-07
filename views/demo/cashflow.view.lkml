view: cashflow {
  sql_table_name: `ben-sandbox-env.internal.cashflow` ;;

  dimension: amount {
    type: number
    sql: ${TABLE}.Amount ;;
  }
  dimension: category {
    type: string
    sql: ${TABLE}.Category ;;
  }
  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }
  dimension_group: transaction {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Transaction_Date ;;
  }
  dimension: transaction_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Transaction_ID ;;
  }
  dimension: transaction_type {
    type: string
    sql: ${TABLE}.Transaction_Type ;;
  }
  measure: count {
    type: count
  }
}
