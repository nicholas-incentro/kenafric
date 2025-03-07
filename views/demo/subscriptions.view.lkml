view: subscriptions {
  sql_table_name: `ben-sandbox-env.internal.subscriptions` ;;
  drill_fields: [subscription_id]

  dimension: subscription_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.Subscription_ID ;;
  }
  dimension: change_type {
    type: string
    sql: ${TABLE}.Change_Type ;;
  }
  dimension: change_value {
    type: number
    sql: ${TABLE}.Change_Value ;;
  }
  dimension: customer_id {
    type: string
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension_group: effective {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Effective_Date ;;
  }

  measure: min_effective_date {
    type: date
    sql: MIN(${effective_date}) ;;
    convert_tz: no
  }
  measure: amount {
    type: sum
    sql: ${change_value} ;;
    value_format_name: decimal_2
    drill_fields: [subscription_id]
  }
}
