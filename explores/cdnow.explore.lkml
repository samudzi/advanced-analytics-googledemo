include: "/views/CDNow/*.view"

explore: cdnow {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow transactions"
}

explore: cdnow_clusters {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow predictions"
  sql_always_where: ${cdnow.transaction_date} >= 'last 31 days' ;;


  join: cdnow_clvpred {
    relationship: one_to_one
    type: inner
    sql_on: ${cdnow_clusters.id} = ${cdnow_clvpred.id} ;;
  }

  join: cdnow {
    relationship: one_to_one
    type: left_outer
    sql_on: ${cdnow.id} = ${cdnow_clvpred.id} ;;

  }
}
