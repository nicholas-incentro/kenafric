view: network_telemetry {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.network_telemetry` ;;

  dimension: telemetry_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.telemetry_id ;;
  }

  dimension: region_id {
    type: number
    hidden: yes
    sql: ${TABLE}.region_id ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, month]
    datatype: timestamp
    sql: ${TABLE}.timestamp_hour ;;
  }

  dimension: bandwidth_util_pct {
    type: number
    sql: ${TABLE}.bandwidth_util_pct ;;
    label: "Bandwidth %"
  }

  dimension: latency_ms {
    type: number
    sql: ${TABLE}.latency_ms ;;
    label: "Latency (ms)"
  }

  dimension: fibre_ring_util_pct {
    type: number
    sql: ${TABLE}.fibre_ring_util_pct ;;
    label: "Fiber Ring %"
  }

  dimension: packet_loss_pct {
    type: number
    sql: ${TABLE}.packet_loss_pct ;;
    value_format: "0.000"
    label: "Packet Loss %"
  }

  dimension: uptime_pct {
    type: number
    sql: ${TABLE}.uptime_pct ;;
    value_format: "0.00"
    label: "Uptime %"
  }

  dimension: active_sessions {
    type: number
    sql: ${TABLE}.active_sessions ;;
  }

  dimension: capacity_status {
    type: string
    sql: CASE
      WHEN ${bandwidth_util_pct} > 85 AND ${latency_ms} > 30 THEN 'CAPACITY_WARNING'
      WHEN ${bandwidth_util_pct} > 70 THEN 'ELEVATED'
      ELSE 'NORMAL'
    END ;;
    html:
      {% if value == 'CAPACITY_WARNING' %}
        <span style="color: #ea4335; font-weight: bold;">{{ value }}</span>
      {% elsif value == 'ELEVATED' %}
        <span style="color: #fbbc04;">{{ value }}</span>
      {% else %}
        <span style="color: #34a853;">{{ value }}</span>
      {% endif %} ;;
  }

  measure: avg_bandwidth {
    type: average
    sql: ${bandwidth_util_pct} ;;
    value_format: "0.0"
    label: "Avg Bandwidth %"
  }

  measure: max_bandwidth {
    type: max
    sql: ${bandwidth_util_pct} ;;
    label: "Peak Bandwidth %"
  }

  measure: avg_latency {
    type: average
    sql: ${latency_ms} ;;
    value_format: "0.0"
    label: "Avg Latency (ms)"
  }

  measure: avg_uptime {
    type: average
    sql: ${uptime_pct} ;;
    value_format: "0.00"
    label: "Avg Uptime %"
  }

  measure: avg_packet_loss {
    type: average
    sql: ${packet_loss_pct} ;;
    value_format: "0.000"
    label: "Avg Packet Loss %"
  }

  measure: avg_sessions {
    type: average
    sql: ${active_sessions} ;;
    value_format: "#,##0"
    label: "Avg Active Sessions"
  }

  measure: count {
    type: count
  }
}
