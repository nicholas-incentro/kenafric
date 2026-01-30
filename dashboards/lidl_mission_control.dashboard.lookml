- dashboard: lidl_mission_control
  title: "Lidl Project Mission Control"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Operational overview of the Lidl file migration project. Tracks progress from Analysis to UAT."
  auto_run: true

  # ---------------------------------------------------------------------------
  # GLOBAL FILTERS
  # ---------------------------------------------------------------------------
  filters:
  - name: Incentro Owner
    title: "Incentro Developer"
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.incentro_owner

  - name: Priority
    title: "Priority"
    type: field_filter
    default_value: ''
    model: lidl_project_tracker
    explore: lidl_tracker
    field: lidl_tracker.priority

  elements:

  # ---------------------------------------------------------------------------
  # ROW 1: KPI TICKER (High-level Numbers)
  # ---------------------------------------------------------------------------

  - name: total_scope
    title: "Total Files in Scope"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 0
    col: 0
    width: 6
    height: 4

  - name: progress_percentage
    title: "Global Completion % (UAT Done)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.percentage_completion]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    # Color logic: Red if < 50%, Orange < 80%, Green > 80%
    conditional_formatting: [{type: less than, value: 0.5, background_color: !!null '',
        font_color: "#EA4335", color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: greater than,
        value: 0.8, background_color: !!null '', font_color: "#137333", color_application: {
          collection_id: legacy, palette_id: legacy_diverging1}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    row: 0
    col: 6
    width: 6
    height: 4

  - name: blocked_items
    title: "🚨 Blocked / Stuck Files"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count_stuck_files]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    # Color logic: If > 0, turn RED to alert the team
    conditional_formatting: [{type: greater than, value: 0, background_color: "#EA4335",
        font_color: "#FFFFFF", color_application: {collection_id: legacy, palette_id: legacy_diverging1},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    row: 0
    col: 12
    width: 6
    height: 4

  - name: files_pending_transfer
    title: "Pending Transfer to Incentro"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: single_value
    fields: [lidl_tracker.count]
    filters:
      lidl_tracker.file_sent_to_incentro: "No"
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    row: 0
    col: 18
    width: 6
    height: 4

  # ---------------------------------------------------------------------------
  # ROW 2: DETAILED ANALYSIS
  # ---------------------------------------------------------------------------

  - name: build_status_funnel
    title: "Current Build Status Overview"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_column
    fields: [lidl_tracker.status_build, lidl_tracker.count]
    sorts: [lidl_tracker.count desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    # Series colors: Map these to your specific needs or use a palette
    series_colors:
      lidl_tracker.count: "#1A73E8"
    row: 4
    col: 0
    width: 12
    height: 8

  - name: workload_distribution
    title: "Workload by Developer & Complexity"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_bar
    fields: [lidl_tracker.incentro_owner, lidl_tracker.tshirt_size, lidl_tracker.count]
    pivots: [lidl_tracker.tshirt_size]
    sorts: [lidl_tracker.incentro_owner, lidl_tracker.tshirt_size]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: right
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 4
    col: 12
    width: 12
    height: 8

  # ---------------------------------------------------------------------------
  # ROW 3: ACTION LIST (The "ToDo" List)
  # ---------------------------------------------------------------------------

  - name: action_list
    title: "Outstanding Files (Not Yet Completed)"
    model: lidl_project_tracker
    explore: lidl_tracker
    type: looker_grid
    fields: [lidl_tracker.file_name, lidl_tracker.tshirt_size, lidl_tracker.incentro_owner,
      lidl_tracker.status_build, lidl_tracker.status_uat, lidl_tracker.notes_developer]
    filters:
      lidl_tracker.status_uat: "-Completed"
    sorts: [lidl_tracker.status_build]
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    row: 12
    col: 0
    width: 24
    height: 10
