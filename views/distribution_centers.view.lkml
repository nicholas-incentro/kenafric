# The name of this view in Looker is "Distribution Centers"
view: distribution_centers {

  sql_table_name: `still-sensor-360721.thelook_ecommerce.distribution_centers` ;;
  drill_fields: [id]


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Latitude" in Explore.

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
}
