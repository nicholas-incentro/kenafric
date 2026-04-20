---
- dashboard: roke_telkom_executive
  title: "Roke Telkom — Executive Dashboard"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Unified view of revenue, customers, churn risk, network health, and forecasts across all segments and regions."

  filters:
    - name: Segment
      title: "Segment"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: products.segment
      ui_config:
        type: checkboxes

    - name: Region
      title: "Region"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: regions.region_name
      ui_config:
        type: checkboxes

    - name: Billing Month
      title: "Billing Month"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: billing_transactions.billing_month
      ui_config:
        type: tag_list

    - name: Risk Tier
      title: "Risk Tier"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: churn_predictions
      field: churn_predictions.risk_tier
      ui_config:
        type: button_toggles

    - name: Product
      title: "Product"
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      model: roke_telkom
      explore: billing_transactions
      field: products.product_name
      ui_config:
        type: advanced
        display: popover

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
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Click to drill into revenue by segment → product → customer"
      custom_color_enabled: true
      custom_color: "#34a853"
      row: 0
      col: 0
      width: 5
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
      note_state: collapsed
      note_display: hover
      note_text: "Click to see subscriber list by segment and region"
      custom_color_enabled: true
      custom_color: "#4285f4"
      row: 0
      col: 5
      width: 5
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
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Average revenue per user — drill to see by segment and region"
      row: 0
      col: 10
      width: 5
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
        Risk Tier: churn_predictions.risk_tier
      note_state: collapsed
      note_display: hover
      note_text: "CRITICAL + HIGH risk customers — click to see names and recommended actions"
      custom_color_enabled: true
      custom_color: "#ea4335"
      row: 0
      col: 15
      width: 5
      height: 4

    - title: "Revenue at Risk (Monthly)"
      name: revenue_at_risk
      model: roke_telkom
      explore: churn_predictions
      type: single_value
      fields: [churn_predictions.revenue_at_risk]
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
        Risk Tier: churn_predictions.risk_tier
      note_state: collapsed
      note_display: hover
      note_text: "Monthly fees from CRITICAL + HIGH risk customers — drill to see which customers and segments"
      custom_color_enabled: true
      custom_color: "#e69138"
      row: 0
      col: 20
      width: 4
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
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any segment area to drill into product-level revenue for that month"
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
      value_labels: labels
      label_type: labPer
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
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any slice to filter the entire dashboard to that segment"
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
      fields: [regions.region_name, billing_transactions.total_revenue, billing_transactions.unique_customers, billing_transactions.arpu]
      sorts: [billing_transactions.total_revenue desc]
      series_colors:
        billing_transactions.total_revenue: "#4285f4"
      show_value_labels: true
      label_density: 25
      listen:
        Segment: products.segment
        Region: regions.region_name
        Billing Month: billing_transactions.billing_month
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any bar to drill into customers and products for that region"
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
        Product: products.product_name
      note_state: collapsed
      note_display: hover
      note_text: "Click a segment to see individual overdue transactions"
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
      show_value_labels: true
      label_density: 25
      series_colors:
        CRITICAL: "#ea4335"
        HIGH: "#e69138"
        MEDIUM: "#fbbc04"
        LOW: "#34a853"
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
        Risk Tier: churn_predictions.risk_tier
      note_state: collapsed
      note_display: hover
      note_text: "Click any bar section to see individual at-risk customers with churn probability and recommended action"
      row: 20
      col: 0
      width: 8
      height: 8

    - title: "Top Churn Factors"
      name: churn_factors
      model: roke_telkom
      explore: churn_predictions
      type: looker_bar
      fields: [churn_predictions.top_factor, churn_predictions.count]
      sorts: [churn_predictions.count desc]
      limit: 10
      series_colors:
        churn_predictions.count: "#e69138"
      show_value_labels: true
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
        Risk Tier: churn_predictions.risk_tier
      note_state: collapsed
      note_display: hover
      note_text: "Click a factor to see which customers are affected and their recommended retention actions"
      row: 20
      col: 8
      width: 8
      height: 8

    - title: "At-Risk Customer List"
      name: churn_detail_table
      model: roke_telkom
      explore: churn_predictions
      type: looker_grid
      fields: [
        churn_predictions.risk_tier,
        churn_predictions.segment,
        customers.full_name,
        churn_predictions.churn_probability,
        customers.monthly_fee_ugx,
        churn_predictions.top_factor,
        churn_predictions.recommended_action
      ]
      filters:
        churn_predictions.risk_tier: "CRITICAL,HIGH"
      sorts: [churn_predictions.churn_probability desc]
      limit: 15
      show_row_numbers: true
      listen:
        Segment: churn_predictions.segment
        Region: regions.region_name
        Risk Tier: churn_predictions.risk_tier
      note_state: collapsed
      note_display: hover
      note_text: "Top 15 at-risk customers sorted by churn probability — click any name for their full 360° view"
      row: 20
      col: 16
      width: 8
      height: 8

    # ─── ROW 5: NETWORK ────────────────────────────────────────

    - title: "Bandwidth by Hour & Region"
      name: bandwidth_hourly
      model: roke_telkom
      explore: network_telemetry
      type: looker_line
      fields: [network_telemetry.timestamp_hour_of_day, regions.region_name, network_telemetry.avg_bandwidth]
      pivots: [regions.region_name]
      sorts: [network_telemetry.timestamp_hour_of_day]
      show_value_labels: false
      point_style: circle
      series_point_style:
        Kampala Central: filled
        Wakiso / Entebbe: filled
        Jinja: filled
      y_axes: [{label: "Bandwidth %", maxValue: 100}]
      reference_lines:
        - value: 85
          label: "Capacity Warning (85%)"
          color: "#ea4335"
          line_weight: 1
          label_position: left
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any data point to drill into that region's hourly detail including latency and packet loss"
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
      note_state: collapsed
      note_display: hover
      note_text: "Click to see uptime by region and date"
      custom_color_enabled: true
      custom_color: "#34a853"
      row: 28
      col: 16
      width: 4
      height: 4

    - title: "Avg Latency (ms)"
      name: latency
      model: roke_telkom
      explore: network_telemetry
      type: single_value
      fields: [network_telemetry.avg_latency]
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click to see latency by region and hour"
      row: 28
      col: 20
      width: 4
      height: 4

    - title: "Network Health by Region"
      name: network_region_table
      model: roke_telkom
      explore: network_telemetry
      type: looker_grid
      fields: [
        regions.region_name,
        network_telemetry.avg_bandwidth,
        network_telemetry.max_bandwidth,
        network_telemetry.avg_latency,
        network_telemetry.avg_uptime,
        network_telemetry.avg_packet_loss,
        network_telemetry.avg_sessions
      ]
      sorts: [network_telemetry.avg_bandwidth desc]
      show_row_numbers: false
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any region name to drill into revenue, customers, or hourly network data for that region"
      conditional_formatting:
        - type: along a scale...
          value:
          background_color:
          font_color:
          palette:
            name: Red to Green
            colors: ["#ea4335", "#fbbc04", "#34a853"]
          bold: false
          italic: false
          strikethrough: false
          fields: [network_telemetry.avg_uptime]
      row: 32
      col: 16
      width: 8
      height: 4

    # ─── ROW 6: FORECAST ───────────────────────────────────────

    - title: "Revenue Forecast (9 Months)"
      name: forecast
      model: roke_telkom
      explore: revenue_forecast
      type: looker_line
      fields: [revenue_forecast.forecast_month, revenue_forecast.segment, revenue_forecast.total_predicted_revenue]
      pivots: [revenue_forecast.segment]
      sorts: [revenue_forecast.forecast_month]
      show_value_labels: false
      point_style: circle
      series_colors:
        Enterprise: "#4285f4"
        Residential: "#34a853"
        VOIP: "#ea4335"
        Security: "#a855f7"
        Mobile WiFi: "#fbbc04"
        Paratus JV: "#00bcd4"
        Data Center: "#ff6d01"
      y_axes: [{label: "Predicted Revenue (UGX M)"}]
      listen:
        Segment: revenue_forecast.segment
      note_state: collapsed
      note_display: hover
      note_text: "BQML ARIMA_PLUS forecast — click any point to see confidence bounds and segment breakdown"
      row: 36
      col: 0
      width: 18
      height: 8

    - title: "Forecast Confidence"
      name: forecast_confidence
      model: roke_telkom
      explore: revenue_forecast
      type: single_value
      fields: [revenue_forecast.avg_confidence]
      note_state: collapsed
      note_display: hover
      note_text: "Average model confidence across all forecast periods"
      row: 36
      col: 18
      width: 6
      height: 4

    - title: "Total Forecast Revenue"
      name: forecast_total
      model: roke_telkom
      explore: revenue_forecast
      type: single_value
      fields: [revenue_forecast.total_predicted_revenue]
      listen:
        Segment: revenue_forecast.segment
      note_state: collapsed
      note_display: hover
      note_text: "Sum of predicted revenue across all forecast months — click to drill by segment and month"
      custom_color_enabled: true
      custom_color: "#4285f4"
      row: 40
      col: 18
      width: 6
      height: 4

    # ─── ROW 7: SUPPORT ────────────────────────────────────────

    - title: "Tickets by Category & Region"
      name: tickets_by_category
      model: roke_telkom
      explore: support_tickets
      type: looker_bar
      fields: [support_tickets.category, regions.region_name, support_tickets.count]
      pivots: [regions.region_name]
      sorts: [support_tickets.count desc 0]
      stacking: normal
      show_value_labels: false
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any bar to see individual tickets with customer name, priority, and resolution time"
      row: 44
      col: 0
      width: 8
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
      show_value_labels: true
      y_axes: [{label: "CSAT Score", minValue: 1, maxValue: 5}]
      reference_lines:
        - value: 3.5
          label: "Target (3.5)"
          color: "#e69138"
          line_weight: 1
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any bar to drill into individual tickets and CSAT scores for that region"
      row: 44
      col: 8
      width: 8
      height: 8

    - title: "Support Metrics"
      name: support_kpis
      model: roke_telkom
      explore: support_tickets
      type: looker_grid
      fields: [
        regions.region_name,
        support_tickets.count,
        support_tickets.open_count,
        support_tickets.high_priority_count,
        support_tickets.avg_resolution_hours,
        support_tickets.avg_csat,
        support_tickets.detractor_count
      ]
      sorts: [support_tickets.count desc]
      show_row_numbers: false
      listen:
        Region: regions.region_name
      note_state: collapsed
      note_display: hover
      note_text: "Click any metric to drill into individual tickets — click region name for full region analysis"
      conditional_formatting:
        - type: along a scale...
          value:
          background_color:
          font_color:
          palette:
            name: Red to Green
            colors: ["#ea4335", "#fbbc04", "#34a853"]
          bold: false
          italic: false
          strikethrough: false
          fields: [support_tickets.avg_csat]
      row: 44
      col: 16
      width: 8
      height: 8
