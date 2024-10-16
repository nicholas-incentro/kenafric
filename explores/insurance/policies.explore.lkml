include: "/views/insurance/*"
include: "/attributes/*.lkml"

explore: policies {
  join: claims {
    type: left_outer
    relationship: many_to_one
    sql_on: ${policies.policy_id} = ${claims.policy_id} ;;
  }

  join: policy_holders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${policies.policy_holder_id} = ${policy_holders.policy_holder_id} ;;
  }
}
