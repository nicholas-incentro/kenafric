view: project_status_summary {
  derived_table: {
    sql:
      -- 1. Discovery
      SELECT '1. Discovery' as stage, CAST(Discovey___Defination AS STRING) as status_label
      FROM `still-sensor-360721.datastream.lidl_tracker`
      WHERE Discovey___Defination IS NOT NULL

      UNION ALL

      -- 2. Build
      SELECT '2. Build', CAST(Build AS STRING)
      FROM `still-sensor-360721.datastream.lidl_tracker`
      WHERE Build IS NOT NULL

      UNION ALL

      -- 3. Test
      SELECT '3. Test', CAST(Test AS STRING)
      FROM `still-sensor-360721.datastream.lidl_tracker`
      WHERE Test IS NOT NULL
      ;;
  }

  dimension: stage {
    type: string
    sql: ${TABLE}.stage ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status_label ;;
    # Apply your existing color formatting here
    html: @{status_color_formatting} ;;
  }

  measure: count {
    label: "File Count"
    type: count
  }
}
