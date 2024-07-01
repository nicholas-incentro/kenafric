# Define the database connection to be used for this model.
connection: "looker_demo"

include: "/explores/inventory.explore.lkml"
include: "/explores/orders.explore.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: kenafric_demo_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: kenafric_demo_default_datagroup
