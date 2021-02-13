include: "/views/CDNow/*.view"

explore: cdnow {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow transactions"
}

explore: cdnow_clvpred {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow predictions"


  join: cdnow {
    relationship: one_to_one
    type: full_outer
    sql_on: ${cdnow.id} = ${cdnow_clvpred.id} ;;

  }
}
