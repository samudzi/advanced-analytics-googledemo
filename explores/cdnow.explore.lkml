include: "/views/CDNow/*.view"

explore: cdnow {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow Transactions"
}

explore: cdnow_clvpred {
  view_label: "Advanced Analytics Accelerator"
  label: "CDNow Predictions"


  join: cdnow {
    relationship: one_to_one
    type: full_outer
    sql_on: ${cdnow.id} = ${cdnow_clvpred.id} ;;

  }
}
