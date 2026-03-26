view: products {
  sql_table_name: `still-sensor-360721.roke_telkom_dw.products` ;;

  dimension: product_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension: speed_mbps {
    type: number
    label: "Speed (Mbps)"
    sql: ${TABLE}.speed_mbps ;;
  }

  dimension: monthly_ugx {
    type: number
    label: "List Price (UGX)"
    sql: ${TABLE}.monthly_ugx ;;
    value_format: "#,##0"
  }

  dimension: connection_type {
    type: string
    sql: ${TABLE}.connection_type ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name, segment, monthly_ugx]
  }
}
