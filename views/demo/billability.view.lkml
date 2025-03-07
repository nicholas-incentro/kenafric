view: billability {
  sql_table_name: `ben-sandbox-env.internal.billability` ;;

  dimension: billable_hours {
    type: number
    sql: ${TABLE}.Billable_Hours ;;
  }
  dimension: business_line {
    type: string
    sql: ${TABLE}.Business_Line ;;
  }
  dimension: consultant_id {
    type: string
    sql: ${TABLE}.Consultant_ID ;;
  }
  dimension: consultant_name {
    type: string
    sql: ${TABLE}.Consultant_Name ;;
  }
  dimension: customer_id {
    primary_key: yes
    type: string
    # hidden: yes
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension: hourly_rate {
    type: number
    sql: ${TABLE}.Hourly_Rate ;;
  }
  dimension: hours_worked {
    type: number
    sql: ${TABLE}.Hours_Worked ;;
  }
  dimension: project_id {
    type: string
    sql: ${TABLE}.Project_ID ;;
  }
  dimension_group: timesheet {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Timesheet_Date ;;
  }
  dimension: timesheet_id {
    type: string
    sql: ${TABLE}.Timesheet_ID ;;
  }
  dimension: total_billable_amount {
    type: number
    sql: ${TABLE}.Total_Billable_Amount ;;
  }
  measure: sum_billable_amount {
    type: sum
    sql: ${total_billable_amount} ;;
  }
  measure: sum_hours_worked {
    type: sum
    sql: ${hours_worked} ;;
  }
  measure: count {
    type: count
    drill_fields: [consultant_name, customers.customer_name, customers.customer_id]
  }
}
