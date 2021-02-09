include: "/views/google_analytics/*.view"


explore: ga_clusters {
  view_label: "Advanced Analytics Accelerator"
  label: "GA predictions"

  join: ga_clvpred {
    relationship: one_to_one
    type: inner
    sql_on: ${ga_clusters.id} = ${ga_clvpred.id} ;;
  }
}
