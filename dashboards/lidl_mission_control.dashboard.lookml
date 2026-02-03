- dashboard: lidl_mission_control_comprehensive
  title: "Mission Control Center"
  description: "End-to-end visibility: Scope, Pipeline Velocity, Risk, and Resource Productivity."
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: false
  auto_run: true

  # ===========================================================================
  # 🔍 DYNAMIC FILTERS
  # ===========================================================================
  filters:
  - name: Department
    title: "Department"
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    ui_config:
      type: tag_list
      display: popover
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.department

  - name: Priority
    title: "Priority"
    type: field_filter
    ui_config:
      type: button_group
      display: inline
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.priority

  - name: Incentro Engineer
    title: "Incentro Engineer"
    type: field_filter
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.incentro_owner

  - name: Health
    title: "Health Status"
    type: field_filter
    ui_config:
      type: button_group
      display: inline
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.overall_health

  elements:

  # ===========================================================================
  # ROW 1: EXECUTIVE KPIs
  # ===========================================================================

  - name: kpi_scope
    title: "Total Scope"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Total number of files identified for migration."
      state: collapsed
      display: hover
    font_size: medium
    text_color: "#5F6368"
    row: 0
    col: 0
    width: 4
    height: 4

  - name: kpi_active
    title: "Active WIP"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_active_wip]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Files currently in progress (Excludes 'Backlog' and 'Done')."
      state: collapsed
      display: hover
    font_size: medium
    text_color: "#1A73E8"
    custom_color_enabled: true
    show_single_value_title: true
    row: 0
    col: 4
    width: 4
    height: 4

  # - name: kpi_completion
  #   title: "Overall Completion"
  #   model: lidl_project_tracker
  #   explore: lidl_tracker
  #   type: single_value
  #   fields: [lidl_tracker.percent_completion]
  #   listen:
  #     Department: lidl_tracker.department
  #     Priority: lidl_tracker.priority
  #     Incentro Engineer: lidl_tracker.incentro_owner
  #     Health: lidl_tracker.overall_health
  #   note:
  #     text: "Percentage of total scope that has successfully passed UAT."
  #     state: collapsed
  #     display: hover
  #   custom_color_enabled: true
  #   enable_conditional_formatting: true
  #   conditional_formatting: [
  #     {type: greater than, value: 0.9, background_color: "#E6F4EA", font_color: "#137333"},
  #     {type: less than, value: 0.5, background_color: "#FCE8E6", font_color: "#d93025"}
  #   ]
  #   font_size: medium
  #   row: 0
  #   col: 8
  #   width: 4
  #   height: 4

  - name: kpi_completion
    title: "Overall Completion"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    # FIX: Changed 'percent_completion' to 'percent_dev_completion'
    fields: [lidl_tracker.percent_dev_completion]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
    note:
      text: "Percentage of total scope that has successfully passed UAT."
      state: collapsed
      display: hover
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 0.9, background_color: "#E6F4EA", font_color: "#137333"},
      {type: less than, value: 0.5, background_color: "#FCE8E6", font_color: "#d93025"}
    ]
    row: 0
    col: 8
    width: 4
    height: 4

  - name: kpi_risk
    title: "⚠️ BLOCKED FILES"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_stuck]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Count of files flagged as 'Stuck' in Build, Test, or UAT."
      state: collapsed
      display: hover
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 0, background_color: "#d93025", font_color: "#FFFFFF"}
    ]
    font_size: medium
    row: 0
    col: 12
    width: 4
    height: 4

  - name: kpi_risk_density
    title: "Risk Density"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.risk_density]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
    note:
      text: "% of Active WIP that is currently blocked. Target: <20%."
      state: collapsed
      display: hover
    custom_color_enabled: true
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: greater than, value: 0.20, background_color: "#FFF7E0", font_color: "#E37400"}
    ]
    font_size: medium
    row: 0
    col: 16
    width: 4
    height: 4

  - name: kpi_velocity
    title: "Files / Engineer"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.engineer_velocity]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Average number of active files being handled per engineer."
      state: collapsed
      display: hover
    font_size: medium
    text_color: "#0050AA"
    row: 0
    col: 20
    width: 4
    height: 4

  # ===========================================================================
  # ROW 2: PIPELINE FLOW
  # ===========================================================================

  - name: text_pipeline
    type: text
    title_text: "🔄 Migration Pipeline"
    subtitle_text: "Real-time flow of files from Backlog to UAT."
    row: 4
    col: 0
    width: 24
    height: 2

  - name: viz_kanban
    title: "Active Files by Stage (Kanban)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.current_pipeline_stage, lidl_tracker.count]
    sorts: [lidl_tracker.current_pipeline_stage]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Visualizes the pile-up of files. Ideally, bars should be even across stages."
      state: collapsed
      display: hover
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_x_axis_label: false
    show_y_axis_labels: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      lidl_tracker.count: "#1A73E8"
    reference_lines: [{reference_type: line, line_value: mean, label: "Avg", color: "#E37400"}]
    row: 6
    col: 0
    width: 12
    height: 8

  - name: viz_funnel
    title: "Completion Rate by Stage"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_funnel
    fields: [
      lidl_tracker.funnel_1_analyzed,
      lidl_tracker.funnel_2_discovery,
      lidl_tracker.funnel_3_build,
      lidl_tracker.funnel_4_test,
      lidl_tracker.funnel_5_uat
    ]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Shows drop-offs. If a step is much narrower than the previous, it's a bottleneck."
      state: collapsed
      display: hover
    leftAxisLabelVisible: false
    rightAxisLabelVisible: false
    smoothedBars: false
    orientation: automatic
    labelPosition: right
    percentType: prior
    percentPosition: inline
    valuePosition: right
    color_application:
      collection_id: google
      palette_id: google-categorical
      options:
        steps: 5
    row: 6
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # ROW 3: RISK RADAR
  # ===========================================================================

  - name: section_risk
    type: text
    title_text: "🚨 Risk & Performance Radar"
    subtitle_text: "Spotting Slow & Dangerous Departments vs. High Performers."
    row: 14
    col: 0
    width: 24
    height: 2

  - name: viz_risk_radar
    title: "Risk Radar: Speed vs. Risk"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_scatter
    fields: [
      lidl_tracker.department,
      lidl_tracker.engineer_velocity,
      lidl_tracker.risk_density,
      lidl_tracker.count_active_wip
    ]
    listen:
      Priority: lidl_tracker.priority
      Health: lidl_tracker.overall_health
    note:
      text: "X=Speed, Y=Risk. Top-Right = Fast but Risky. Top-Left = Slow and Risky."
      state: collapsed
      display: hover
    x_axis_label: "Velocity (Avg Files/Engineer)"
    y_axis_label: "Risk Density (% Stuck)"
    point_style: circle
    point_radius: 5
    series_types:
      lidl_tracker.count_active_wip: scatter
    series_colors:
      lidl_tracker.count_active_wip: "#E30613"
    reference_lines: [
      {reference_type: line, line_value: mean, axis: x, label: "Avg Speed", color: "#5F6368"},
      {reference_type: line, line_value: mean, axis: y, label: "Avg Risk", color: "#5F6368"}
    ]
    row: 16
    col: 0
    width: 12
    height: 8

  - name: viz_stuck_reason
    title: "Stuck Reasons (Pareto)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.risk_reason, lidl_tracker.count_stuck]
    filters:
      lidl_tracker.count_stuck: ">0"
    sorts: [lidl_tracker.count_stuck desc]
    listen:
      Health: lidl_tracker.overall_health
      Priority: lidl_tracker.priority
      Department: lidl_tracker.department
    note:
      text: "Primary causes of blockage. Focus on the top bar first."
      state: collapsed
      display: hover
    show_x_axis_label: false
    series_colors:
      lidl_tracker.count_stuck: "#d93025"
    row: 16
    col: 12
    width: 12
    height: 8

  - name: viz_complexity_bottleneck
    title: "Bottlenecks by File Complexity"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.tshirt_size, lidl_tracker.count_stuck, lidl_tracker.count_active_wip]
    sorts: [lidl_tracker.count_active_wip desc]
    listen:
      Health: lidl_tracker.overall_health
      Priority: lidl_tracker.priority
      Department: lidl_tracker.department
    note:
      text: "Are large files (XL) getting stuck more often than small ones?"
      state: collapsed
      display: hover
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_value_labels: true
    label_color: ["#FFF", "#5F6368"]
    series_colors:
      lidl_tracker.count_stuck: "#d93025"
      lidl_tracker.count_active_wip: "#1A73E8"
    row: 24
    col: 0
    width: 12
    height: 6

  - name: viz_complexity_breakdown
    title: "Portfolio Complexity (T-Shirt Size)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_donut_multiples
    fields: [lidl_tracker.tshirt_size, lidl_tracker.count]
    pivots: [lidl_tracker.tshirt_size]
    listen:
      Health: lidl_tracker.overall_health
      Priority: lidl_tracker.priority
      Department: lidl_tracker.department
    note:
      text: "Distribution of file sizes. Useful for capacity planning."
      state: collapsed
      display: hover
    show_value_labels: true
    font_size: 12
    charts_across: 4
    series_colors:
      "XS": "#E6F4EA"
      "S": "#81C995"
      "M": "#FDD663"
      "L": "#F29900"
      "XL": "#d93025"
    row: 24
    col: 12
    width: 12
    height: 6

  # ===========================================================================
  # ROW 4: PEOPLE & PRODUCTIVITY
  # ===========================================================================

  - name: text_people
    title_text: "👥 Team Performance & Load"
    subtitle_text: "Resource allocation and individual bottlenecks."
    type: text
    row: 30
    col: 0
    width: 24
    height: 2

  - name: viz_stagnation_heatmap
    title: "Stagnation Matrix: Files per Engineer"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_grid
    fields: [
      lidl_tracker.incentro_owner,
      lidl_tracker.current_pipeline_stage,
      lidl_tracker.count_active_wip
    ]
    pivots: [lidl_tracker.current_pipeline_stage]
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Health: lidl_tracker.overall_health
    sorts: [lidl_tracker.count_active_wip desc 0]
    limit: 50
    note:
      text: "Darker cells indicate high volume. Look for columns of darkness (bottleneck stage)."
      state: collapsed
      display: hover
    show_view_names: false
    show_row_numbers: false
    table_theme: transparent
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: along a scale..., value: !!null '', background_color: "#1A73E8", font_color: !!null ''}
    ]
    row: 32
    col: 0
    width: 24
    height: 8

  - name: viz_incentro_load
    title: "Engineer Load vs. Completion %"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.incentro_owner, lidl_tracker.count_active_wip, lidl_tracker.percent_dev_completion]
    sorts: [lidl_tracker.count_active_wip desc]
    limit: 15
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Bars = Active Load (Blue). Line = Completion Rate (Green). High bar + Low line = Overloaded."
      state: collapsed
      display: hover
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axis_combined: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: false
    series_types:
      lidl_tracker.percent_completion: line
    series_colors:
      lidl_tracker.count_active_wip: "#1A73E8"
      lidl_tracker.percent_completion: "#137333"
    series_point_style: circle
    row: 40
    col: 0
    width: 12
    height: 8

  - name: viz_dept_breakdown
    title: "Status by Department"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.department, lidl_tracker.count_dev_completed, lidl_tracker.count_stuck, lidl_tracker.count_active_wip]
    sorts: [lidl_tracker.count_active_wip desc]
    stacking: normal
    limit: 15
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Departmental breakdown of Green (Done), Blue (WIP), and Red (Stuck)."
      state: collapsed
      display: hover
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_value_labels: false
    show_x_axis_label: false
    legend_position: top
    series_colors:
      lidl_tracker.count_completed: "#137333"
      lidl_tracker.count_active_wip: "#1A73E8"
      lidl_tracker.count_stuck: "#d93025"
    row: 40
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # ROW 5: DETAILED FLIGHT LOG
  # ===========================================================================

  - name: text_details
    title_text: "📋 Detailed Flight Log"
    subtitle_text: "Granular view of every file. Click headers to sort."
    type: text
    row: 48
    col: 0
    width: 24
    height: 2

  - name: viz_master_tracker
    title: "Master File Tracker"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_grid
    fields: [
      lidl_tracker.real_file_name,
      lidl_tracker.department,
      lidl_tracker.priority,
      lidl_tracker.tshirt_size,
      lidl_tracker.incentro_owner,
      lidl_tracker.lidl_file_owner,
      lidl_tracker.current_pipeline_stage,
      lidl_tracker.overall_health
    ]
    sorts: [lidl_tracker.current_pipeline_stage, lidl_tracker.priority]
    limit: 500
    listen:
      Department: lidl_tracker.department
      Priority: lidl_tracker.priority
      Incentro Engineer: lidl_tracker.incentro_owner
      Health: lidl_tracker.overall_health
    note:
      text: "Full list. Red rows = At Risk. Green rows = Completed."
      state: collapsed
      display: hover
    show_view_names: false
    show_row_numbers: true
    truncate_text: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: equal to, value: "At Risk", background_color: "#FCE8E6", font_color: "#C5221F", fields: [lidl_tracker.overall_health]},
      {type: equal to, value: "Completed", background_color: "#E6F4EA", font_color: "#137333", fields: [lidl_tracker.overall_health]}
    ]
    row: 50
    col: 0
    width: 24
    height: 10
