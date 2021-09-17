view: drilling {
  extends: [base_orders]


### these drilling patterns work in embed
# note the /embed/ prefix in the url path


  measure: status_self {
    type: string
    sql: ${status} ;;
    # link: {label: "foo" url:"www.google.com"}
    html:
      <a href='/embed/dashboards-next/1676' target='_self' > Test </a>
      ;;
  }
  measure: status_blank {
    type: string
    sql: ${status} ;;
    # link: {label: "foo" url:"www.google.com"}
    html:
      <a href='/embed/dashboards-next/1676' target='_blank' > Test </a>
      ;;
  }

  measure: status_none {
    type: string
    sql: ${status} ;;
    # link: {label: "foo" url:"www.google.com"}
    html:
      <a href='/embed/dashboards-next/1676'> Test </a>
      ;;
  }

  measure: status_link {
    type: string
    sql: ${status} ;;
    # link: {label: "foo" url:"www.google.com"}
    link:{
      label:"/embed/dashboards-next/1676"
      url: "/embed/dashboards-next/1676"
    }
  }

  measure: status_linkedval {
    type: string
    sql: 'https://dcl.dev.looker.com/embed/dashboards-next/1676';;
    # link: {label: "foo" url:"www.google.com"}
    html:
    <a href='{{ linked_value }}'> Test </a>
    ;;
  }

  }
