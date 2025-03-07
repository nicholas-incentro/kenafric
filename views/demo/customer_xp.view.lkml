view: customer_xp {
  sql_table_name: `ben-sandbox-env.internal.customerXP` ;;

  dimension: adoption_score {
    type: number
    sql: ${TABLE}.Adoption_Score ;;
  }
  dimension: csat_score {
    type: number
    sql: ${TABLE}.CSAT_Score ;;
    drill_fields: [customers.customer_name]
  }
  dimension: customer_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.Customer_ID ;;
  }
  dimension_group: survey {
    type: time
    description: "%E4Y-%m-%d"
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Survey_Date ;;
  }

}
