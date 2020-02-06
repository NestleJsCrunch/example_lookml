connection: "thelook"

include: "/NDT_testing/*.view.lkml"                  # include all views in this project

########
# Define Explores
########


#source_report is aggregated by appearance/item/source/advertiser by publisher by origin/country/proxy/load_device
#It cannot be merged against stripe/container data.
explore: source_report_base {
  view_name:  ndt_orderstoextend
  }
