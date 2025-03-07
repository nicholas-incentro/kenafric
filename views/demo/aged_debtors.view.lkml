view: aged_debtors {
  sql_table_name: `ben-sandbox-env.internal.aged_debtors` ;;

  dimension: aging_bucket {
    type: string
    sql: ${TABLE}.aging_bucket ;;
  }
  dimension: amount_owed {
    type: number
    sql: ${TABLE}.amount_owed ;;
  }
  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_id ;;
  }
  dimension: days_overdue {
    type: number
    sql: ${TABLE}.days_overdue ;;
  }
  dimension_group: due {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.due_date ;;
  }
  dimension_group: invoice {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.invoice_date ;;
  }
  measure: total_amount_owed {
    type: sum
    sql: ${amount_owed} ;;
  }
  measure: total_days_overdue {
    type: sum
    sql: ${days_overdue} ;;
  }
}
