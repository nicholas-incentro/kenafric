# The name of this view in Looker is "Products"
view: products {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `@{PROJECT}.@{SCHEMA_NAME_1}.products` ;;

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    description: "Unique Identifier of the product"
    type: number
    sql: ${TABLE}.id ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Brand" in Explore.

  dimension: brand {
    description: "Name of the Brand"
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [name]
  }

  dimension: category {
    description: "Category Name"
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [brand]
  }

  dimension: cost {
    description: "Purchasing price"
    type: number
    sql: ${TABLE}.cost ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_cost {
    description: "sum of the cost/purchasing price"
    type: sum
    sql: ${cost} ;;  }
  measure: average_cost {
    description: "average cost"
    type: average
    sql: ${cost} ;;  }

  dimension: department {
    description: "name of the department"
    type: string
    sql: ${TABLE}.department ;;
    drill_fields: [category]
  }

  dimension: distribution_center_id {
    description: "unique identifier of the distribution center"
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    description: "name of the product"
    type: string
    sql: ${TABLE}.name ;;
    drill_fields: [order_items.id]
  }

  dimension: retail_price {
    description: "the price that a customer will pay when purchasing a product at a retail store"
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    description: "stock keeping unit"
    type: string
    sql: ${TABLE}.sku ;;
  }
  measure: count_products{
    description: "count of distinct products"
    type: count_distinct
    sql: ${TABLE}.id ;;
    drill_fields: [category,brand]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  name,
  distribution_centers.name,
  distribution_centers.id,
  inventory_items.count,
  order_items.count
  ]
  }

}
