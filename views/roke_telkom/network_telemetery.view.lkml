view: network_telemetry {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.network_telemetry` ;;

  # ─── Drill Sets (cascading: region → date → hour → metrics) ─
  set: network_drill {
    fields: [
      regions.region_name,
      timestamp_date,
      timestamp_hour_of_day,
      bandwidth_util_pct,
      latency_ms,
      uptime_pct,
      capacity_status
    ]
  }

  set: capacity_drill {
    fields: [
      regions.region_name,
      timestamp_date,
      timestamp_hour_of_day,
      bandwidth_util_pct,
      fibre_ring_util_pct,
      latency_ms,
      active_sessions,
      capacity_status
    ]
  }

  # ─── Dimensions ─────────────────────────────────────────────
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
    link: {
      label: "View {{ value }} readings"
      url: "/explore/roke_telkom/network_telemetry?fields=regions.region_name,network_telemetry.timestamp_date,network_telemetry.timestamp_hour_of_day,network_telemetry.bandwidth_util_pct,network_telemetry.latency_ms&f[network_telemetry.capacity_status]={{ value }}&sorts=network_telemetry.bandwidth_util_pct+desc"
    }
  }

  # ─── Measures ───────────────────────────────────────────────
  measure: avg_bandwidth {
    type: average
    sql: ${bandwidth_util_pct} ;;
    value_format: "0.0"
    label: "Avg Bandwidth %"
    drill_fields: [regions.region_name, timestamp_date, timestamp_hour_of_day, avg_bandwidth, max_bandwidth, capacity_status]
  }

  measure: max_bandwidth {
    type: max
    sql: ${bandwidth_util_pct} ;;
    label: "Peak Bandwidth %"
    drill_fields: [capacity_drill*]
  }

  measure: avg_latency {
    type: average
    sql: ${latency_ms} ;;
    value_format: "0.0"
    label: "Avg Latency (ms)"
    drill_fields: [regions.region_name, timestamp_date, timestamp_hour_of_day, latency_ms, bandwidth_util_pct, capacity_status]
  }

  measure: avg_uptime {
    type: average
    sql: ${uptime_pct} ;;
    value_format: "0.00"
    label: "Avg Uptime %"
    drill_fields: [regions.region_name, timestamp_date, uptime_pct, bandwidth_util_pct, latency_ms]
  }

  measure: avg_packet_loss {
    type: average
    sql: ${packet_loss_pct} ;;
    value_format: "0.000"
    label: "Avg Packet Loss %"
    drill_fields: [regions.region_name, timestamp_date, packet_loss_pct, bandwidth_util_pct, latency_ms]
  }

  measure: avg_sessions {
    type: average
    sql: ${active_sessions} ;;
    value_format: "#,##0"
    label: "Avg Active Sessions"
    drill_fields: [regions.region_name, timestamp_hour_of_day, active_sessions, bandwidth_util_pct]
  }

  measure: count {
    type: count
    drill_fields: [network_drill*]
  }
}
