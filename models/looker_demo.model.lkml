# Define the database connection to be used for this model.
connection: "@{CONNECTION}"

include: "/explores/inventory.explore.lkml"
include: "/explores/orders.explore.lkml"
include: "/explores/events.explore.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: demo_default_datagroup {
  sql_trigger: SELECT MAX(id) from order_items ;;
  max_cache_age: "1 hour"
}

persist_with: demo_default_datagroup
