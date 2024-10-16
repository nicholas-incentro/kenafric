# The name of this view in Looker is "Policy Holders"
view: policy_holders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `still-sensor-360721.insurance.policy_holders` ;;
  drill_fields: [policy_holder_id]

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: policy_holder_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.policy_holder_id ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date_of_birth {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_of_birth ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Home Location City" in Explore.

  dimension: home_location_city {
    type: string
    sql: ${TABLE}.home_location_city ;;
  }

  dimension: home_location_country {
    type: string
    sql: ${TABLE}.home_location_country ;;
  }

  dimension_group: join {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.join_date ;;
  }
  measure: count {
    type: count
    drill_fields: [policy_holder_id, policies.count]
  }
}
