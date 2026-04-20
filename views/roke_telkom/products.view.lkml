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
    link: {
      label: "Customers on {{ value }}"
      url: "/explore/roke_telkom/customers?fields=customers.full_name,customers.segment,customers.monthly_fee_ugx,customers.status,regions.region_name&f[products.product_name]={{ value }}&sorts=customers.monthly_fee_ugx+desc"
    }
    link: {
      label: "Revenue for {{ value }}"
      url: "/explore/roke_telkom/billing_transactions?fields=billing_transactions.billing_month,billing_transactions.total_revenue,billing_transactions.unique_customers,billing_transactions.arpu&f[products.product_name]={{ value }}&sorts=billing_transactions.billing_month"
    }
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
    link: {
      label: "View all {{ value }} products"
      url: "/explore/roke_telkom/billing_transactions?fields=products.product_name,billing_transactions.total_revenue,billing_transactions.unique_customers,billing_transactions.arpu&f[products.segment]={{ value }}&sorts=billing_transactions.total_revenue+desc"
    }
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
    drill_fields: [product_name, segment, speed_mbps, monthly_ugx, connection_type]
  }
}
