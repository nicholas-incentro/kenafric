---
- dashboard: roke_telkom_executive
  title: "Roke Telkom — Executive Dashboard"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true

  filters:
    - name: Segment
      title: "Segment"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: products.segment

    - name: Region
      title: "Region"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: regions.region_name

    - name: Billing Month
      title: "Billing Month"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: billing_transactions.billing_month

  elements:

    # ─── ROW 1: KPI SCORECARDS ─────────────────────────────────

    - title: "Total Revenue (9mo)"
      name: total_revenue
      model: roke_telkom
      explore: billing_transactions
      type: single_value
      fields: [billing_transactions.total_revenue]
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 0
      col: 0
      width: 6
      height: 4

    - title: "Active Subscribers"
      name: active_subscribers
      model: roke_telkom
      explore: customers
      type: single_value
      fields: [customers.active_count]
      listen:
        Segment: customers.segment
        Region: regions.region_name
      row: 0
      col: 6
      width: 6
      height: 4

    - title: "ARPU (9mo)"
      name: arpu
      model: roke_telkom
      explore: billing_transactions
      type: single_value
      fields: [billing_transactions.arpu]
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 0
      col: 12
      width: 6
      height: 4

    - title: "At-Risk Customers"
      name: at_risk
      model: roke_telkom
      explore: churn_predictions
      type: single_value
      fields: [churn_predictions.critical_and_high_count]
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
      row: 0
      col: 18
      width: 6
      height: 4

    # ─── ROW 2: REVENUE TREND + PRODUCT MIX ────────────────────

    - title: "Monthly Revenue by Segment"
      name: revenue_trend
      model: roke_telkom
      explore: billing_transactions
      type: looker_area
      fields: [billing_transactions.billing_month, products.segment, billing_transactions.total_revenue]
      pivots: [products.segment]
      sorts: [billing_transactions.billing_month]
      stacking: normal
      show_value_labels: false
      legend_position: center
      point_style: none
      series_colors:
        Enterprise: "#4285f4"
        Residential: "#34a853"
        VOIP: "#ea4335"
        Security: "#a855f7"
        Mobile WiFi: "#fbbc04"
        Paratus JV: "#00bcd4"
        Data Center: "#ff6d01"
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 4
      col: 0
      width: 16
      height: 8

    - title: "Revenue by Product"
      name: product_mix
      model: roke_telkom
      explore: billing_transactions
      type: looker_pie
      fields: [products.segment, billing_transactions.total_revenue]
      sorts: [billing_transactions.total_revenue desc]
      series_colors:
        Enterprise: "#4285f4"
        Residential: "#34a853"
        VOIP: "#ea4335"
        Security: "#a855f7"
        Mobile WiFi: "#fbbc04"
        Paratus JV: "#00bcd4"
        Data Center: "#ff6d01"
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 4
      col: 16
      width: 8
      height: 8

    # ─── ROW 3: REGIONAL + PAYMENT ─────────────────────────────

    - title: "Revenue by Region"
      name: region_revenue
      model: roke_telkom
      explore: billing_transactions
      type: looker_bar
      fields: [regions.region_name, billing_transactions.total_revenue]
      sorts: [billing_transactions.total_revenue desc]
      series_colors:
        billing_transactions.total_revenue: "#4285f4"
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 12
      col: 0
      width: 12
      height: 8

    - title: "Payment Method Mix"
      name: payment_method
      model: roke_telkom
      explore: billing_transactions
      type: looker_donut_multiples
      fields: [billing_transactions.payment_method, billing_transactions.payment_status, billing_transactions.transaction_count]
      pivots: [billing_transactions.payment_status]
      sorts: [billing_transactions.transaction_count desc 0]
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
      row: 12
      col: 12
      width: 12
      height: 8

    # ─── ROW 4: CHURN RISK ─────────────────────────────────────

    - title: "Churn Risk by Segment"
      name: churn_by_segment
      model: roke_telkom
      explore: churn_predictions
      type: looker_bar
      fields: [churn_predictions.segment, churn_predictions.risk_tier, churn_predictions.count]
      pivots: [churn_predictions.risk_tier]
      sorts: [churn_predictions.count desc 0]
      stacking: normal
      series_colors:
        CRITICAL: "#ea4335"
        HIGH: "#e69138"
        MEDIUM: "#fbbc04"
        LOW: "#34a853"
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
      row: 20
      col: 0
      width: 12
      height: 8

    - title: "Top Churn Factors"
      name: churn_factors
      model: roke_telkom
      explore: churn_predictions
      type: looker_bar
      fields: [churn_predictions.top_factor, churn_predictions.count]
      sorts: [churn_predictions.count desc]
      series_colors:
        churn_predictions.count: "#e69138"
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
      row: 20
      col: 12
      width: 12
      height: 8

    # ─── ROW 5: NETWORK ───────────────────────────────────────

    - title: "Bandwidth by Hour & Region"
      name: bandwidth_hourly
      model: roke_telkom
      explore: network_telemetry
      type: looker_line
      fields: [network_telemetry.timestamp_hour_of_day, regions.region_name, network_telemetry.avg_bandwidth]
      pivots: [regions.region_name]
      sorts: [network_telemetry.timestamp_hour_of_day]
      show_value_labels: false
      point_style: none
      listen:
        Region: regions.region_name
      row: 28
      col: 0
      width: 16
      height: 8

    - title: "Avg Uptime %"
      name: uptime
      model: roke_telkom
      explore: network_telemetry
      type: single_value
      fields: [network_telemetry.avg_uptime]
      listen:
        Region: regions.region_name
      row: 28
      col: 16
      width: 8
      height: 4

    - title: "Avg Latency (ms)"
      name: latency
      model: roke_telkom
      explore: network_telemetry
      type: single_value
      fields: [network_telemetry.avg_latency]
      listen:
        Region: regions.region_name
      row: 32
      col: 16
      width: 8
      height: 4

    # ─── ROW 6: FORECAST ──────────────────────────────────────

    - title: "Revenue Forecast (9 Months)"
      name: forecast
      model: roke_telkom
      explore: revenue_forecast
      type: looker_line
      fields: [revenue_forecast.forecast_month, revenue_forecast.segment, revenue_forecast.total_predicted_revenue]
      pivots: [revenue_forecast.segment]
      sorts: [revenue_forecast.forecast_month]
      show_value_labels: false
      point_style: none
      series_colors:
        Enterprise: "#4285f4"
        Residential: "#34a853"
        VOIP: "#ea4335"
        Security: "#a855f7"
        Mobile WiFi: "#fbbc04"
        Paratus JV: "#00bcd4"
        Data Center: "#ff6d01"
      row: 36
      col: 0
      width: 24
      height: 8

    # ─── ROW 7: SUPPORT ───────────────────────────────────────

    - title: "Tickets by Category & Region"
      name: tickets_by_category
      model: roke_telkom
      explore: support_tickets
      type: looker_bar
      fields: [support_tickets.category, regions.region_name, support_tickets.count]
      pivots: [regions.region_name]
      sorts: [support_tickets.count desc 0]
      stacking: normal
      listen:
        Region: regions.region_name
      row: 44
      col: 0
      width: 12
      height: 8

    - title: "Avg CSAT by Region"
      name: csat_region
      model: roke_telkom
      explore: support_tickets
      type: looker_column
      fields: [regions.region_name, support_tickets.avg_csat]
      sorts: [support_tickets.avg_csat desc]
      series_colors:
        support_tickets.avg_csat: "#34a853"
      listen:
        Region: regions.region_name
      row: 44
      col: 12
      width: 12
      height: 8
