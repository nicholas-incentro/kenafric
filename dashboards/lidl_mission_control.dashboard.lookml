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
  # ROW 1: EXECUTIVE KPIs
  # ===========================================================================

  - name: title_status
    type: text
    title_text: "1. Current Health Snapshot (Where do we stand right now?)"
    row: 0
    col: 0
    width: 24
    height: 2

  - name: kpi_total_scope
    title: "Total Migration Scope"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count]
    listen:
      Department: lidl_tracker.department
    custom_color: "#5F6368"
    row: 2
    col: 0
    width: 6
    height: 4

  - name: total_analyzed_kpi
    title: "Analysed"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.funnel_1_analyzed]
    listen:
      Department: lidl_tracker.department
    custom_color: "#1A73E8"
    row: 2
    col: 6
    width: 6
    height: 4

  - name: kpi_total_files_completed
    title: "Tested"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_files_completed]
    listen:
      Department: lidl_tracker.department
    custom_color: "#137333" # Green for Finished work
    row: 2
    col: 12
    width: 6
    height: 4

  - name: kpi_total_files_stuck
    title: "Stuck"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.total_files_stuck]
    listen:
      Department: lidl_tracker.department
    custom_color: "#C5221F" # Red for Risk
    row: 2
    col: 18
    width: 6
    height: 4


  # ===========================================================================
  # ROW 2: PIPELINE FLOW
  # ===========================================================================

  - name: text_pipeline
    type: text
    title_text: "🔄 Migration Pipeline"
    subtitle_text: "Current file distribution across active workflow stages."
    row: 4
    col: 0
    width: 24
    height: 2

  - name: viz_kanban
    title: "Active Files by Stage (Snapshot)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.current_pipeline_stage, lidl_tracker.count]
    sorts: [lidl_tracker.current_pipeline_stage]
    listen:
      Department: lidl_tracker.department
    show_value_labels: true
    series_colors:
      lidl_tracker.count: "#1A73E8"
    row: 6
    col: 0
    width: 12
    height: 8

  - name: viz_funnel
    title: "Process Completion Funnel"
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
      Incentro Engineer: lidl_tracker.incentro_owner
    row: 6
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # ROW 3: RISK & COMPLEXITY
  # ===========================================================================

  - name: section_risk
    type: text
    title_text: "🚨 Risk & Complexity Radar"
    row: 14
    col: 0
    width: 24
    height: 2

  - name: viz_stuck_reason
    title: "Primary Blockage Reasons"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.risk_reason, lidl_tracker.total_files_stuck]
    filters:
      lidl_tracker.total_files_stuck: ">0"
    sorts: [lidl_tracker.total_files_stuck desc]
    listen:
      Department: lidl_tracker.department
    series_colors:
      lidl_tracker.total_files_stuck: "#d93025"
    row: 16
    col: 0
    width: 12
    height: 8

  - name: viz_complexity_bottleneck
    title: "Stuck Files by Complexity"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.tshirt_size, lidl_tracker.total_files_stuck]
    filters:
      lidl_tracker.tshirt_size: "-NULL"
    listen:
      Department: lidl_tracker.department
    series_colors:
      lidl_tracker.total_files_stuck: "#d93025"
    row: 16
    col: 12
    width: 12
    height: 8

  # ===========================================================================
  # ROW 4: PEOPLE & PRODUCTIVITY
  # ======================================================================

  # ===========================================================================
  # ROW 5: MASTER TRACKER
  # ===========================================================================

  - name: text_details
    title_text: "📋 Detailed Flight Log"
    type: text
    row: 24
    col: 0
    width: 24
    height: 2

  - name: viz_master_tracker
    title: "Master File Ledger"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_grid
    fields: [
      lidl_tracker.real_file_name,
      lidl_tracker.department,
      lidl_tracker.priority,
      lidl_tracker.tshirt_size,
      lidl_tracker.incentro_owner,
      lidl_tracker.current_pipeline_stage,
      lidl_tracker.overall_health
    ]
    sorts: [lidl_tracker.current_pipeline_stage, lidl_tracker.priority]
    limit: 500
    listen:
      Department: lidl_tracker.department
    enable_conditional_formatting: true
    conditional_formatting: [
      {type: equal to, value: "At Risk", background_color: "#FCE8E6", font_color: "#C5221F", fields: [lidl_tracker.overall_health]},
      {type: equal to, value: "Completed", background_color: "#E6F4EA", font_color: "#137333", fields: [lidl_tracker.overall_health]}
    ]
    row: 36
    col: 0
    width: 24
    height: 10
