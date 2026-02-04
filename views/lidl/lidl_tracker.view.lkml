# view: lidl_tracker {
#   sql_table_name: `still-sensor-360721.datastream.lidl_tracker` ;;
#   drill_fields: [file_details*]

#   # ==========================================================================
#   # 🔑 IDs & PRIMARY KEYS
#   # ==========================================================================

#   dimension: tracker_id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.tracker_id ;;
#     hidden: yes
#   }

#   # ==========================================================================
#   # 🏢 METADATA & ORGANIZATION
#   # ==========================================================================

#   dimension: department {
#     label: "Department"
#     description: "The Lidl Department owning the file"
#     group_label: "Organization"
#     type: string
#     # Mapped per instruction: File_Name column = Department
#     sql: ${TABLE}.File_Name ;;
#     drill_fields: [lidl_file_owner, real_file_name, count_active_wip]
#   }

#   dimension: lidl_file_owner {
#     label: "Lidl File Owner"
#     description: "The individual at Lidl responsible for this file"
#     group_label: "Organization"
#     type: string
#     # Mapped per instruction: File_ID column = Owner
#     sql: ${TABLE}.File_ID ;;
#     drill_fields: [real_file_name, current_pipeline_stage, risk_reason]
#   }

#   dimension: real_file_name {
#     label: "File Name"
#     description: "The actual name of the file being migrated"
#     group_label: "File Details"
#     type: string
#     # Mapped per instruction: File column = File Name
#     sql: ${TABLE}.File ;;
#     link: {
#       label: "🔎 Google Search File"
#       url: "https://www.google.com/search?q={{ value }}"
#       icon_url: "https://www.google.com/favicon.ico"
#     }
#   }

#   dimension: tshirt_size {
#     label: "Complexity (T-Shirt)"
#     description: "S, M, L, XL"
#     group_label: "File Details"
#     type: string
#     sql: ${TABLE}.Tshirt_Size ;;
#     order_by_field: tshirt_sort_index
#   }

#   dimension: tshirt_sort_index {
#     hidden: yes
#     type: number
#     sql:
#       CASE
#         WHEN ${tshirt_size} = 'S' THEN 1
#         WHEN ${tshirt_size} = 'M' THEN 2
#         WHEN ${tshirt_size} = 'L' THEN 3
#         WHEN ${tshirt_size} = 'XL' THEN 4
#         ELSE 5
#       END ;;
#   }

#   dimension: priority {
#     group_label: "File Details"
#     type: string
#     sql: ${TABLE}.Priority ;;
#     html:
#     {% if value == 'High' %} <span style="color:red; font-weight:bold">{{ value }}</span>
#     {% elsif value == 'Medium' %} <span style="color:orange">{{ value }}</span>
#     {% else %} <span style="color:green">{{ value }}</span>
#     {% endif %} ;;
#   }

#   # ==========================================================================
#   # 👷‍♀️ EXECUTION TEAM (INCENTRO)
#   # ==========================================================================

#   dimension: incentro_owner {
#     label: "Incentro Engineer"
#     description: "The engineer responsible for the migration work"
#     group_label: "Execution Team"
#     type: string
#     sql: ${TABLE}.Incentro_Owner ;;
#     drill_fields: [real_file_name, current_pipeline_stage, status_uat]
#   }

#   dimension: file_sent_to_incentro {
#     label: "Handover to Incentro?"
#     group_label: "Execution Team"
#     type: yesno
#     sql: ${TABLE}.File_Sent_to_Incentro ;;
#   }

#   # ==========================================================================
#   # 🚦 SEQUENTIAL PIPELINE STAGES
#   # ==========================================================================

#   dimension: status_analyzed {
#     label: "1. Analysis"
#     group_label: "Stages"
#     type: string
#     sql: ${TABLE}.Analysed ;;
#     html: @{status_color_formatting} ;;
#   }

#   dimension: status_discovery {
#     label: "2. Discovery"
#     group_label: "Stages"
#     type: string
#     sql: ${TABLE}.Discovey___Defination ;;
#     html: @{status_color_formatting} ;;
#   }

#   dimension: status_build {
#     label: "3. Build"
#     group_label: "Stages"
#     type: string
#     sql: ${TABLE}.Build ;;
#     html: @{status_color_formatting} ;;
#   }

#   dimension: status_test {
#     label: "4. Test"
#     group_label: "Stages"
#     type: string
#     sql: ${TABLE}.Test ;;
#     html: @{status_color_formatting} ;;
#   }

