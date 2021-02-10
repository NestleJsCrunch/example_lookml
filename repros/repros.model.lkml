connection: "@{alternate_connection}"
# connection: "thelook"

include: "/repros/*.view.lkml"                # include all views in the views/ folder in this project

### this is the primary explore to test ui bugs in explores
explore: uibugs {}
