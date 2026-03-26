view: support_tickets {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.support_tickets` ;;

  dimension: ticket_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: customer_id {
    type: number
    hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: region_id {
    type: number
    hidden: yes
    sql: ${TABLE}.region_id ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
    html:
      {% if value == 'critical' %}
        <span style="color: #ea4335; font-weight: bold;">{{ value }}</span>
      {% elsif value == 'high' %}
        <span style="color: #e69138;">{{ value }}</span>
      {% else %}
        {{ value }}
      {% endif %} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, month, quarter, year]
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: resolution_hours {
    type: number
    sql: ${TABLE}.resolution_hours ;;
    value_format: "0.0"
  }

  dimension: csat_score {
    type: number
    sql: ${TABLE}.csat_score ;;
  }

  measure: count {
    type: count
    drill_fields: [ticket_id, customers.full_name, category, priority, status]
  }

  measure: open_count {
    type: count
    filters: [status: "open"]
  }

  measure: high_priority_count {
    type: count
    filters: [priority: "high, critical"]
  }

  measure: avg_resolution_hours {
    type: average
    sql: CASE WHEN ${resolution_hours} > 0 THEN ${resolution_hours} END ;;
    value_format: "0.0"
    label: "Avg Resolution (hrs)"
  }

  measure: avg_csat {
    type: average
    sql: ${csat_score} ;;
    value_format: "0.00"
    label: "Avg CSAT"
  }

  measure: detractor_count {
    type: count
    filters: [csat_score: "1, 2"]
    label: "Detractors (CSAT 1-2)"
  }
}
