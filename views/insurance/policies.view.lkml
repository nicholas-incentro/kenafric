# The name of this view in Looker is "Policies"
view: policies {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `still-sensor-360721.insurance.policies` ;;
  drill_fields: [policy_id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: policy_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.policy_id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Deductable" in Explore.

  dimension: deductable {
    type: string
    sql: ${TABLE}.deductable ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: effective {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.effective_date ;;
  }

  dimension_group: issue {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.issue_date ;;
  }

  dimension: policy_holder_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.policy_holder_id ;;
  }

  dimension: policy_type {
    type: string
    sql: ${TABLE}.policy_type ;;
  }

  dimension: premium {
    type: number
    sql: ${TABLE}.premium ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_premium {
    type: sum
    sql: ${premium} ;;
    value_format_name: formatted_number
  }

  measure: average_premium {
    type: average
    sql: ${premium} ;;
    value_format_name: formatted_number
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: sum_insured {
    type: number
    sql: ${TABLE}.sum_insured ;;
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

  dimension: vehicle_use {
    type: string
    sql: ${TABLE}.vehicle_use ;;
  }

  dimension: vehicle_year {
    type: number
    sql: ${TABLE}.vehicle_year ;;
  }

  measure: count_policies {
    type: count_distinct
    sql: ${policy_id} ;;
    drill_fields: [policy_id, policy_holders.policy_holder_id]
  }

  measure: loss_ratio {
    type: number
    sql: ${claims.total_claim_amount}/${total_premium} ;;
    value_format_name: decimal_2
  }


}
