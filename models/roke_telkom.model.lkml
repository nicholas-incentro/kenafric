connection: "@{CONNECTION}"

include: "/views/roke_telkom/*.view.lkml"
include: "/dashboards/roke_telkom_executive.dashboard.lookml"

datagroup: roke_telkom_default_datagroup {
  max_cache_age: "1 hour"
}

persist_with: roke_telkom_default_datagroup

# ─── EXPLORES ────────────────────────────────────────────────

explore: billing_transactions {
  label: "Revenue & Billing"
  description: "Billing transactions joined to products, customers, and regions"

  join: products {
    type: left_outer
    sql_on: ${billing_transactions.product_id} = ${products.product_id} ;;
    relationship: many_to_one
  }

  join: customers {
    type: left_outer
    sql_on: ${billing_transactions.customer_id} = ${customers.customer_id} ;;
    relationship: many_to_one
  }

  join: regions {
    type: left_outer
    sql_on: ${customers.region_id} = ${regions.region_id} ;;
    relationship: many_to_one
  }

  join: churn_predictions {
    type: left_outer
    sql_on: ${customers.customer_id} = ${churn_predictions.customer_id} ;;
    relationship: one_to_one
  }
}

explore: customers {
  label: "Customer 360"
  description: "Customer master with product, region, billing, support, and churn data"

  join: products {
    type: left_outer
    sql_on: ${customers.product_id} = ${products.product_id} ;;
    relationship: many_to_one
  }

  join: regions {
    type: left_outer
    sql_on: ${customers.region_id} = ${regions.region_id} ;;
    relationship: many_to_one
  }

  join: churn_predictions {
    type: left_outer
    sql_on: ${customers.customer_id} = ${churn_predictions.customer_id} ;;
    relationship: one_to_one
  }

  join: support_tickets {
    type: left_outer
    sql_on: ${customers.customer_id} = ${support_tickets.customer_id} ;;
    relationship: one_to_many
  }
}

explore: network_telemetry {
  label: "Network Operations"
  description: "Hourly telemetry from metro fiber rings across 8 regions"

  join: regions {
    type: left_outer
    sql_on: ${network_telemetry.region_id} = ${regions.region_id} ;;
    relationship: many_to_one
  }
}

explore: churn_predictions {
  label: "Churn Risk"
  description: "ML-scored churn predictions for active customers"

  join: customers {
    type: left_outer
    sql_on: ${churn_predictions.customer_id} = ${customers.customer_id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${customers.product_id} = ${products.product_id} ;;
    relationship: many_to_one
  }

  join: regions {
    type: left_outer
    sql_on: ${customers.region_id} = ${regions.region_id} ;;
    relationship: many_to_one
  }
}

explore: revenue_forecast {
  label: "Revenue Forecast"
  description: "BQML ARIMA_PLUS 9-month revenue forecast by segment"
}

explore: support_tickets {
  label: "Support Tickets"
  description: "Customer support with resolution times and CSAT"

  join: customers {
    type: left_outer
    sql_on: ${support_tickets.customer_id} = ${customers.customer_id} ;;
    relationship: many_to_one
  }

  join: regions {
    type: left_outer
    sql_on: ${support_tickets.region_id} = ${regions.region_id} ;;
    relationship: many_to_one
  }
}
