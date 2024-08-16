include: "/views/*"
include: "/attributes/*.lkml"

explore: inventory_items {
  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: inventory_items.product_id = products.id ;;
  }

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: inventory_items.product_distribution_center_id = distribution_centers.id ;;
  }
  }
