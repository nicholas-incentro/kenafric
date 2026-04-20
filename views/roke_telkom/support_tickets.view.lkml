view: support_tickets {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.support_tickets` ;;

  # ─── Drill Sets (cascading: category → priority → customer → detail) ─
  set: ticket_drill {
    fields: [
      ticket_id,
      category,
      priority,
      customers.full_name,
      regions.region_name,
      status,
      created_date,
      resolution_hours,
      csat_score
    ]
  }

  set: satisfaction_drill {
    fields: [
      regions.region_name,
      category,
      customers.full_name,
      csat_score,
      priority,
      resolution_hours,
      status
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
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
    link: {
      label: "View {{ value }} tickets"
      url: "/explore/roke_telkom/support_tickets?fields=support_tickets.ticket_id,customers.full_name,support_tickets.priority,support_tickets.status,support_tickets.resolution_hours,support_tickets.csat_score&f[support_tickets.category]={{ value }}&sorts=support_tickets.created_date+desc"
    }
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

  # ─── Measures ───────────────────────────────────────────────
  measure: count {
    type: count
    drill_fields: [ticket_drill*]
  }

  measure: open_count {
    type: count
    filters: [status: "open"]
    drill_fields: [category, priority, customers.full_name, regions.region_name, created_date, resolution_hours]
  }

  measure: high_priority_count {
    type: count
    filters: [priority: "high, critical"]
    drill_fields: [priority, category, customers.full_name, regions.region_name, status, created_date, csat_score]
  }

  measure: avg_resolution_hours {
    type: average
    sql: CASE WHEN ${resolution_hours} > 0 THEN ${resolution_hours} END ;;
    value_format: "0.0"
    label: "Avg Resolution (hrs)"
    drill_fields: [category, priority, customers.full_name, resolution_hours, csat_score]
  }

  measure: avg_csat {
    type: average
    sql: ${csat_score} ;;
    value_format: "0.00"
    label: "Avg CSAT"
    drill_fields: [satisfaction_drill*]
  }

  measure: detractor_count {
    type: count
    filters: [csat_score: "1, 2"]
    label: "Detractors (CSAT 1-2)"
    drill_fields: [customers.full_name, category, priority, csat_score, regions.region_name, created_date]
  }
}