#   dimension: status_uat {
#     label: "5. UAT"
#     group_label: "Stages"
#     type: string
#     sql: ${TABLE}.UAT ;;
#     html: @{status_color_formatting} ;;
#   }

#   # ==========================================================================
#   # 🧠 LOGIC: STAGE & HEALTH CALCULATIONS
#   # ==========================================================================

#   dimension: current_pipeline_stage {
#     label: "Current Stage"
#     description: "The active stage where the file is currently sitting."
#     type: string
#     sql:
#       CASE
#         WHEN LOWER(${status_uat}) = 'completed' THEN '6. Done'
#         WHEN LOWER(${status_uat}) IS NOT NULL THEN '5. UAT'
#         WHEN LOWER(${status_test}) IS NOT NULL THEN '4. Test'
#         WHEN LOWER(${status_build}) IS NOT NULL THEN '3. Build'
#         WHEN LOWER(${status_discovery}) IS NOT NULL THEN '2. Discovery'
#         WHEN LOWER(${status_analyzed}) IS NOT NULL THEN '1. Analysis'
#         ELSE '0. Backlog'
#       END ;;
#     order_by_field: stage_sort_order
#   }

#   dimension: stage_sort_order {
#     hidden: yes
#     type: number
#     sql:
#       CASE
#         WHEN ${current_pipeline_stage} = '6. Done' THEN 7
#         WHEN ${current_pipeline_stage} = '5. UAT' THEN 6
#         WHEN ${current_pipeline_stage} = '4. Test' THEN 5
#         WHEN ${current_pipeline_stage} = '3. Build' THEN 4
#         WHEN ${current_pipeline_stage} = '2. Discovery' THEN 3
#         WHEN ${current_pipeline_stage} = '1. Analysis' THEN 2
#         ELSE 1
#       END ;;
#   }

#   dimension: overall_health {
#     label: "Health Status"
#     type: string
#     sql:
#       CASE
#         WHEN LOWER(${status_uat}) = 'completed' THEN 'Completed'
#         WHEN LOWER(${status_build}) LIKE '%stuck%' OR LOWER(${status_test}) LIKE '%stuck%' OR LOWER(${status_uat}) LIKE '%stuck%' THEN 'At Risk'
#         WHEN ${current_pipeline_stage} = '0. Backlog' THEN 'Not Started'
#         ELSE 'On Track'
#       END ;;
#     html:
#     {% if value == 'Completed' %} <span style="color: white; background-color: #137333; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
#     {% elsif value == 'At Risk' %} <span style="color: white; background-color: #d93025; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
#     {% elsif value == 'On Track' %} <span style="color: white; background-color: #1A73E8; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
#     {% else %} <span style="color: black; background-color: #F9AB00; padding: 3px 8px; border-radius: 4px;">{{ value }}</span>
#     {% endif %} ;;
#   }

#   dimension: risk_reason {
#     label: "Risk Reason"
#     description: "Derived reason for why a file is stuck or at risk"
#     type: string
#     sql:
#       CASE
#         WHEN LOWER(${status_build}) LIKE '%stuck%' THEN 'Build Blocked'
#         WHEN LOWER(${status_test}) LIKE '%stuck%' THEN 'Testing Blocked'
#         WHEN LOWER(${status_uat}) LIKE '%stuck%' THEN 'UAT Blocked'
#         ELSE NULL
#       END ;;
#   }

#   # ==========================================================================
#   # 🔢 METRICS & KPIs
#   # ==========================================================================

#   measure: count {
#     label: "Total Files"
#     type: count
#     drill_fields: [file_details*]
#   }

#   measure: count_completed {
#     label: "Files Completed"
#     type: count
#     filters: [status_uat: "Completed"]
#     drill_fields: [file_details*]
#   }

#   measure: percent_completion {
#     label: "% Completion"
#     type: number
#     value_format_name: percent_1
#     sql: 1.0 * ${count_completed} / NULLIF(${count}, 0) ;;
#     drill_fields: [file_details*]
#   }

#   measure: count_stuck {
#     label: "⚠️ Blocked Files"
#     type: sum
#     sql:
#       CASE
#         WHEN LOWER(${status_build}) LIKE '%stuck%' THEN 1
#         WHEN LOWER(${status_test}) LIKE '%stuck%' THEN 1
#         WHEN LOWER(${status_uat}) LIKE '%stuck%' THEN 1
#         ELSE 0
#       END ;;
#     drill_fields: [file_details*, risk_reason]
#   }

#   measure: count_active_wip {
#     label: "Active WIP"
#     description: "Files currently being worked on (Not Backlog, Not Done)"
#     type: count
#     filters: [current_pipeline_stage: "-0. Backlog, -6. Done"]
#     drill_fields: [file_details*]
#   }

