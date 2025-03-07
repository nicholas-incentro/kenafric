view: customer_data {
  sql_table_name: `ben-sandbox-env.internal.customer_data` ;;

  dimension: adoption_score {
    type: number
    sql: ${TABLE}.adoption_score ;;
  }
  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }
  dimension: company_size {
    type: string
    sql: ${TABLE}.company_size ;;
  }
  dimension: csat {
    label: "CSAT"
    type: number
    sql: ${TABLE}.CSAT ;;
  }
  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_id ;;
  }
  dimension: lifecycle_stage {
    type: string
    sql: ${TABLE}.lifecycle_stage ;;
  }
  dimension: psat {
    label: "PSAT"
    type: number
    sql: ${TABLE}.PSAT ;;
  }
  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }
  dimension: tenure_months_ {
    type: number
    sql: ${TABLE}.tenure_months_ ;;
  }
  dimension: vertical {
    type: string
    sql: ${TABLE}.vertical ;;
  }
  measure: count {
    type: count
  }
}
