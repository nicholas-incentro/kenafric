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
  }

  measure: total_fiber_km {
    type: sum
    sql: ${fiber_km} ;;
  }

  measure: count {
    type: count
    drill_fields: [region_name, towers, fiber_km]
  }
}
