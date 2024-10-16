# The name of this view in Looker is "Claims View"
view: claims_view {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `still-sensor-360721.insurance.claims_view` ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Claim Amount" in Explore.

  dimension: claim_amount {
    type: number
    sql: ${TABLE}.claim_amount ;;
    value_format_name: formatted_number
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_claim_amount {
    type: sum
    sql: ${claim_amount} ;;
    value_format_name: formatted_number
    }

  measure: average_claim_amount {
    type: average
    sql: ${claim_amount} ;;
    value_format_name: formatted_number}
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: claim_datetime {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.claim_datetime ;;
  }

  dimension: claim_id {
    type: string
    sql: ${TABLE}.claim_id ;;
  }

  dimension: incident_severity {
    type: string
    sql: ${TABLE}.incident_severity ;;
  }

  dimension: incident_type {
    type: string
    sql: ${TABLE}.incident_type ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: incident_location {
    type: location
    sql_longitude: ${longitude};;
    sql_latitude: ${latitude} ;;
    drill_fields: [vehicle_identification_number, vehicle_make, vehicle_model, policy_type, incident_severity, sum_insured, claim_amount]
  }

  dimension: policy_holder_id {
    type: string
    sql: ${TABLE}.policy_holder_id ;;
  }

  dimension: policy_id {
    type: string
    sql: ${TABLE}.policy_id ;;
  }

  dimension: policy_type {
    type: string
    sql: ${TABLE}.policy_type ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: sum_insured {
    type: number
    sql: ${TABLE}.sum_insured ;;
  }

  measure: total_sum_insured {
    type: sum
    sql: ${sum_insured} ;;
    value_format_name: formatted_number
    drill_fields:  [vehicle_identification_number, vehicle_make, vehicle_model, policy_type, incident_severity, sum_insured, claim_amount]
  }

  dimension: premium {
    type: number
    sql: ${TABLE}.premium ;;
  }

  measure: total_premium {
    type: sum
    sql: ${premium} ;;
    value_format_name: formatted_number
    drill_fields:  [vehicle_identification_number, vehicle_make, vehicle_model, policy_type, incident_severity, sum_insured, claim_amount]
  }

  dimension: vehicle_identification_number {
    type: string
    sql: ${TABLE}.vehicle_identification_number ;;
  }

  dimension: vehicle_make {
    type: string
    sql: ${TABLE}.vehicle_make ;;
  }

  dimension: vehicle_model {
    type: string
    sql: ${TABLE}.vehicle_model ;;
  }
  measure: total_caims {
    type: count_distinct
    sql: ${claim_id} ;;
    drill_fields:  [vehicle_identification_number, vehicle_make, vehicle_model, policy_type, incident_severity, sum_insured, claim_amount]
  }

  # measure: loss_ratio {
  #   type: number
  #   sql: ${total_claim_amount}/${total_premium} ;;
  # }
}
