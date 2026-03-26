view: churn_predictions {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.churn_predictions` ;;

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension: churn_probability {
    type: number
    sql: ${TABLE}.churn_probability ;;
    value_format: "0.00%"
  }

  dimension: risk_tier {
    type: string
    sql: ${TABLE}.risk_tier ;;
    order_by_field: risk_tier_sort
    html:
      {% if value == 'CRITICAL' %}
        <span style="color: #ea4335; font-weight: bold;">{{ value }}</span>
      {% elsif value == 'HIGH' %}
        <span style="color: #e69138; font-weight: bold;">{{ value }}</span>
      {% elsif value == 'MEDIUM' %}
        <span style="color: #fbbc04;">{{ value }}</span>
      {% else %}
        <span style="color: #34a853;">{{ value }}</span>
      {% endif %} ;;
  }

  dimension: risk_tier_sort {
    type: number
    hidden: yes
    sql: CASE ${risk_tier}
      WHEN 'CRITICAL' THEN 1
      WHEN 'HIGH' THEN 2
      WHEN 'MEDIUM' THEN 3
      WHEN 'LOW' THEN 4
      ELSE 5
    END ;;
  }

  dimension: top_factor {
    type: string
    sql: ${TABLE}.top_factor ;;
    label: "Top Churn Factor"
  }

  dimension: recommended_action {
    type: string
    sql: ${TABLE}.recommended_action ;;
  }

  dimension: model_confidence {
    type: number
    sql: ${TABLE}.model_confidence ;;
    value_format: "0.0%"
  }

  dimension_group: scored {
    type: time
    timeframes: [raw, date]
    datatype: date
    sql: ${TABLE}.scored_date ;;
  }

  dimension: model_version {
    type: string
    sql: ${TABLE}.model_version ;;
  }

  measure: count {
    type: count
    drill_fields: [customers.full_name, segment, churn_probability, risk_tier, top_factor, recommended_action]
  }

  measure: critical_count {
    type: count
    filters: [risk_tier: "CRITICAL"]
  }

  measure: high_count {
    type: count
    filters: [risk_tier: "HIGH"]
  }

  measure: critical_and_high_count {
    type: count
    filters: [risk_tier: "CRITICAL, HIGH"]
    label: "At-Risk Customers"
  }

  measure: avg_churn_probability {
    type: average
    sql: ${churn_probability} ;;
    value_format: "0.00%"
  }

  measure: revenue_at_risk {
    type: sum
    sql: ${customers.monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Monthly Revenue at Risk (UGX)"
    filters: [risk_tier: "CRITICAL, HIGH"]
  }
}
