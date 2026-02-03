- dashboard: lidl_gws_transition_metrics
  title: "Progress Report"
  description: "Executive hierarchy: Status -> Pace -> Detailed Breakdown."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  auto_run: true

  # ---------------------------------------------------------------------------
  # FILTERS
  # ---------------------------------------------------------------------------
  filters:
  - name: Department
    title: "Department"
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
  # TIER 1: HIGH-LEVEL STATUS (All Single Tiles Up)
  # ===========================================================================

  - name: title_status
    type: text
    title_text: "1. Current Health Snapshot (Where do we stand right now?)"
    row: 0
    col: 0
    width: 24
    height: 2

  - name: kpi_total_scope
    title: "Total Scope (Files)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count]
    listen:
      Department: lidl_tracker.department
    note:
      text: "Total number of files identified for migration."
      state: collapsed
      display: hover
    row: 2
    col: 0
    width: 6
    height: 4


    # Using the Single Value type with 'progress' style creates a clean linear gauge.
  - name: viz_schedule_gauge
    title: "Progress to Target"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.percent_dev_completion]
    listen:
      Department: lidl_tracker.department
    note:
      text: "Percentage of files completed."
      state: collapsed
      display: hover
    # This configuration turns the single value into a progress gauge
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: less than, value: 1.0, background_color: "#FFFFFF", font_color: "#1A73E8"}
    ]
    comparison_type: progress_percentage
    comparison_label: "Target Completion"
    # Setting the 'value' to 1.0 (100%) gives the bar a target to fill towards
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_summary: true
    summary_text: "of 100% Target"
    row: 2
    col: 6
    width: 6
    height: 4


  - name: kpi_stagnation
    title: "⚠️ Stuck / Blocked"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_stuck]
    listen:
      Department: lidl_tracker.department
    note:
      text: "Number of files flagged as 'Stuck' in Build, or Test."
      state: collapsed
      display: hover
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 0, background_color: "#FCE8E6", font_color: "#C5221F"}
    ]
    row: 2
    col: 12
    width: 6
    height: 4

  - name: kpi_pending_client
    title: "⏳ Pending Client UAT"
    note_text: "Delivered, awaiting sign-off"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_pending_client_action]
    listen:
      Department: lidl_tracker.department
    note:
      text: "Number of files awaiting UAT from Lidl."
      state: collapsed
      display: hover
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 10, background_color: "#FFF2CC", font_color: "#B45F06"}
    ]
    row: 2
    col: 18
    width: 6
    height: 4

  # ===========================================================================
  # TIER 2: MID-LEVEL METRICS (Remaining | Velocity | Adherence)
  # ===========================================================================

  - name: title_mid_metrics
    type: text
    title_text: "2. Pace & Schedule Targets (Trajectory towards April 2026.)"
    row: 6
    col: 0
    width: 24
    height: 2

  - name: kpi_remaining_scope
    title: "Remaining Scope"
    note_text: "Items left to build"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_remaining_dev]
    listen:
      Department: lidl_tracker.department
    row: 8
    col: 0
    width: 8
    height: 5

  - name: kpi_velocity_req
    title: "Required Daily Pace"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.required_daily_velocity]
    listen:
      Department: lidl_tracker.department
    note:
      text: "Work rate required to meet the set deadline."
      state: collapsed
      display: hover
    # Conditional formatting applies to the background since font is handled in HTML
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 5, background_color: "#FCE8E6", font_color: "#C5221F"} # Red BG if pace is too high
    ]
    row: 8
    col: 8
    width: 8
    height: 5

  - name: kpi_stagnation_quality
    title: "Stagnation Safety Score"
    note:
      text: "Ratio: Client Wait (Safe) vs. Internal Stuck. 100% Score: Great! Everything stopped is waiting on the client. 0% Score: Critical! Everything stopped is stuck internally"
      state: collapsed
      display: hover
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.percent_stagnation_safety]
    filters:
      lidl_tracker.overall_health: "On Track, Completed"
    listen:
      Department: lidl_tracker.department
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: less than, value: 0.8, background_color: "#FCE8E6", font_color: "#C5221F"}
    ]
    row: 8
    col: 16
    width: 8
    height: 5


  # ===========================================================================
  # TIER 3: CHARTS (All visuals moved down)
  # ===========================================================================

  - name: viz_phase_breakdown
    title: "Phase Breakdown"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.current_pipeline_stage, lidl_tracker.count]
    sorts: [lidl_tracker.current_pipeline_stage]
    listen:
      Department: lidl_tracker.department
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      lidl_tracker.count: "#1A73E8"
    row: 13
    col: 0
    width: 12
    height: 8

  - name: viz_throughput_tshirt
    title: "Complexity Distribution"
    subtitle_text: "Stacked: Completed (Green) over Total (Grey)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.tshirt_size, lidl_tracker.count_dev_completed, lidl_tracker.count]
    sorts: [lidl_tracker.tshirt_size]
    listen:
      Department: lidl_tracker.department
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_value_labels: true
    stacking: normal
    series_colors:
      lidl_tracker.count_dev_completed: "#137333"
      lidl_tracker.count: "#E8EAED"
    row: 13
    col: 12
    width: 12
    height: 8

  - name: viz_leaderboard
    title: "Engineer Output Leaderboard"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.incentro_owner, lidl_tracker.count_build_completed]
    filters:
      lidl_tracker.incentro_owner: "-NULL"
    sorts: [lidl_tracker.count_build_completed desc]
    listen:
      Department: lidl_tracker.department
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_value_labels: true
    # Slanted labels to support Vertical Bars
    x_axis_label_rotation: -45
    series_colors:
      lidl_tracker.count_build_completed: "#4285F4"
    row: 21
    col: 0
    width: 24
    height: 9
