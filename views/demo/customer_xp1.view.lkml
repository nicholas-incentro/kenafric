view: customer_xp1 {
  sql_table_name: `ben-sandbox-env.internal.customer_xp` ;;

  dimension: adoption_score {
    type: number
    sql: ${TABLE}.Adoption_Score ;;
  }
  dimension: csat_score {
    type: number
    sql: ${TABLE}.CSAT_Score ;;
  }
  dimension: customer_id {
    primary_key: yes
    type: string
    # hidden: yes
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension: psat_score {
    type: number
    sql: ${TABLE}.PSAT_Score ;;
  }
  dimension_group: survey {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Survey_Date ;;
  }
  measure: count {
    type: count
    drill_fields: [customers.customer_name, customers.customer_id]
  }
}
