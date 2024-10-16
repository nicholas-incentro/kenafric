# The name of this view in Looker is "Claims"
view: claims {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `still-sensor-360721.insurance.claims` ;;
  drill_fields: [claim_id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: claim_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.claim_id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Claim Amount" in Explore.

  dimension: claim_amount {
    type: number
    sql: ${TABLE}.claim_amount ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_claim_amount {
    type: sum
    sql: ${claim_amount} ;;  }
  measure: average_claim_amount {
    type: average
    sql: ${claim_amount} ;;  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: claim_datetime {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.claim_datetime ;;
  }

  dimension: driver_age {
    type: number
    sql: ${TABLE}.driver_age ;;
  }

  dimension_group: driver_license_issue {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.driver_license_issue_date ;;
  }

  dimension: driver_relationship_to_policy_holder {
    type: string
    sql: ${TABLE}.driver_relationship_to_policy_holder ;;
  }

  dimension: incident_location {
    type: string
    sql: ${TABLE}.incident_location ;;
  }

  dimension: incident_severity {
    type: string
    sql: ${TABLE}.incident_severity ;;
  }

  dimension: incident_type {
    type: string
    sql: ${TABLE}.incident_type ;;
  }

  dimension: policy_id {
    type: string
    sql: ${TABLE}.policy_id ;;
  }
  measure: count {
    type: count
    drill_fields: [claim_id, claims_view.count]
  }
}
