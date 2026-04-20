view: churn_predictions {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.churn_predictions` ;;

  # ─── Drill Sets (cascading: risk → segment → customer → action) ─
  set: churn_risk_drill {
    fields: [
      risk_tier,
      segment,
      customers.full_name,
      churn_probability,
      customers.monthly_fee_ugx,
      top_factor,
      recommended_action
    ]
  }

  set: revenue_risk_drill {
    fields: [
      segment,
      risk_tier,
      customers.full_name,
      customers.monthly_fee_ugx,
      churn_probability,
      recommended_action
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
    link: {
      label: "View {{ value }} churn detail"
      url: "/explore/roke_telkom/churn_predictions?fields=churn_predictions.risk_tier,customers.full_name,churn_predictions.churn_probability,customers.monthly_fee_ugx,churn_predictions.top_factor,churn_predictions.recommended_action&f[churn_predictions.segment]={{ value }}&sorts=churn_predictions.churn_probability+desc"
    }
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
    link: {
      label: "View all {{ value }} risk customers"
      url: "/explore/roke_telkom/churn_predictions?fields=churn_predictions.segment,customers.full_name,churn_predictions.churn_probability,customers.monthly_fee_ugx,churn_predictions.top_factor,churn_predictions.recommended_action&f[churn_predictions.risk_tier]={{ value }}&sorts=churn_predictions.churn_probability+desc"
    }
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

  # ─── Measures ───────────────────────────────────────────────
  measure: count {
    type: count
    drill_fields: [churn_risk_drill*]
  }

  measure: critical_count {
    type: count
    filters: [risk_tier: "CRITICAL"]
    drill_fields: [segment, customers.full_name, churn_probability, customers.monthly_fee_ugx, top_factor, recommended_action]
  }

  measure: high_count {
    type: count
    filters: [risk_tier: "HIGH"]
    drill_fields: [segment, customers.full_name, churn_probability, customers.monthly_fee_ugx, top_factor, recommended_action]
  }

  measure: critical_and_high_count {
    type: count
    filters: [risk_tier: "CRITICAL, HIGH"]
    label: "At-Risk Customers"
    drill_fields: [churn_risk_drill*]
  }

  measure: avg_churn_probability {
    type: average
    sql: ${churn_probability} ;;
    value_format: "0.00%"
    drill_fields: [segment, risk_tier, customers.full_name, churn_probability, customers.monthly_fee_ugx]
  }

  measure: revenue_at_risk {
    type: sum
    sql: ${customers.monthly_fee_ugx} ;;
    value_format: "#,##0"
    label: "Monthly Revenue at Risk (UGX)"
    filters: [risk_tier: "CRITICAL, HIGH"]
    drill_fields: [revenue_risk_drill*]
  }
}