#   measure: count_high_priority_active {
#     label: "Active High Priority"
#     description: "High Priority files currently in progress"
#     type: count
#     filters: [priority: "High", current_pipeline_stage: "-0. Backlog, -6. Done"]
#     drill_fields: [file_details*]
#   }

#   # --- Operational Gap Metrics ---

#   measure: count_unassigned_active {
#     label: "🚨 Orphaned Files (Active & Unassigned)"
#     description: "Files that have started but have NO Incentro Owner assigned."
#     type: count
#     filters: [current_pipeline_stage: "-0. Backlog, -6. Done", incentro_owner: "null"]
#     drill_fields: [real_file_name, department, current_pipeline_stage]
#   }

#   measure: risk_density {
#     label: "Risk Density %"
#     description: "Percentage of Active WIP files that are currently Stuck. Higher is worse."
#     type: number
#     value_format_name: percent_1
#     sql: 1.0 * ${count_stuck} / NULLIF(${count_active_wip}, 0) ;;
#     drill_fields: [department, count_stuck, count_active_wip]
#   }

#   # --- Productivity Metrics ---

#   measure: engineer_velocity {
#     label: "Avg Files per Engineer"
#     type: number
#     value_format_name: decimal_1
#     sql: 1.0 * ${count_active_wip} / NULLIF(COUNT(DISTINCT ${incentro_owner}), 0) ;;
#     drill_fields: [file_details*]
#   }

#   # --- Funnel Metrics ---
#   measure: funnel_1_analyzed { group_label: "Funnel" type: count filters: [status_analyzed: "Completed"] }
#   measure: funnel_2_discovery { group_label: "Funnel" type: count filters: [status_discovery: "Completed"] }
#   measure: funnel_3_build { group_label: "Funnel" type: count filters: [status_build: "Completed"] }
#   measure: funnel_4_test { group_label: "Funnel" type: count filters: [status_test: "Completed"] }
#   measure: funnel_5_uat { group_label: "Funnel" type: count filters: [status_uat: "Completed"] }

#   # ==========================================================================
#   # 📦 DRILL SETS
#   # ==========================================================================

