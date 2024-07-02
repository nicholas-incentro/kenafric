# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `@{PROJECT}.@{SCHEMA_NAME_1}.users` ;;

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_age {
    type: sum
    sql: ${age} ;;  }
  measure: average_age {
    type: average
    sql: ${age} ;;  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [street_address]
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state]
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    required_access_grants: [view_pii_data]
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    required_access_grants: [view_pii_data]
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    required_access_grants: [view_pii_data]
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    hidden: yes
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    hidden: yes
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
    required_access_grants: [view_pii_data]
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
    required_access_grants: [view_pii_data]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }
  dimension: geopoint {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  measure: count_users {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  last_name,
  first_name,
  events.count,
  orders.count,
  order_items.count
  ]
  }

}
