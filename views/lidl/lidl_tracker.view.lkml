view: lidl_tracker {
  sql_table_name: `still-sensor-360721.datastream.lidl_tracker` ;;
  drill_fields: [file_details*]

  # ==========================================================================
  # 🔑 IDs & PRIMARY KEYS
  # ==========================================================================

  dimension: tracker_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.tracker_id ;;
    hidden: yes
  }

  # ==========================================================================
  # 🏢 METADATA & ORGANIZATION
  # ==========================================================================

  dimension: department {
    label: "Department"
    description: "The Lidl Department owning the file (Source: File_Name column)"
    group_label: "Organization"
    type: string
    sql: ${TABLE}.File_Name ;;
    drill_fields: [lidl_file_owner, real_file_name, count_active_wip]
  }

  dimension: lidl_file_owner {
    label: "Lidl File Owner"
    description: "The individual at Lidl responsible for this file (Source: File_ID column)"
    group_label: "Organization"
    type: string
    sql: ${TABLE}.File_ID ;;
    drill_fields: [real_file_name, current_pipeline_stage, risk_reason]
  }

  dimension: real_file_name {
    label: "File Name"
    description: "The actual name of the file being migrated (Source: File column)"
    group_label: "File Details"
    type: string
    sql: ${TABLE}.File ;;
    link: {
      label: "🔎 Google Search File"
      url: "https://www.google.com/search?q={{ value }}"
      icon_url: "https://www.google.com/favicon.ico"
    }
  }

  dimension: tshirt_size {
    label: "Complexity (T-Shirt)"
    description: "S, M, L, XL"
    group_label: "File Details"
    type: string
    sql: ${TABLE}.Tshirt_Size ;;
    order_by_field: tshirt_sort_index
  }

  dimension: tshirt_sort_index {
    hidden: yes
    type: number
    sql:
      CASE
        WHEN ${tshirt_size} = 'S' THEN 1
        WHEN ${tshirt_size} = 'M' THEN 2
        WHEN ${tshirt_size} = 'L' THEN 3
        WHEN ${tshirt_size} = 'XL' THEN 4
        ELSE 5
      END ;;
  }

  dimension: priority {
    group_label: "File Details"
    type: string
    sql: ${TABLE}.Priority ;;
    html:
    {% if value == 'High' %} <span style="color:red; font-weight:bold">{{ value }}</span>
    {% elsif value == 'Medium' %} <span style="color:orange">{{ value }}</span>
    {% else %} <span style="color:green">{{ value }}</span>
    {% endif %} ;;
  }

  # ==========================================================================
  # 👷‍♀️ TEAM (INCENTRO)
  # ==========================================================================

  dimension: incentro_owner {
    label: "Incentro Engineer"
    description: "The engineer responsible for the migration work"
    group_label: "Execution Team"
    type: string
    sql: ${TABLE}.Incentro_Owner ;;
    drill_fields: [real_file_name, current_pipeline_stage, status_uat]
  }

  dimension: file_sent_to_incentro {
    label: "Handover to Incentro?"
    group_label: "Execution Team"
    type: yesno
    # Source is now a Boolean in BigQuery
    sql: ${TABLE}.File_Sent_to_Incentro ;;
  }


