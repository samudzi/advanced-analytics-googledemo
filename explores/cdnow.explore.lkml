include: "/views/CDNow/*.view"

explore: cdnow {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow transactions"
}

explore: cdnow_clusters {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow predictions"

  join: cdnow_clvpred {
    relationship: one_to_one
    type: inner
    sql_on: ${cdnow_clusters.id} = ${cdnow_clvpred.id} ;;
  }
}
