connection: "james_bigquery_oncallnotifs"

include: "/oncall_automation/*.view.lkml"                # include all views in the views/ folder in this project

explore: oncall_rotation_sheet {
}
