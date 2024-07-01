include: "/views/*"
explore: order_items {
  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${products.id} ;;
  }

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
  }
}
