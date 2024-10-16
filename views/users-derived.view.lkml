view: users_derived {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
        id as user_id,
        age,
        MAX(users.created) as most_recent_users
      FROM @{PROJECT}.@{SCHEMA_NAME_1}.users
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: id {
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id;;
  }

}
