connection: "repro_bad_cte_gen"
include: "/repros/badctegen.view.lkml"

explore: basebad {
  join: badctegen1 {
    sql_on: ${basebad.lol} = ${badctegen1.lol} ;;
    type: inner
    relationship: one_to_many
  }
  join: badctegen2 {
    sql_on: ${badctegen2.lol} = ${badctegen1.lol} ;;
    type: inner
    relationship: many_to_one
  }
  join: hierarchy {
    from:badndt
    type: left_outer
    relationship: many_to_many
    sql_on: ${badctegen2.lol} = ${hierarchy.lol}
          and ${badctegen1.lol} = ${hierarchy.lol}
          and ${basebad.lol} = ${hierarchy.lol};;
  }
}


explore: bad_base {
  view_name: basebad
  join: badctegen1 {
    type: inner
    relationship: many_to_many
    sql_on: ${basebad.lol} = ${badctegen1.lol};;
  }
  join: badctegen2 {
    type: inner
    relationship: many_to_one
    sql_on: ${badctegen2.lol} = ${badctegen1.lol} ;;
    }
}