# ==========================================================================
  # 📊 VELOCITY & OUTPUT MEASURES
  # ==========================================================================

  measure: engineer_velocity {
    view_label: "Execution Metrics"
    label: "Avg Files per Engineer"
    description: "Calculated as Active WIP divided by the count of distinct engineers"
    type: number
    value_format_name: decimal_1
    # Uses the existing count_active_wip measure and distinct count of owners
    sql: 1.0 * ${count_active_wip} / NULLIF(COUNT(DISTINCT ${incentro_owner}), 0) ;;
  }

  measure: required_daily_velocity {
    label: "Required Daily Pace"
    description: "Completions needed per working day to hit April 1, 2026"
    type: number
    value_format_name: decimal_2
    sql:
      1.0 * ${count_remaining_dev} /
      NULLIF(
        (DATE_DIFF(DATE('2026-04-01'), CURRENT_DATE(), DAY) + 1)
        - (FLOOR((DATE_DIFF(DATE('2026-04-01'), CURRENT_DATE(), DAY) + 1) / 7) * 2)
      , 0) ;;
    html: <div style="color:#1A73E8; font-weight:bold;">{{ rendered_value }} Files / Day </div> ;;
  }

  # ==========================================================================
  # 🚦 SEQUENTIAL PIPELINE STAGES
  # ==========================================================================

  dimension: status_analyzed {
    label: "1. Analysis"
    group_label: "Stages"
    type: string
    # Handling Boolean Analysed column by casting to string
    sql: CASE WHEN ${TABLE}.Analysed THEN 'Completed' ELSE 'Not Started' END ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_discovery {
    label: "2. Discovery"
    group_label: "Stages"
    type: string
    # Now contains 'Completed', 'Stuck', 'In Progress'
    sql: ${TABLE}.Discovey___Defination ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_build {
    label: "3. Build"
    group_label: "Stages"
    type: string
    # Now contains 'Completed', 'Stuck'
    sql: ${TABLE}.Build ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_test {
    label: "4. Test"
    group_label: "Stages"
    type: string
    # Now contains 'Completed', 'Stuck'
    sql: ${TABLE}.Test ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_uat {
    label: "5. UAT"
    group_label: "Stages"
    type: string
    sql: ${TABLE}.UAT ;;
    html: @{status_color_formatting} ;;
  }

  dimension: current_pipeline_stage {
    label: "Current Stage"
    description: "Exclusive snapshot: Backlog only includes files received with no further action."
    type: string
    sql:
      CASE
        -- 1. Completed Projects

        -- 2. Active Development Stages (highest priority)
        WHEN ${status_uat} IS NOT NULL OR ${status_test} = 'Completed' THEN '5. UAT'
        WHEN ${status_test} IS NOT NULL OR ${status_build} = 'Completed' THEN '4. Test'
        WHEN ${status_build} IS NOT NULL OR ${status_discovery} = 'Completed' THEN '3. Build'
        WHEN ${status_discovery} IS NOT NULL OR ${status_analyzed} = 'Completed' THEN '2. Discovery'

        -- 3. Files in Analysis (The very first action after receipt)
        WHEN ${status_analyzed} = 'Completed' THEN '1. Analysis'

      -- 4. THE BACKLOG: Files received but no Analysis, Discovery, Build, or Test started
      WHEN ${file_sent_to_incentro} THEN 'Not Analyzed'

      -- 5. Files not yet even received
      ELSE 'Not Received'
      END ;;
    order_by_field: stage_sort_order
  }

  dimension: stage_sort_order {
    hidden: yes
    type: number
    # Use explicit CASE to avoid BigQuery CAST errors on non-numeric strings like 'Pre-Backlog'
    sql:
      CASE
        WHEN ${current_pipeline_stage} = 'Not Received' THEN 0
        WHEN ${current_pipeline_stage} = 'Not Analyzed' THEN 1
        WHEN ${current_pipeline_stage} = '1. Analysis' THEN 2
        WHEN ${current_pipeline_stage} = '2. Discovery' THEN 3
        WHEN ${current_pipeline_stage} = '3. Build' THEN 4
        WHEN ${current_pipeline_stage} = '4. Test' THEN 5
        WHEN ${current_pipeline_stage} = '5. UAT' THEN 6
        ELSE 99
      END ;;
  }

  # dimension: stage_sort_order {
  #   hidden: yes
  #   type: number
  #   sql: CAST(LEFT(${current_pipeline_stage}, 1) AS INT64) ;;
  # }

  dimension: overall_health {
    label: "Health Status"
    type: string
    sql:
      CASE
        WHEN LOWER(${status_test}) = 'completed' THEN 'Completed'
        WHEN LOWER(${status_build}) LIKE '%stuck%' OR LOWER(${status_test}) LIKE '%stuck%' OR LOWER(${status_discovery}) LIKE '%stuck%' THEN 'At Risk'
        WHEN ${current_pipeline_stage} = '0. Backlog' THEN 'Not Started'
        ELSE 'On Track'
      END ;;
    html:
    {% if value == 'Completed' %} <span style="color: white; background-color: #137333; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
    {% elsif value == 'At Risk' %} <span style="color: white; background-color: #d93025; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
    {% elsif value == 'On Track' %} <span style="color: white; background-color: #1A73E8; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
    {% else %} <span style="color: black; background-color: #F9AB00; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
    {% endif %} ;;
  }

  dimension: risk_reason {
    label: "Risk Reason"
    type: string
    sql:
      CASE
        WHEN LOWER(${status_discovery}) LIKE '%stuck%' THEN 'Discovery Blocked'
        WHEN LOWER(${status_build}) LIKE '%stuck%' THEN 'Build Blocked'
        WHEN LOWER(${status_test}) LIKE '%stuck%' THEN 'Testing Blocked'
        ELSE NULL
      END ;;
  }

  dimension: is_stuck_anywhere {
    hidden: yes
    type: yesno
    sql: ${status_discovery} = 'Stuck'
      OR ${status_build} = 'Stuck'
      OR ${status_test} = 'Stuck' ;;
  }

  # ==========================================================================
  # 📊 MEASURES
  # ==========================================================================

  measure: count {
    label: "Total Files"
    type: count
    drill_fields: [file_details*]
  }

  measure: total_files_received {
    view_label: "Execution Metrics"
    label: "Total Files Received"
    description: "Count of files where Handover to Incentro is Yes"
    type: count
    filters: [file_sent_to_incentro: "yes"]
  }

  measure: total_files_completed {
    view_label: "Execution Metrics"
    label: "Total Files Completed"
    description: "Count of files where the Test stage is completed"
    type: count
    filters: [status_test: "Completed"]
  }

  measure: total_files_stuck {
    view_label: "Execution Metrics"
    label: "Total Files Stuck"
    description: "Count of files that are 'stuck' in Discovery, Build, or Test stages"
    type: count
    filters: [is_stuck_anywhere: "yes"]
  }

  measure: count_dev_completed {
    label: "Dev Completed (Ready for UAT)"
    type: count
    filters: [status_test: "Completed"]
    drill_fields: [file_details*]
  }

  measure: count_pending_client_action {
    label: "⏳ Pending Client UAT"
    type: count
    filters: [status_test: "Completed", status_uat: "-Completed"]
    drill_fields: [file_details*]
  }

  measure: count_remaining_dev {
    label: "Remaining Dev Scope"
    type: number
    sql: ${count} - ${count_dev_completed} ;;
  }

  measure: percent_dev_completion {
    label: "% Dev Completion"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_dev_completed} / NULLIF(${count}, 0) ;;
  }

  measure: count_active_wip {
    label: "Active WIP"
    type: count
    filters: [current_pipeline_stage: "-0. Backlog, -5. Client UAT (Pending), -6. Handover Complete"]
    drill_fields: [file_details*]
  }

  measure: count_stuck {
    label: "Stagnation Alert"
    type: count
    filters: [is_stuck_anywhere: "yes"]
    drill_fields: [file_details*, risk_reason]
  }

  measure: risk_density {
    label: "Risk Density %"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_stuck} / NULLIF(${count_active_wip}, 0) ;;
  }

  # --- Funnel Metrics ---
  measure: funnel_1_analyzed { group_label: "Funnel" type: count filters: [status_analyzed: "Completed"] }
  measure: funnel_2_discovery { group_label: "Funnel" type: count filters: [status_discovery: "Completed"] }
  measure: funnel_3_build { group_label: "Funnel" type: count filters: [status_build: "Completed"] }
  measure: funnel_4_test { group_label: "Funnel" type: count filters: [status_test: "Completed"] }
  measure: funnel_5_uat { group_label: "Funnel" type: count filters: [status_uat: "Completed"] }

  set: file_details {
    fields: [real_file_name, department, priority, tshirt_size, lidl_file_owner, incentro_owner, current_pipeline_stage, risk_reason]
  }
}
