view: company_performance {
  sql_table_name: `ben-sandbox-env.internal.company_performance` ;;

  dimension: aged_debtors {
    type: number
    sql: ${TABLE}.aged_debtors ;;
  }
  dimension: business_line_arr {
    type: number
    sql: ${TABLE}.business_line_arr ;;
  }
  dimension: cash_flow_usd {
    type: number
    sql: ${TABLE}.cash_flow_usd ;;
  }
  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
  }
  dimension: month {
    type: date
    sql: PARSE_DATE('%Y-%m',${TABLE}.Month) ;;
  }
  dimension: net_margin {
    type: number
    sql: ${TABLE}.net_margin ;;
  }
  dimension: psat {
    label: "PSAT(1-5)"
    type: number
    sql: ${TABLE}.PSAT ;;
  }
  measure: count {
    type: count
  }
}
