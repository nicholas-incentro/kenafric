connection: "@{CONNECTION}"

include: "/explores/lidl/progress.explore.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: demo_default_datagroup {
  sql_trigger: SELECT MAX(id) from order_items ;;
  max_cache_age: "1 hour"
}

persist_with: demo_default_datagroup
