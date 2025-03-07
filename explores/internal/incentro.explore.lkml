include: "/views/demo/*"
explore: customers {
  join: customer_xp {
    type: left_outer
    relationship: many_to_one
    sql_on: ${customer_xp.customer_id} = ${customers.customer_id} ;;
  }
  join: account_invoice {
    type: left_outer
    relationship: many_to_one
    sql_on: ${account_invoice.customer_id} = ${customers.customer_id} ;;
  }
  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_id}=${account_invoice.product_id} ;;
  }
  join: subscriptions {
    type: left_outer
    relationship: many_to_one
    sql_on: ${subscriptions.customer_id}=${customers.customer_id} ;;
  }
  join: billability {
    type: left_outer
    relationship: many_to_one
    sql_on: ${billability.customer_id} = ${customers.customer_id} ;;
  }
  join: aged_debtors {
    type: left_outer
    relationship: many_to_one
    sql_on: ${aged_debtors.customer_id} = ${customers.customer_id};;
  }
}
explore: cashflow {}
