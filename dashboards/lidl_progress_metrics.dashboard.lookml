- dashboard: lidl_gws_transition_metrics
  title: "Executive Progress Report"
  description: "Executive hierarchy: Real-time Status -> Velocity Targets -> Engineering Breakdown."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  auto_run: true

  # ---------------------------------------------------------------------------
  # GLOBAL FILTERS
  # ---------------------------------------------------------------------------
  filters:
  - name: Department
    title: "Lidl Department"
    type: field_filter
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.department
  - name: Incentro Engineer
    title: "Incentro Engineer"
    type: field_filter
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.incentro_owner

  elements:

  # ===========================================================================
  # TIER 1: CURRENT HEALTH SNAPSHOT (5-Tile Global Status)
  # ===========================================================================

  - name: title_status
    type: text
    title_text: "1. Current Health Snapshot (Where do we stand right now?)"
    row: 0
    col: 0
    width: 24
    height: 2

  - name: kpi_total_scope
    title: "Total Scope"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_valid_files]
    listen:
      Department: lidl_tracker.department
    custom_color: "#5F6368"
    row: 2
    col: 0
    width: 4
    height: 4

  - name: kpi_total_files_received
    title: "Received"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_files_received]
    listen:
      Department: lidl_tracker.department
    custom_color: "#1A73E8"
    row: 2
    col: 4
    width: 5
    height: 4

  - name: total_analyzed_kpi
    title: "Analyzed"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.funnel_1_analyzed]
    listen:
      Department: lidl_tracker.department
    custom_color: "#1A73E8"
    row: 2
    col: 9
    width: 5
    height: 4

  - name: kpi_total_files_completed
    title: "Tested"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_files_completed]
    listen:
      Department: lidl_tracker.department
    custom_color: "#137333" # Green for Completion
    row: 2
    col: 14
    width: 5
    height: 4

  - name: kpi_total_files_stuck
    title: "Stuck"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_files_stuck]
    listen:
      Department: lidl_tracker.department
    custom_color: "#C5221F" # Red for Blockers
    row: 2
    col: 19
    width: 5
    height: 4

  # ===========================================================================
  # TIER 2: PACE & SCHEDULE TARGETS
  # ===========================================================================

  - name: title_mid_metrics
    type: text
    title_text: "2. Pace & Schedule Targets (Trajectory towards April 2026 Deadline)"
    row: 6
    col: 0
    width: 24
    height: 2

  - name: kpi_remaining_scope
    title: "Remaining Build Scope"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_remaining_work]
    listen:
      Department: lidl_tracker.department
    row: 8
    col: 0
    width: 8
    height: 4

  - name: velocity_kpi
    title: "Required Pace"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.required_daily_velocity]
    listen:
      Department: lidl_tracker.department
    custom_color: "#1A73E8"
    show_single_value_title: true
    single_value_title: "Files Needed / Day (Target)"
    value_format: "0.00"
    row: 8
    col: 8
    width: 8
    height: 4

  - name: actual_velocity_kpi
    title: "Actual Pace"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.actual_work_rate]
    listen:
      Department: lidl_tracker.department
    custom_color: "#137333" # Green
    show_single_value_title: true
    single_value_title: "Actual Files Completed / Day"
    value_format: "0.00"
    note_state: collapsed
    note_display: below
    row: 8
    col: 16
    width: 8
    height: 4

  # ===========================================================================
  # TIER 3: PHASE & COMPLEXITY VISUALS
  # ===========================================================================

  - name: title_charts
    type: text
    title_text: "3. Operational Distribution (Volume & Complexity)"
    row: 12
    col: 0
    width: 24
    height: 2

  - name: viz_phase_snapshot
    title: "Where Files Are Now"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.current_pipeline_stage, lidl_tracker.count]
    filters:
      lidl_tracker.current_pipeline_stage: "-Pre-Backlog"
    sorts: [lidl_tracker.current_pipeline_stage]
    listen:
      Department: lidl_tracker.department
    show_value_labels: true
    series_colors:
      lidl_tracker.count: "#1A73E8"
    row: 14
    col: 0
    width: 12
    height: 8

  - name: viz_throughput_tshirt
    title: "Complexity Mix vs. Completion"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.tshirt_size, lidl_tracker.total_files_completed]
    filters:
      lidl_tracker.tshirt_size: "-NULL"
    sorts: [lidl_tracker.tshirt_size]
    listen:
      Department: lidl_tracker.department
    stacking: normal
    series_colors:
      lidl_tracker.total_files_completed: "#137333"
      lidl_tracker.total_remaining_work: "#E8EAED"
    row: 14
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # TIER 4: PERFORMANCE & DETAIL
  # ===========================================================================

  - name: title_performance
    type: text
    title_text: "4. Resource Performance & Milestone Ledger"
    row: 22
    col: 0
    width: 24
    height: 2

  - name: viz_leaderboard
    title: "Engineer Performance (Test Completed)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.incentro_owner, lidl_tracker.total_files_completed]
    filters:
      lidl_tracker.incentro_owner: "-NULL"
    sorts: [lidl_tracker.total_files_completed desc]
    listen:
      Department: lidl_tracker.department
    show_value_labels: true
    series_colors:
      lidl_tracker.total_files_completed: "#34A853"
    row: 24
    col: 0
    width: 12
    height: 8

  - name: phase_status_pivot_table
    title: "Milestone Bottleneck Ledger"
    model: lidl_project_tracker
    explore: project_status_summary
    type: looker_grid
    fields: [project_status_summary.stage, project_status_summary.status, project_status_summary.count]
    pivots: [project_status_summary.status]
    sorts: [project_status_summary.stage ASC]
    show_totals: true
    show_row_totals: false
    table_theme: white
    header_font_size: 16
    font_size: 14
    row_height: compact
    conditional_formatting:
      - type: greater than
        value: 0
        background_color: "#E8F5E9"
        font_color: "#1B5E20"
        fields: [project_status_summary.count]
    row: 24
    col: 12
    width: 12
    height: 8
