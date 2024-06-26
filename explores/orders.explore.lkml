include: "/views/*"
include: "/attributes/*.lkml"

access_grant: view_pii_data {
  user_attribute: see_pii
  allowed_values: [ "yes" ]
}

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

  join: users {
  type: left_outer
  relationship: many_to_one
  sql_on: ${order_items.user_id} = ${users.id} ;;
  }
}
