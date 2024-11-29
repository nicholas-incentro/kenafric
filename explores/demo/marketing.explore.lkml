# include: "/views/*"
# include: "/attributes/*.lkml"

# access_grant: view_pii_data {
#   user_attribute: see_pii
#   allowed_values: [ "yes" ]
# }

# explore: events {
#   join: event_session_facts {
#     type: left_outer
#     sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
#     relationship: many_to_one
#   }
#   join: event_session_funnel {
#     type: left_outer
#     sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
#     relationship: many_to_one
#   }
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
