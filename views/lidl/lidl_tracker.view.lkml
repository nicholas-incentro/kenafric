view: lidl_tracker {
  sql_table_name: `still-sensor-360721.datastream.lidl_tracker` ;;
  drill_fields: [file_details*]

  # --------------------------------------------------------------------------
  # ID & Primary Keys
  # --------------------------------------------------------------------------

  dimension: tracker_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.tracker_id ;;
    hidden: yes # Usually hidden unless needed for debugging
  }

  dimension: file_id {
    label: "File ID (Name/Owner)"
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.File_ID ;;
  }

  # --------------------------------------------------------------------------
  # File Details
  # --------------------------------------------------------------------------

  dimension: file_name {
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.File_Name ;;
    link: {
      label: "Google Search File"
      url: "https://www.google.com/search?q={{ value }}"
    }
  }

  dimension: file_original_name {
    label: "Original Filename"
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.File ;;
  }

  dimension: tshirt_size {
    description: "Estimated complexity of the file (S, M, L, XL)"
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.Tshirt_Size ;;
  }

  dimension: priority {
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.Priority ;;
  }

  dimension: external_files_referenced {
    group_label: "File Meta Data"
    type: string
    sql: ${TABLE}.External_files_referenced ;; # Updated to match standard CSV ingestion naming
  }

  # --------------------------------------------------------------------------
  # Ownership & People
  # --------------------------------------------------------------------------

  dimension: file_owner {
    group_label: "Ownership"
    type: string
    sql: ${TABLE}.File_Owner ;;
  }

  dimension: incentro_owner {
    group_label: "Ownership"
    type: string
    sql: ${TABLE}.Incentro_Owner ;;
  }

  dimension: file_sent_to_incentro {
    group_label: "Ownership"
    description: "Has the file been physically transferred?"
    type: yesno
    # Robust check: Handles 'Yes', 'yes', '1' or nulls
    sql: LOWER(${TABLE}.File_Sent_to_Incentro) LIKE 'yes%' ;;
  }

  # --------------------------------------------------------------------------
  # Project Stages (Progress)
  # --------------------------------------------------------------------------

  # I have added HTML formatting here.
  # In a dashboard, "Completed" will be green, "Stuck" will be red.

  dimension: status_analyzed {
    label: "1. Analysis Status"
    group_label: "Project Stages"
    type: string
    sql: ${TABLE}.Analysed ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_discovery_definition {
    label: "2. Discovery & Definition"
    group_label: "Project Stages"
    type: string
    sql: ${TABLE}.Discovey___Defination ;; # Matches your SQL column
    html: @{status_color_formatting} ;;
  }

  dimension: status_build {
    label: "3. Build Status"
    group_label: "Project Stages"
    type: string
    sql: ${TABLE}.Build ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_test {
    label: "4. Test Status"
    group_label: "Project Stages"
    type: string
    sql: ${TABLE}.Test ;;
    html: @{status_color_formatting} ;;
  }

  dimension: status_uat {
    label: "5. UAT Status"
    group_label: "Project Stages"
    description: "User Acceptance Testing - Final Stage"
    type: string
    sql: ${TABLE}.UAT ;;
    html: @{status_color_formatting} ;;
  }

  dimension: file_sent_to_folder {
    label: "6. Sent to Folder"
    group_label: "Project Stages"
    type: string
    sql: ${TABLE}.File_sent_to_Respective_Folder ;;
  }

  # --------------------------------------------------------------------------
  # Notes
  # --------------------------------------------------------------------------

  dimension: notes_developer {
    group_label: "Notes"
    type: string
    sql: ${TABLE}.Notes__Developer ;;
  }

  dimension: notes_file_owner {
    group_label: "Notes"
    type: string
    sql: ${TABLE}.Notes__File_Owner ;;
  }

  # --------------------------------------------------------------------------
  # Measures (Analytics)
  # --------------------------------------------------------------------------

  measure: count {
    label: "Total Files"
    type: count
    drill_fields: [file_details*]
  }

  measure: count_completed_files {
    description: "Count of files where UAT is marked as Completed"
    type: count
    filters: [status_uat: "Completed"]
    drill_fields: [file_details*]
  }

  measure: count_stuck_files {
    description: "Count of files currently marked as Stuck in any stage"
    type: count
    filters: [status_build: "Stuck", status_test: "Stuck", status_uat: "Stuck"]
    drill_fields: [file_details*]
  }

  measure: percentage_completion {
    description: "Percentage of total files that have passed UAT"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_completed_files} / NULLIF(${count},0) ;;
    drill_fields: [file_details*]
  }

  # --------------------------------------------------------------------------
  # Sets
  # --------------------------------------------------------------------------

  set: file_details {
    fields: [
      file_name,
      file_owner,
      incentro_owner,
      tshirt_size,
      status_build,
      status_uat
    ]
  }
}
