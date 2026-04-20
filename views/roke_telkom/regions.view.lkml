view: regions {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.regions` ;;

  dimension: region_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.region_id ;;
  }

  dimension: region_name {
    type: string
    sql: ${TABLE}.region_name ;;
    link: {
      label: "Revenue for {{ value }}"
      url: "/explore/roke_telkom/billing_transactions?fields=products.segment,billing_transactions.billing_month,billing_transactions.total_revenue&f[regions.region_name]={{ value }}&pivots=products.segment&sorts=billing_transactions.billing_month"
    }
    link: {
      label: "Customers in {{ value }}"
      url: "/explore/roke_telkom/customers?fields=customers.full_name,customers.segment,products.product_name,customers.monthly_fee_ugx,customers.status&f[regions.region_name]={{ value }}&sorts=customers.monthly_fee_ugx+desc"
    }
    link: {
      label: "Network health for {{ value }}"
      url: "/explore/roke_telkom/network_telemetry?fields=network_telemetry.timestamp_hour_of_day,network_telemetry.avg_bandwidth,network_telemetry.avg_latency,network_telemetry.avg_uptime&f[regions.region_name]={{ value }}"
    }
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    hidden: yes
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    hidden: yes
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: towers {
    type: number
    sql: ${TABLE}.towers ;;
  }

  dimension: fiber_km {
    type: number
    label: "Fiber KM"
    sql: ${TABLE}.fiber_km ;;
  }

  measure: total_towers {
    type: sum
    sql: ${towers} ;;
    drill_fields: [region_name, towers, fiber_km]
  }

  measure: total_fiber_km {
    type: sum
    sql: ${fiber_km} ;;
    drill_fields: [region_name, fiber_km, towers]
  }

  measure: count {
    type: count
    drill_fields: [region_name, towers, fiber_km]
  }
}