#   set: file_details {
#     fields: [
#       real_file_name,
#       department,
#       priority,
#       tshirt_size,
#       lidl_file_owner,
#       incentro_owner,
#       current_pipeline_stage,
#       risk_reason,
#       overall_health
#     ]
#   }
# }


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
    sql: ${TABLE}.File_Sent_to_Incentro ;;
  }

  # ==========================================================================
  # 🚦 SEQUENTIAL PIPELINE STAGES
  # ==========================================================================

  dimension: status_analyzed {
    label: "1. Analysis"
    group_label: "Stages"
    type: string
    sql: ${TABLE}.Analysed ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_discovery {
    label: "2. Discovery"
    group_label: "Stages"
    type: string
    sql: ${TABLE}.Discovey___Defination ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_build {
    label: "3. Build"
    group_label: "Stages"
    type: string
    sql: ${TABLE}.Build ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_test {
    label: "4. Test"
    group_label: "Stages"
    type: string
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
    type: string
    sql:
      CASE
        WHEN LOWER(${status_uat}) = 'completed' THEN '6. Handover Complete'
        WHEN LOWER(${status_test}) = 'completed' THEN '5. Client UAT (Pending)'
        WHEN LOWER(${status_test}) IS NOT NULL THEN '4. Test'
        WHEN LOWER(${status_build}) IS NOT NULL THEN '3. Build'
        WHEN LOWER(${status_discovery}) IS NOT NULL THEN '2. Discovery'
        WHEN LOWER(${status_analyzed}) IS NOT NULL THEN '1. Analysis'
        ELSE '0. Backlog'
      END ;;
    order_by_field: stage_sort_order
  }

  dimension: stage_sort_order {
    hidden: yes
    type: number
    sql:
      CASE
        WHEN ${current_pipeline_stage} = '6. Handover Complete' THEN 7
        WHEN ${current_pipeline_stage} = '5. Client UAT (Pending)' THEN 6
        WHEN ${current_pipeline_stage} = '4. Test' THEN 5
        WHEN ${current_pipeline_stage} = '3. Build' THEN 4
        WHEN ${current_pipeline_stage} = '2. Discovery' THEN 3
        WHEN ${current_pipeline_stage} = '1. Analysis' THEN 2
        ELSE 1
      END ;;
  }

  dimension: overall_health {
    label: "Health Status"
    type: string
    sql:
      CASE
        WHEN LOWER(${status_test}) = 'completed' THEN 'Completed'
        WHEN LOWER(${status_build}) LIKE '%stuck%' OR LOWER(${status_test}) LIKE '%stuck%' THEN 'At Risk'
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
        WHEN LOWER(${status_build}) LIKE '%stuck%' THEN 'Build Blocked'
        WHEN LOWER(${status_test}) LIKE '%stuck%' THEN 'Testing Blocked'
        ELSE NULL
      END ;;
  }

  # ==========================================================================
  # 📅 VELOCITY & PACE CALCULATIONS (UPDATED: EXCLUDING WEEKENDS)
  # ==========================================================================

  dimension: days_until_deadline {
    hidden: yes
    type: number
    description: "Working days until April 1, 2026 (Excludes Sat/Sun)"
    # Formula explanation:
    # 1. Calculate raw days diff.
    # 2. Subtract weekends by calculating total weeks * 2.
    sql:
      (DATE_DIFF(DATE('2026-04-01'), CURRENT_DATE(), DAY) + 1)
      - (FLOOR((DATE_DIFF(DATE('2026-04-01'), CURRENT_DATE(), DAY) + 1) / 7) * 2)
      - (CASE WHEN EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) = 1 THEN 1 ELSE 0 END)
      - (CASE WHEN EXTRACT(DAYOFWEEK FROM DATE('2026-04-01')) = 7 THEN 1 ELSE 0 END)
    ;;
  }

  # ==========================================================================
  # 📊 MEASURES
  # ==========================================================================

  measure: count {
    label: "Total Files"
    type: count
    drill_fields: [file_details*]
  }


### Measures ###

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

  dimension: is_stuck_anywhere {
    hidden: yes
    type: yesno
    sql: ${status_discovery} = 'Stuck'
      OR ${status_build} = 'Stuck'
      OR ${status_test} = 'Stuck' ;;
  }

  measure: total_files_stuck_any {
    label: "Total Files Stuck (Any Stage)"
    type: count
    filters: [is_stuck_anywhere: "yes"]
  }

  measure: total_files_stuck {
    view_label: "Execution Metrics"
    label: "Total Files Stuck"
    description: "Count of files that are 'stuck' in Discovery, Build, or Test stages"
    type: count
    # We use a SQL filter here because standard LookML filters use AND logic,
    # and we want to count the file if ANY of these stages are stuck.
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

  measure: percent_stagnation_safety {
    label: "% Stagnation Safety"
    type: number
    value_format_name: percent_1
    sql: ${count_pending_client_action} / NULLIF((${count_pending_client_action}+${count_dev_completed}), 0) ;;
  }

  measure: count_active_wip {
    label: "Active WIP"
    type: count
    filters: [current_pipeline_stage: "-0. Backlog, -5. Client UAT (Pending), -6. Handover Complete"]
    drill_fields: [file_details*]
  }

  measure: count_stuck {
    label: "Stagnation Alert"
    type: sum
    sql:
      CASE
        WHEN LOWER(${status_build}) LIKE '%stuck%' THEN 1
        WHEN LOWER(${status_test}) LIKE '%stuck%' THEN 1
        ELSE 0
      END ;;
    drill_fields: [file_details*, risk_reason]
  }

  measure: risk_density {
    label: "Risk Density %"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_stuck} / NULLIF(${count_active_wip}, 0) ;;
  }

  measure: count_unassigned_active {
    label: "Orphaned Files"
    type: count
    filters: [current_pipeline_stage: "-0. Backlog, -5. Client UAT (Pending), -6. Handover Complete", incentro_owner: "null"]
    drill_fields: [real_file_name, department, current_pipeline_stage]
  }

  measure: engineer_velocity {
    label: "Avg Files per Engineer"
    type: number
    value_format_name: decimal_1
    sql: 1.0 * ${count_active_wip} / NULLIF(COUNT(DISTINCT ${incentro_owner}), 0) ;;
  }

  measure: required_daily_velocity {
    label: "Required Daily Pace (Working Days)"
    description: "Dev Completions needed per WORKING day to hit April 1, 2026"
    type: number
    value_format_name: decimal_2
    sql: 1.0 * ${count_remaining_dev} / NULLIF(MAX(${days_until_deadline}), 0) ;;
    html:
    <div style="color:#1A73E8;">{{ rendered_value }} / Day </div> ;;
  }

  measure: count_build_completed {
    label: "Completed Builds"
    type: count
    filters: [status_build: "Completed"]
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
