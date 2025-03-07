view: bs_line_arr {
  sql_table_name: `ben-sandbox-env.internal.bs_line_arr` ;;

  dimension: arr {
    type: number
    sql: ${TABLE}.ARR ;;
  }
  dimension: business_line {
    type: string
    sql: ${TABLE}.`Business Line` ;;
  }
  dimension: churn_amount {
    type: number
    sql: ${TABLE}.`Churn Amount` ;;
  }
  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Date ;;
  }
  dimension: gross_revenue {
    type: number
    sql: ${TABLE}.`Gross Revenue` ;;
  }
  dimension: lost_customers {
    type: number
    sql: ${TABLE}.`Lost Customers` ;;
  }
  dimension: net_revenue {
    type: number
    sql: ${TABLE}.`Net Revenue` ;;
  }
  dimension: new_customers {
    type: number
    sql: ${TABLE}.`New Customers` ;;
  }
  measure: count {
    type: count
  }
}
