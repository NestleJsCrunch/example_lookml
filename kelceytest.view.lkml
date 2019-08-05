view: teams {
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: profile_id {
    type: number
    sql: ${TABLE}.profile_id ;;
  }
  dimension: product_edition_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_edition_id ;;
  }
  dimension: base_bounty {
    type: number
    sql: case when ${TABLE}.offers_bounties then ${TABLE}.base_bounty else 0 end ;;
  }
  dimension: base_bounty_bucket {
    type: tier
    style: integer
    sql: ${base_bounty} ;;
    tiers: [0, 1, 50, 51, 100]
  }
  dimension: parent_team_id {
    type: number
    sql: ${TABLE}.parent_team_id ;;
  }
  dimension: parent_or_self_team_id{
    type: number
    sql: case when ${teams.parent_team_id} is null then ${teams.id}
      else ${teams.parent_team_id}  end  ;;
  }
  dimension: only_cleared_hackers {
    type: yesno
    sql: ${TABLE}.only_cleared_hackers ;;
  }
  dimension: abuse {
    type: yesno
    sql: ${TABLE}.abuse ;;
  }
  dimension_group: created {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      raw,
      fiscal_year,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: churned {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      raw,
      year,
      quarter
    ]
    sql: ${TABLE}.churned_at ;;
  }
  dimension: created_quarter {
    sql: cast(EXTRACT(year FROM ${TABLE}.created_at) as varchar)
      ||
        ' - Q'
      ||
      cast(EXTRACT(quarter FROM ${TABLE}.created_at) as varchar)
       ;;
  }
  dimension: handle {
    case_sensitive: no
    sql: ${TABLE}.handle ;;
  }
  dimension: sample_child_handle {
    # this is fake to create a sample dashboard for sales
    case_sensitive: no
    sql: case when ${TABLE}.handle = 'vimeo' then 'sub_program1'
              when ${TABLE}.handle = 'cloverpos' then 'sub_program2'
              when ${TABLE}.handle = 'nextdoor' then 'sub_program3'
              else '' end
              ;;
  }
  dimension: sample_parent_handle {
    # this is fake to create a sample dashboard for sales
    case_sensitive: no
    sql: case when ${TABLE}.handle= 'vimeo' or
               ${TABLE}.handle = 'cloverpos' or
               ${TABLE}.handle = 'nextdoor' then 'Main_programA'
              else '' end
              ;;
  }
  dimension: create_reference_url {
    type: string
    sql: ${TABLE}.create_reference_url ;;
  }
  dimension: main_account_handle {
    # if there is a parent account, user that handle, else use own handle
    case_sensitive: no
    sql: case when ${parent_acct_by_h1_program.h1_team_handle} is not null then ${parent_acct_by_h1_program.h1_team_handle}
             when ${acct_by_h1_program.h1_team_handle} is not null then ${acct_by_h1_program.h1_team_handle}
              else ${TABLE}.handle end
              ;;
  }
  dimension: handle_format {
    case_sensitive: no
    sql: ${TABLE}.handle ;;
    html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
  }
  dimension: hide_bounty_amounts {
    type: yesno
    sql: ${TABLE}.hide_bounty_amounts ;;
  }
  dimension: internet_bug_bounty {
    type: yesno
    sql: ${TABLE}.internet_bug_bounty ;;
  }
  dimension: website {
    type: string
    sql: ${TABLE}.website ;;
  }
  dimension: scopes {
    type: yesno
    sql: ${TABLE}.scopes ;;
  }
  dimension: accepting_submissions {
    type: yesno
#     sql: case when  ${TABLE}.submission_state in ('disabled') then false else true end;;
    sql: ${TABLE}.submission_state = 'open';;
  }
  dimension: external_url {
    sql: ${TABLE}.external_url ;;
  }
  dimension: submission_state {
    sql: ${TABLE}.submission_state ;;
  }
  dimension: churned_or_disabled_submission {
    type: yesno
    sql: case when  ${TABLE}.submission_state in ('disabled') or ${churned_date} is not null then true else false end;;
#     sql: ${TABLE}.submission_state = 'open';;
  }
  dimension: policy_page_url {
    sql: case when ${handle} is not null then 'https://www.hackerone.com/' || teams.handle else null end ;;
  }
  dimension: payments_team_id {
    type: number
    sql: ${TABLE}.payments_team_id ;;
  }
  dimension: name {
    case_sensitive: no
    sql: ${TABLE}.name ;;
  }
  dimension: offers_bounties {
    type: yesno
    sql: ${TABLE}.offers_bounties ;;
  }
  dimension: advertise_bounties {
    type: yesno
    sql: ${TABLE}.advertise_bounties ;;
  }
  dimension: anc_enabled {
    type: yesno
    sql: ${TABLE}.anc_enabled ;;
  }
  dimension: automatic_invites {
    type: yesno
    sql: ${TABLE}.automatic_invites ;;
  }
  dimension: singular_disclosure_disabled {
    type: yesno
    sql: ${TABLE}.singular_disclosure_disabled ;;
  }
  dimension: state {
    type: number
    sql: ${TABLE}.state ;;
  }
  dimension: state_text {
    sql: case when ${TABLE}.state = 2 then 'sandbox' when ${TABLE}.state = 4 then 'private' when ${TABLE}.state = 5 then 'public' else null end ;;
  }
  dimension: team_logo {
    html:
      {%  if value == 'htaf2' %}
      <img src="https://profile-photos.hackerone-user-content.com/production/000/024/514/f37b84e716fadd808430a05f66c7af3e8b00c9a5_xtralarge.png" width="90" height="90"/></p>
      {% endif %}
 ;;
    sql: ${TABLE}.handle ;;
  }
  filter: team_peer_filter {
    suggest_dimension: teams.handle
  }
  dimension: team_comparitor {
    sql: CASE
      WHEN {% condition team_peer_filter %} ${teams.handle} {% endcondition %}
        THEN ${teams.handle}
      ELSE 'Rest of Population'
       END
       ;;
  }
  dimension: today_is_first {
    type: yesno
    sql: extract(day from NOW()) = 1
      ;;
  }
  dimension_group: Current_date_group {
    type: time
    timeframes: [date, week, month, year, quarter]
    sql:  NOW()
      ;;
  }
  dimension: google_play {
    type: yesno
    sql: ${TABLE}.google_play
      ;;
  }
  dimension: new_staleness_threshold_days {
    type: number
    sql:  (${TABLE}.new_staleness_threshold)/86400 ;;
  }
  dimension: new_staleness_threshold_hrs {
    type: number
    sql:  (${TABLE}.new_staleness_threshold)/3600 ;;
  }
  measure: new_staleness_threshold_hrs_val {
    type: min
    sql:  ${new_staleness_threshold_hrs} ;;
  }
  dimension: triaged_staleness_threshold_days {
    type: number
    sql:  ${TABLE}.triaged_staleness_threshold/86400::int ;;
  }
  dimension: bounty_awarded_staleness_threshold_days {
    type: number
    sql:  ${TABLE}.bounty_awarded_staleness_threshold/86400::int ;;
  }
  dimension: resolved_staleness_threshold_days {
    type: number
    sql:  ${TABLE}.resolved_staleness_threshold/86400::int ;;
  }
  dimension: last_day_of_month {
    type: yesno
    sql: extract(day from CURRENT_DATE + INTERVAL '1 day')  = 1
      ;;
  }
  dimension: target_signal {
    type: number
    sql: ${TABLE}.target_signal ;;
  }
  dimension: policy {
    sql: ${TABLE}.policy ;;
  }
  dimension: pretty_policy {
    sql: ${TABLE}.policy ;;
    html: <pre style="font-family: inherit;">{{ value }}</pre>
      ;;
  }
  dimension_group: review_requested_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.review_requested_at ;;
  }
  dimension: hours_from_review_requested_at {
    type: number
    sql: (EXTRACT(EPOCH FROM now() - ${TABLE}.review_requested_at)/3600)::Integer ;;
  }
  dimension_group: review_rejected_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.review_rejected_at ;;
  }
  dimension_group: became_invitation_only {
    type: time
    timeframes: [date, week, month, year, quarter]
    sql: (SELECT min(date(tsc.changed_at))
      FROM team_state_changes tsc
      WHERE tsc.team_id = ${TABLE}.id
      AND tsc.state = 'soft_launched')
       ;;
  }
  dimension_group: became_public {
    type: time
    timeframes: [date, week, month, year, quarter]
    sql: (SELECT min(date(tsc.changed_at))
      FROM team_state_changes tsc
      WHERE tsc.team_id = ${TABLE}.id
      AND tsc.state = 'public_mode')
       ;;
  }
  dimension: days_between_invitation_only_and_public {
    type: number
    sql: ${became_public_date}::date - ${became_invitation_only_date}::date ;;
  }
  dimension_group: controlled_launch_opt_out {
    type: time
    timeframes: [date, week, month, year, quarter]
    sql:  ${TABLE}.controlled_launch_opt_out_at;;
  }
  dimension: allow_email_and_automatic_invitations {
    type: yesno
    sql: ${TABLE}.allow_email_and_automatic_invitations;;
  }
  dimension: allow_all_hacker_invitations {
    type: yesno
    sql: ${TABLE}.allow_all_hacker_invitations;;
  }
  dimension: allows_private_disclosure {
    type: yesno
    sql: ${TABLE}.allows_private_disclosure;;
  }
  dimension: vpn_enabled {
    type: yesno
    sql: ${TABLE}.vpn_enabled;;
  }
  dimension: days_in_invitation_only {
    type: number
    sql: date_part('days', now() - ${became_invitation_only_date}) ;;
  }
  dimension: days_in_invitation_only_tier {
    type: tier
    sql: ${days_in_invitation_only} ;;
    tiers: [
      5,
      10,
      15,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360
    ]
  }
  dimension: special_event_hackathon_hackthestarprograms {
    type:  yesno
    sql:  teams.handle ilike ('%h1702%')
      or teams.handle ilike ('%h13120%')
      or teams.handle ilike ('%h1415%')
      or teams.handle ilike ('%h1-702%')
      or teams.handle ilike ('%h1-415%')
      or teams.handle ilike ('%hackthe%')
      or teams.handle ilike ('%htaf2%')
      or teams.handle ilike ('%hack_the_marine_corps%')
    ;;
  }
  dimension: special_event_type {
    type:  string
    sql:  case when     teams.handle ilike ('%h1702%')
      or teams.handle ilike ('%h13120%')
      or teams.handle ilike ('%h1415%')
      or teams.handle ilike ('%h1-415%')
      or teams.handle ilike ('%h1-30471')
      or teams.handle ilike ('%hack_the_marine_corps%')
      or teams.handle ilike ('%h1-702%') then 'hackathon'
      when teams.handle ilike ('%hackthe%')
      or teams.handle ilike ('%htaf2%') then 'DoD'
      else 'regular' end ;;
  }
  dimension: special_event_type_with_challenges {
    type:  string
    sql:  case when     teams.handle ilike ('%h1702%')
      or teams.handle ilike ('%h13120%')
      or teams.handle ilike ('%h1415%')
      or teams.handle ilike ('%h1-415%')
      or teams.handle ilike ('%h1-202%')
      or teams.handle ilike ('%h1-30471')
      or teams.handle ilike ('%hack_the_marine_corps%')
      or teams.handle ilike ('%h1-702%') then 'hackathon'
      when teams.handle ilike ('%h1c%') then 'challenge'
      when teams.handle ilike ('%hackthe%') then 'DoD'
      else 'regular' end ;;
  }
  dimension: days_public {
    type: number
    sql: date_part('days', now() - ${became_public_date}) ;;
  }
  dimension: days_public_tier {
    type: tier
    sql: ${days_public} ;;
    tiers: [
      5,
      10,
      15,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360,
      500
    ]
  }
  dimension: fully_launched_filter {
    type: number
    sql: case when ${teams.state} = 5 or (${teams.state} = 4 and  ${whitelisted_reporters_derived.whitelisted_reporters_count} > 0) then 1 else 0 end
      ;;
  }
  dimension: launched_handles {
    sql: CASE ${TABLE}.state WHEN 4 THEN ${TABLE}.handle WHEN 5 THEN ${TABLE}.handle END ;;
  }
  dimension: team_health_exception_team {
    type: yesno
    sql: case when ${handle}  in ( 'adobe','duo' ,'adobe_internal','uber-vip','airbnb-internal','concur','tripit','disclosure-assistance' ,'googleplay' , 'panasonic-aero' ,
        'project-sopris' ,'harley_davidson' ,'quip' ,'billmo' ,
        'irobot', 'intel' ,'cambium' ,'nakedapartments' , 'zillowgroup' ,'bridgeinteractive' , 'streeteasy' , 'retsly' ,'realestate' , 'premieragent' ,'mortech' ,'hotpads' ,'slack' ,'qualcomm' , 'twitter' , 'salesforce' ,'gm' ,
         'medchat_llc' , 'oportun' , 'adzerk' , 'malwarebytes' ,'assembla' , 'mapbox' , 'linkedin' , 'secureauth' , 'push_operations' , 'nintendo-pcsg' , 'epicgames' , 'masterclass' ,
          'mz' ,'teamstitch' ,'lendingclub' ,'eshares' , 'amino' ,'cargurus' , 'twine' ,'doordash' , 'postmates' ,  'yelp' ,'youporn' , 'glassdoor' ,'nintendo' , 'roblox' , 'camsoda' ,
              'sap-successfactors' ,'wavy-app' ,'pornhub' ,'vkcom' ,'mailru' ,'redtube' , 'lufthansa')
            then true else false end
       ;;
  }
#   dimension: teams_meets_adj_KPI1 {
#     type: number
# #     value_format_name: decimal_0
#     sql: case when ${reports.meets_adjusted_goal_triaged_resolved_l90d} = 1 then ${teams.id} end ;;
#   }
  measure: count_percent_of_previous {
    label: "Count (Percent Change)"
    type: percent_of_previous
    value_format_name: decimal_1
    sql: ${count} ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: count_distinct {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
  }
  #   - measure: amount_sum
  #     type: sum
  #     value_format_name: decimal_2
  #     value_format: "$#,##0.00"
  #     sql: ${bounties.amount}
  measure: cumulative_count {
    type: running_total
    sql: ${count} ;;
  }
  measure: goal_valid_reports {
    type: sum
    sql: ${TABLE}.goal_valid_reports ;;
  }
  dimension: goal_valid_reports_dim {
    type: number
    sql: ${TABLE}.goal_valid_reports ;;
  }
  measure: goal_vhc_reports {
    type: sum
    sql: ${TABLE}.goal_vhc_reports ;;
  }
  measure: goal_budget {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.goal_budget ;;
  }
  measure: goal_valid_reports_90d {
    type: sum
    sql: ${TABLE}.goal_valid_reports*3.0 ;;
  }
  measure: goal_vhc_reports_90d {
    type: sum
    sql: ${TABLE}.goal_vhc_reports*3.0 ;;
  }
  measure: goal_budget_90d {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.goal_budget *3.0;;
  }
  dimension: goal_valid_reports_90d_dim {
    type: number
    sql: ${TABLE}.goal_valid_reports*3.0 ;;
  }
  dimension: goal_adjusted_valid_reports_90d_dim {
    type: number
    sql: case when ${TABLE}.goal_valid_reports = 0 and ${TABLE}.submission_state = 'open' then 15
              when ${TABLE}.goal_valid_reports = 0 and ${TABLE}.submission_state = 'paused' then 0
              when ${TABLE}.goal_valid_reports > 17 and ${TABLE}.automatic_invites  then 15
            else ${TABLE}.goal_valid_reports*3.0 end
           ;;
  }
  measure: goal_adjusted_valid_reports_90d {
    type: sum
    sql: ${goal_adjusted_valid_reports_90d_dim} ;;
  }
  dimension: goal_vhc_reports_90d_dim {
    type: number
    sql: ${TABLE}.goal_vhc_reports*3.0 ;;
  }
  dimension: redacted_handle {
    type: yesno
    sql:  ${TABLE}.id = 31807  ;;
  }
  dimension: credentials_set_up {
    type: yesno
    sql:  ${TABLE}.credentials_set_up ;;
  }
  measure: private_bounty_programs_count {
    type: count_distinct
    sql: case when ${TABLE}.offers_bounties is true and ${TABLE}.state = 4 and ${TABLE}.churned_at is null then ${TABLE}.id else null end ;;
  }
  measure: private_disclosure_programs_count {
    type: count_distinct
    sql: case when ${TABLE}.allows_private_disclosure is true and ${TABLE}.state = 4 and ${TABLE}.churned_at is null then ${TABLE}.id else null end ;;
  }
  dimension: goal_budget_90d_dim {
    type: number
    value_format: "$#,##0"
    sql: ${TABLE}.goal_budget *3.0;;
  }
  measure: churned_teams {
    type: count_distinct
    sql: count(case when ${TABLE}.churned_at is not null then ${id} else  null end)]
      ;;
  }
  measure: automatic_invites_enabled_teams {
    type:  count_distinct
    sql:  case when ${TABLE}.automatic_invites is True then ${TABLE}.id else null end
      ;;
  }
  measure: automatic_invites_enabled_teams_accepting_submissions {
    type:  count_distinct
    sql:  case when (${TABLE}.automatic_invites is True and ${TABLE}.submission_state = 'open') then ${TABLE}.id else null end
      ;;
  }
  measure: automatic_invites_enabled_teams_accepting_submissions_offering_bounties {
    type:  count_distinct
    sql:  case when (${TABLE}.automatic_invites is True and ${TABLE}.submission_state = 'open' and ${TABLE}.offers_bounties is True) then ${TABLE}.id else null end
      ;;
  }
  measure: open_submission_state_teams_count {
    type: count_distinct
    sql: case when ${TABLE}.submission_state = 'open' then ${TABLE}.id else null end  ;;
  }
  measure: paused_submission_state_teams_count {
    type: count_distinct
    sql: case when ${TABLE}.submission_state = 'paused' then ${TABLE}.id else null end  ;;
  }
  measure: disabled_submission_state_teams_count {
    type: count_distinct
    sql: case when ${TABLE}.submission_state = 'disabled' then ${TABLE}.id else null end  ;;
  }
  measure: adjusted_new_staleness_threshold_from_default_teams {
    type: count_distinct
    sql:  case when ${new_staleness_threshold_days} > 1 or ${new_staleness_threshold_days} < 1 then ${TABLE}.id else null end;;
  }
  measure: adjusted_triaged_staleness_threshold_from_default_teams {
    type: count_distinct
    sql:  case when ${triaged_staleness_threshold_days} > 2 or ${triaged_staleness_threshold_days} < 2 then ${TABLE}.id else null end ;;
  }
  measure: adjusted_bounty_awarded_staleness_threshold_from_default_teams {
    type: count_distinct
    sql: case when ${bounty_awarded_staleness_threshold_days} > 30 or ${bounty_awarded_staleness_threshold_days} < 30 then ${TABLE}.id else null end  ;;
  }
  measure: adjusted_resolved_staleness_threshold_from_default_teams {
    type: count_distinct
    sql:  case when ${resolved_staleness_threshold_days} > 30 or ${resolved_staleness_threshold_days} < 30 then ${TABLE}.id else null end  ;;
  }
  dimension: customized_at_least_one_SLA_target_threshold {
    type: string
    sql:  case when (${TABLE}.new_staleness_threshold > 432000 or ${TABLE}.triaged_staleness_threshold > 1296000) then 'customized_extra_long_target'
        when (${TABLE}.new_staleness_threshold <> 86400 or ${TABLE}.triaged_staleness_threshold <> 172800 or ${TABLE}.resolved_staleness_threshold <> 2592000  or ${TABLE}.bounty_awarded_staleness_threshold <> 2592000) then 'customized_at_least_one_target'
        else 'kept_all_defaults' end  ;;
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [id, name, reports.count]
  }
}

view: reports {
  dimension: id {
    primary_key: yes
    type: number
    html: <a href="https://hackerone.com/reports/{{value}}" target="_blank" style="color:blue; font-weight: bold; "><u>{{ rendered_value }}</u></a>
      ;;
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    datatype: datetime
    timeframes: [
      time,
      date,
      week,
      month,
      month_name,
      month_num,
      year,
      raw,
      day_of_week,
      week_of_year,
      quarter,
      fiscal_year,
      hour
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: current_time {
    type: time
    datatype: datetime
    timeframes: [
      time,
      date,
      week,
      month,
      month_name,
      month_num,
      year,
      raw,
      day_of_week,
      quarter,
      fiscal_year,
      hour
    ]
    sql: now()::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PDT' ;;
  }

  dimension: current_hour{
    type: number
    sql:  EXTRACT(hour FROM now()::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PDT') ;;
  }

  dimension: quarter_abbreviation {
    # This will return Q1, Q2, Q3, or Q4
    type: string
    group_label: "created"
    sql: CASE WHEN ${created_month_num} <= 3 THEN 'Q1'
              WHEN ${created_month_num} <= 6 THEN 'Q2'
              WHEN ${created_month_num} <= 9 THEN 'Q3'
              WHEN ${created_month_num} <= 12 THEN 'Q4'
            END;;
  }

  dimension: quarter_abbreviation_resolved {
    # This will return Q1, Q2, Q3, or Q4
    type: string
    group_label: "resolved"
    sql: CASE WHEN ${resolved_at_month_num} <= 3 THEN 'Q1'
              WHEN ${resolved_at_month_num} <= 6 THEN 'Q2'
              WHEN ${resolved_at_month_num} <= 9 THEN 'Q3'
              WHEN ${resolved_at_month_num} <= 12 THEN 'Q4'
            END;;
  }

  dimension: first_program_response_at {
    sql: ${TABLE}.first_program_activity_at ;;
  }

  dimension: first_program_activity_id {
    type:  number
    sql: ${TABLE}.first_program_activity_id ;;
  }


  dimension: quarter {
    # concats together year and quarter abbreviation.
    type: string
    group_label: "created"
    sql: CONCAT(${created_year}, '-', ${quarter_abbreviation}) ;;
  }

  dimension: quarter_resolved {
    # concats together year and quarter abbreviation.
    type: string
    group_label: "resolved"
    sql: CONCAT(${resolved_at_year}, '-', ${quarter_abbreviation_resolved}) ;;
  }


  filter: timeframe_picker_create {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_create {
    label: " report created at"
    type: string
    sql:
    CASE
    WHEN {% condition timeframe_picker_create %} 'day' {% endcondition %} THEN ${reports.created_date}::varchar
    WHEN {% condition timeframe_picker_create %} 'week' {% endcondition %} THEN ${reports.created_week}
    WHEN {% condition timeframe_picker_create %} 'month' {% endcondition %} THEN ${reports.created_month}
    WHEN {% condition timeframe_picker_create %} 'quarter' {% endcondition %} THEN ${reports.quarter}::varchar
    WHEN {% condition timeframe_picker_create %} 'year' {% endcondition %} THEN ${reports.created_year}::varchar
  --    else ${reports.created_quarter}
    END ;;
  }

  filter: timeframe_picker_resolved {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_resolved {
    label: " report resolved at"
    type: string
    sql:
    CASE
    WHEN {% condition timeframe_picker_resolved %} 'day' {% endcondition %} THEN ${reports.resolved_at_date}::varchar
    WHEN {% condition timeframe_picker_resolved %} 'week' {% endcondition %} THEN ${reports.resolved_at_week}
    WHEN {% condition timeframe_picker_resolved %} 'month' {% endcondition %} THEN ${reports.resolved_at_month}
    WHEN {% condition timeframe_picker_resolved %} 'quarter' {% endcondition %} THEN ${reports.quarter_resolved}::varchar
    WHEN {% condition timeframe_picker_resolved %} 'year' {% endcondition %} THEN ${reports.resolved_at_year}::varchar
  --    else ${reports.created_quarter}
    END ;;
  }

  filter: timeframe_picker_awarded {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_awarded{
    label: " bounty awarded"
    type: string
    sql:
    CASE
    WHEN {% condition timeframe_picker_awarded %} 'day' {% endcondition %} THEN ${reports.bounty_awarded_at_date}::varchar
    WHEN {% condition timeframe_picker_awarded %} 'week' {% endcondition %} THEN ${reports.bounty_awarded_at_week}
    WHEN {% condition timeframe_picker_awarded %} 'month' {% endcondition %} THEN ${reports.bounty_awarded_at_month}
    WHEN {% condition timeframe_picker_awarded %} 'quarter' {% endcondition %} THEN ${reports.bounty_awarded_at_quarter}::varchar
    WHEN {% condition timeframe_picker_awarded %} 'year' {% endcondition %} THEN ${reports.bounty_awarded_at_year}::varchar
  --    else ${reports.created_quarter}
    END ;;
  }

#   # This will return Q1, Q2, Q3, or Q4
#   type: string
#   sql: CASE WHEN ${created_month_num} <= 3 THEN 'Q1'
#               WHEN ${created_month_num} <= 6 THEN 'Q2'
#               WHEN ${created_month_num} <= 9 THEN 'Q3'
#               WHEN ${created_month_num} <= 3 THEN 'Q4';;
# }
#
# dimension: proper_quarter {
#   # concats together year and quarter abbreviation.
#   type: string
#   sql: CONCAT(${created_year}, '-', ${quarter_abbreviation} ;;
# }
# This assumes that there is a dimension group "created" with the timeframes "year" and "month_num" already.
#
#
# group_label: created
#
# to put both of these new dimensions underneath the same dimension group. From there, you'll just call proper_quarter instead of quarter.
# Does that make sense?
#   dimension: dynamic_timeframe_view {
#     type: string
#     sql:
#     CASE
#     WHEN {% condition timeframe_picker_create %} 'day' {% endcondition %} THEN 'Day'
#     WHEN {% condition timeframe_picker_create %} 'week' {% endcondition %} THEN 'Week'
#     WHEN {% condition timeframe_picker_create %} 'month' {% endcondition %} THEN 'Month'
#     WHEN {% condition timeframe_picker_create %} 'quarter' {% endcondition %} THEN 'Quarter'
#     WHEN {% condition timeframe_picker_create %} 'year' {% endcondition %} THEN 'Year'
#     END ;;
#   }


  dimension: created_hour_pst {
    type: number
    sql: EXTRACT(hour FROM  ${TABLE}.created_at::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PST') ;;
  }

  dimension_group: created_pst {
    type: time
    timeframes: [
      time,
      day_of_week,
      month,
      year,
      date,
      week
    ]
    sql: ${TABLE}.created_at::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PST' ;;
  }

  #dimension_group: created_1 {
  #  type: time
  #  timeframes: [
  #    time,
  #    day_of_week,
  #    month,
  #    year,
  #    date,
  #    week
  #  ]
  #  sql: ${TABLE}.created_at::timestamp AT TIME ZONE 'UTC' ;;
  #}

  dimension: weekend_submissions_pst_including_early_monday_late_fri {
    case: {
      when: {
        sql: (${created_hour_pst} < 9 and ${created_pst_day_of_week} = 'Monday') or  (${created_pst_day_of_week} in ('Saturday','Sunday')) or (${created_hour_pst} > 17  and ${created_pst_day_of_week} = 'Friday') ;;
        label: "weekend"
      }

      when: {
        sql: (${created_hour_pst} >= 9 and ${created_pst_day_of_week} = 'Monday') or (${created_pst_day_of_week} in ('Tuesday','Wednesday','Thursday')) or (${created_hour_pst} <= 17  and ${created_pst_day_of_week} = 'Friday') ;;
        label: "weekday"
      }
    }
  }

  #EXTRACT(day FROM  reports.created_at::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PST')

  dimension: created_hour_pst_buckets {
    case: {
      when: {
        sql: ${created_hour_pst}  >= 9 and ${created_hour_pst}  <= 17 ;;
        label: "working hours"
      }

      when: {
        sql: ${created_hour_pst} < 9 ;;
        label: "before 9 AM"
      }

      when: {
        sql: ${created_hour_pst} > 17 ;;
        label: "after 5 PM"
      }
    }
  }

  dimension: created_hour_of_day {
    type: number
    sql: EXTRACT(hour FROM  ${TABLE}.created_at::timestamp AT TIME ZONE 'UTC') ;;
  }

  dimension: weekend_submissions_including_early_monday_late_fri {
    case: {
      when: {
        sql: (${created_hour_of_day}  < 9 and ${created_day_of_week}  = 'Monday') or  (${created_day_of_week}  in ('Saturday','Sunday')) or (${created_hour_of_day}  > 17  and ${created_day_of_week}  = 'Friday') ;;
        label: "weekend"
      }

      when: {
        sql: (${created_hour_of_day}   >= 9 and ${created_day_of_week}  = 'Monday') or (${created_day_of_week}  in ('Tuesday','Wednesday','Thursday')) or (${created_hour_of_day}  <= 17  and ${created_day_of_week}  = 'Friday') ;;
        label: "weekday"
      }
    }
  }

  #EXTRACT(day FROM  reports.created_at::timestamp AT TIME ZONE 'UTC' AT TIME ZONE 'PST')

  dimension: created_hour_buckets {
    case: {
      when: {
        sql: ${created_hour_of_day}   >= 9 and ${created_hour_of_day}  <= 17 ;;
        label: "working hours"
      }

      when: {
        sql: ${created_hour_of_day}  < 9 ;;
        label: "before 9 AM"
      }

      when: {
        sql: ${created_hour_of_day}   > 17 ;;
        label: "after 5 PM"
      }
    }
  }

#   dimension_group: min_created_at {
#     type: time
#     timeframes: [time, date]
#     sql: min(${TABLE}.created_at) ;;
#   }

  measure: minimum_created_at {
    type: time
    timeframes: [time, date]
    sql: min(${TABLE}.created_at) ;;
  }

  dimension: hacker_published {
    type: yesno
    sql: ${TABLE}.hacker_published ;;
  }

  dimension: imported {
    type: yesno
    sql: ${TABLE}.imported ;;
  }

  dimension_group: triaged_or_resolved_at {
    type: time
    timeframes: [time, date, week, month, quarter, year,fiscal_year]
#     sql: case when ${TABLE}.triaged_at is not null and ${reports.substate} in ('triaged', 'resolved') then ${TABLE}.triaged_at when ${TABLE}.triaged_at is null and ${reports.substate} = 'resolved' and reports.closed_at is not null then ${TABLE}.closed_at else null end ;;
    sql: case  when ${reports.substate} = 'resolved' and reports.closed_at is not null then ${TABLE}.closed_at
               when ${TABLE}.triaged_at is not null and ${reports.substate} in ('triaged') then ${TABLE}.triaged_at
                else null
                end ;;
  }

  dimension_group: resolved_at {
    type: time
    timeframes: [time, date, week, month, month_num, quarter, year, fiscal_year]
    sql: case when   ${reports.substate} = 'resolved' and reports.closed_at is not null then ${TABLE}.closed_at else null end ;;
  }

  measure: maximum_created_at {
    type: date
    sql: max(${TABLE}.created_at) ;;
  }

#   dimension: first_report {
#     type: yesno
#     sql: case when ${created_date} = ${minimum_created_at} then true
#       else false end;;
#   }

  dimension_group: disclosed {
    type: time
    timeframes: [time, date, week, month, year,fiscal_year]
    sql: ${TABLE}.disclosed_at ;;
  }

  measure: disclosed_reports_count {
    type: count_distinct
    sql: case when ${TABLE}.disclosed_at is not null then ${TABLE}.id else null end;;
  }

  dimension_group: triaged_at {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year,
      raw
    ]
    sql: ${TABLE}.triaged_at ;;
  }

  dimension_group: latest_public_activity_of_team_at {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year,
      raw
    ]
    sql: ${TABLE}.latest_public_activity_of_team_at ;;
  }

  dimension_group: closed_at {
    type: time
    timeframes: [
      time,
      date,
      fiscal_year,
      week,
      month,
      year,
      raw,
      quarter
    ]
    sql: ${TABLE}.closed_at ;;
  }

  dimension: created_at_days_since_invite {
    # the default value, could be excluded
    type: number
    sql: CASE WHEN ${reports.team_id} = ${whitelisted_reporters.team_id}
       AND  ${reports.reporter_id} = ${whitelisted_reporters.user_id}
       THEN ${reports.created_date} - ${whitelisted_reporters.created_date}
        ELSE NULL END
       ;;
  }

  dimension: created_at_days_since_invite_tier {
    type: tier
    style: integer
    sql: ${created_at_days_since_invite} ;;
    tiers: [
      0,
      2,
      6,
      13,
      30,
      60,
      90,
      120,
      150,
      180,
      360
    ]
  }

  dimension: created_at_days_since_invite_tier_month {
    type: tier
    style: integer
    sql: ${created_at_days_since_invite} ;;
    tiers: [
      0,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360
    ]
  }

#   dimension: created_at_by_hacker_tenure_years {
#     # the default value, could be excluded
#     type: number
#     sql: ceiling((${reports.created_date}::date - ${users.created_date}::date)/365)
# #        ;;
#   }

  dimension_group: created_at_by_hacker_joined {
    # the default value, could be excluded
    type: time
    timeframes: [
      month,
      year,
    ]
    sql: ${users.created_date}
      ;;
  }

  dimension: created_at_daysSinceFirstLaunch {
    # the default value, could be excluded
    type: number
    sql: ${reports.created_date} - ${first.launch_date} ;;
  }

  dimension: closed_at_daysSinceFirstLaunch {
    # the default value, could be excluded
    type: number
    sql: ${reports.closed_at_date} - ${first.launch_date} ;;
  }



  dimension: created_at_hoursSinceFirstLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql:
    case when (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first.launch_date}::timestamp)/3600.00)  > 0
      then (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first.launch_date}::timestamp)/3600.00) else null end ;;
  }

  dimension: created_at_hoursSinceFirstPrivateLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql:
    case when (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first_private.launch_date}::timestamp)/3600.00)  > 0
      then (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first_private.launch_date}::timestamp)/3600.00) else null end ;;
  }

  dimension: created_at_hoursSinceFirstPublicLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql:
    case when (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first_public.launch_date}::timestamp)/3600.00)  > 0
      then (EXTRACT(EPOCH FROM ${TABLE}.created_at::timestamp -${first_public.launch_date}::timestamp)/3600.00) else null end ;;
  }

  measure: first_report_created_at_hoursSinceFirstLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql: min(${created_at_hoursSinceFirstLaunch}) ;;
  }

  measure: first_report_created_at_hoursSinceFirstPrivateLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql: min(${created_at_hoursSinceFirstPrivateLaunch}) ;;
  }

  measure: first_report_created_at_hoursSinceFirstPublicLaunch {
    # the default value, could be excluded
    type: number
    value_format_name: decimal_1
    sql: min(${created_at_hoursSinceFirstPublicLaunch}) ;;
  }


  dimension: created_at_daysSinceFirst_private_Launch {
    # the default value, could be excluded
    type: number
    sql: ${reports.created_date} - ${first_private.launch_date} ;;
  }

  dimension: created_at_days_since_first_private_launch {
    type: number
    sql: FLOOR(${created_at_daysSinceFirst_private_Launch}) ;;
  }

  dimension: created_at_months_since_first_private_launch_month_tier {
    type: tier
    style: integer
    sql: ${created_at_days_since_first_private_launch} ;;
    tiers: [
      0,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360
    ]
  }

  dimension: created_at_months_since_first_private_launch_month {
    type: number
    sql: floor(${created_at_days_since_first_private_launch}/30) ;;
  }

  dimension: created_at_days_since_first_saas_sub_start {
    # the default value, could be excluded
    type: number
    sql: ${reports.created_date} - ${first_arr_by_year.min_sub_start_at} ;;
  }

#   dimension: created_at_days_since_first_private_launch {
#     type: number
#     sql: FLOOR(${created_at_daysSinceFirst_private_Launch}) ;;
#   }
#
  dimension: created_at_months_since_first_saas_sub_start {
    type: number
    sql: floor(${created_at_days_since_first_saas_sub_start}/30) ;;
  }

  dimension: created_at_months_since_first_launch {
    type: number
    sql: FLOOR(${created_at_daysSinceFirstLaunch}/(30)) ;;
  }

  dimension: created_at_quarters_since_first_launch {
    type: number
    sql: FLOOR(${created_at_daysSinceFirstLaunch}/(90)) ;;
  }

  dimension: closed_at_quarters_since_first_launch {
    type: number
    sql: FLOOR(${closed_at_daysSinceFirstLaunch}/(90)) ;;
  }


  dimension: created_at_years_since_first_launch {
    type: number
    sql: FLOOR(${created_at_daysSinceFirstLaunch}/(365)) ;;
  }

  dimension: created_at_months_since_first_public_launch {
    type: number
    sql: FLOOR(${created_at_daysSinceFirstPublicLaunch}/(30)) ;;
  }

  dimension: created_at_daysSinceFirstLaunch_tier_month {
    type: tier
    style: integer
    sql: ${created_at_daysSinceFirstLaunch} ;;
    tiers: [
      0,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360
    ]
  }

  dimension: created_at_daysSinceFirstLaunch_tier {
    type: tier
    style: integer
    sql: ${created_at_daysSinceFirstLaunch} ;;
    tiers: [
      0,
      6,
      13,
      30,
      60,
      90,
      120,
      150,
      180,
      360
    ]
  }

  dimension: created_at_daysSinceFirstPublicLaunch {
    # the default value, could be excluded
    type: number
    sql: ${reports.created_date} - ${first_public.launch_date} ;;
  }

  dimension: created_at_daysSinceFirstPublicLaunch_tier {
    type: tier
    style: integer
    sql: ${created_at_daysSinceFirstPublicLaunch} ;;
    tiers: [
      0,
      6,
      13,
      30,
      60,
      90,
      120,
      150,
      180,
      360
    ]
  }

  dimension: created_at_daysSinceFirstPublicLaunch_tier_month {
    type: tier
    style: integer
    sql: ${created_at_daysSinceFirstPublicLaunch} ;;
    tiers: [
      0,
      30,
      60,
      90,
      120,
      150,
      180,
      210,
      240,
      270,
      300,
      330,
      360
    ]
  }

  dimension: latest_disclosable_activity_at {
    sql: ${TABLE}.latest_disclosable_activity_at ;;
  }

  dimension_group: bounty_awarded_at {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      quarter,
      year,
      raw
    ]
    sql: ${TABLE}.bounty_awarded_at ;;
  }

  dimension_group: first_program_response_at {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year,
      raw
    ]
    sql: ${TABLE}.first_program_activity_at ;;
  }

  dimension_group: swag_awarded_at {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year,
      raw
    ]
    sql: ${TABLE}.swag_awarded_at ;;
  }

  dimension: disclosed {
    type: yesno
    sql: ${TABLE}.disclosed_at IS NOT NULL ;;
  }

  dimension: reporter_id {
    type: number
    sql: ${TABLE}.reporter_id ;;
  }

  dimension: external_bug_id {
    type: number
    sql: ${TABLE}.external_bug_id ;;
  }


  dimension: public_view {
    sql: ${TABLE}.public_view ;;
  }

  dimension: report_weakness_id {
    sql:  ${TABLE}.report_weakness_id ;;
  }

  dimension: weakness_id {
    sql: ${TABLE}.weakness_id ;;
  }

  dimension: assigned_to_type {
    type: string
    sql: ${TABLE}.assigned_to_type ;;
  }

  dimension: assigned_to_id {
    type: string
    sql: ${TABLE}.assigned_to_id ;;
  }

  dimension: ineligible_for_bounty {
    type: yesno
    sql: ${TABLE}.ineligible_for_bounty ;;
  }

  dimension: substate {
    sql: ${TABLE}.substate ;;
  }

  dimension: has_bounty_award{
    type:  yesno
    sql: CASE
      when ${bounty_awarded_at_date} is not null then true else false end;;
  }

  dimension: substate_group {
    sql: CASE
        when ${TABLE}.substate in ('resolved','triaged')  then '1.validated'
        when ${TABLE}.substate in ('not-applicable', 'spam','informative') then '2.invalid'
        when ${TABLE}.substate = 'duplicate' then '3.duplicate'
        when ${TABLE}.substate in (  'new','needs-more-info') then '4.new_or_needs_more_info'
        when ${TABLE}.substate in (  'pre-submission') then '5.pre-submission'
    else 'Other'
    END
    ;;
  }

  dimension: substate_group_2 {
    sql: CASE
        when ${TABLE}.substate in ('resolved','triaged')  then '1.resolved_triaged'
        when ${TABLE}.substate = 'duplicate' then '2.duplicate'
        when ${TABLE}.substate in (  'new','needs-more-info') then '3.new_or_needs_more_info'
        when ${TABLE}.substate in ('not-applicable', 'spam','informative') then '4.NA_spam_informative'
        when ${TABLE}.substate in (  'pre-submission') then '5.pre-submission'
    else 'Other'
    END
    ;;
  }

  dimension: clear_signal_or_noise {
    sql: CASE when (${TABLE}.state = 'closed' and
         ${TABLE}.substate = ('resolved')) then 'clear signal'
        when (${TABLE}.state = 'closed' and ${TABLE}.substate in ('not-applicable', 'spam','informative','duplicate')) then 'noise'
        else null
    END
    ;;
  }

  dimension: state {
    sql: ${TABLE}.state ;;
  }

  dimension: severity_rating {
    sql: ${TABLE}.severity_rating ;;

  }

  dimension: critical_submission_bypass  {
    type: yesno
    sql: ${TABLE}.critical_submission ;;
  }

  parameter: date_input {
    type: date     #creates a date select box for user input
  }

  dimension: created_3_months_before_or_after {
    type: string
    sql:
        CASE
          WHEN ${TABLE}.created_at BETWEEN (({% parameter date_input %}) - INTERVAL '3 months') AND {% parameter date_input %}
          THEN '3 Months Before'
          WHEN ${TABLE}.created_at BETWEEN {% parameter date_input %} AND (({% parameter date_input %}) + INTERVAL '3 months')
          THEN '3 Months After'
          END ;;
  }


  dimension: created_1_month_before_or_after {
    type: string
    sql:
        CASE
          WHEN ${TABLE}.created_at BETWEEN (({% parameter date_input %}) - INTERVAL '1 month') AND {% parameter date_input %}
          THEN '1 Month Before'
          WHEN ${TABLE}.created_at BETWEEN {% parameter date_input %} AND (({% parameter date_input %}) + INTERVAL '1 month')
          THEN '1 Month After'
          END ;;
  }




#
#   dimension: bounty_award_tier {
#     case: {
#       when: {
#         sql: ${bounties.amount} >= 1500 ;;
#         label: "critical(>=$1500)"
#       }
#
#       when: {
#         sql: ${bounties.amount}  >= 500 ;;
#         label: "high($500-$1499)"
#       }
#
#       when: {
#         sql: ${bounties.amount} >= 100 ;;
#         label: "medium($100-$499)"
#       }
#
#       when: {
#         sql: ${bounties.amount}  >=0 and ${bounties.amount}  <100 ;;
#         label: "less_than_$100"
#       }
#
#       when: {
#         sql: ${bounties.amount}  is null ;;
#         label: "none"
#       }
#     }
#   }


  dimension: severity_rating_case {
    case: {
      when: {
        sql: ${severity_rating} = 'critical' ;;
        label: "critical"
      }

      when: {
        sql: ${severity_rating} = 'high' ;;
        label: "high"
      }

      when: {
        sql: ${severity_rating} = 'medium' ;;
        label: "medium"
      }

      when: {
        sql: ${severity_rating} = 'low' ;;
        label: "low"
      }

      when: {
        sql: ${severity_rating} is null OR ${severity_rating} = 'none' ;;
        label: "none"
      }
    }
  }

  dimension: severity_order {
    type: string
    sql: case when ${TABLE}.severity_rating = 'low' then '4. low'
      when ${TABLE}.severity_rating = 'medium' then '3. medium'
      when ${TABLE}.severity_rating = 'high' then '2. high'
      when ${TABLE}.severity_rating = 'critical' then '1. critical'
      when ${TABLE}.severity_rating = 'none' then '5. none'
        else '5. none' end
       ;;
  }

  dimension: severity_group {
    type: string
    sql: case when ${reports.severity_rating} in ( 'critical' ,'high') then 'crit or high'
        else 'medium or lower' end
       ;;
  }

  dimension: bounty_paid_stage {
    case: {
      when: {
        sql: ${TABLE}.bounty_awarded_at <= ${TABLE}.triaged_at or (${TABLE}.bounty_awarded_at is not null and ${TABLE}.triaged_at is null and ${TABLE}.closed_at is null) ;;
        label: "before_triage"
      }

      when: {
        sql: ${TABLE}.bounty_awarded_at between ${TABLE}.triaged_at and ${TABLE}.closed_at or (${TABLE}.bounty_awarded_at > ${TABLE}.triaged_at and ${TABLE}.closed_at is null) or (reports.bounty_awarded_at < reports.closed_at and reports.triaged_at is null ) ;;
        label: "after_triage"
      }

      when: {
        sql: ${TABLE}.bounty_awarded_at >= ${TABLE}.closed_at ;;
        label: "after_resolution"
      }
    }
  }

  dimension: structured_scope_id {
    sql: ${TABLE}.structured_scope_id ;;
  }

  dimension: first_program_ {}

  dimension: timer_report_triage_elapsed_time {
    sql: ${TABLE}.timer_report_triage_elapsed_time ;;
    type: number
  }

  dimension_group: timer_report_triage_miss_at {
    sql: ${TABLE}.timer_report_triage_miss_at ;;
    type: time
  }

  dimension_group: timer_report_triage_fail_at {
    sql: ${TABLE}.timer_report_triage_fail_at ;;
    type: time
  }

  dimension: timer_bounty_awarded_elapsed_time {
    sql: ${TABLE}.timer_bounty_awarded_elapsed_time ;;
    type: number
  }

  dimension_group: timer_bounty_awarded_miss_at {
    sql: ${TABLE}.timer_bounty_awarded_miss_at ;;
    type: time
  }


  dimension: timer_report_resolved_elapsed_time {
    sql: ${TABLE}.timer_report_resolved_elapsed_time ;;
    type: number
  }

  dimension: timer_report_resolved_elapsed_day {
    sql: ${TABLE}.timer_report_resolved_elapsed_time/(60*60*24) ;;
    type: number
    value_format_name: decimal_1
  }

  dimension_group: timer_report_resolved_miss_at {
    sql: ${TABLE}.timer_report_resolved_miss_at ;;
    type: time
  }


  dimension: timer_first_program_response_elapsed_time {
    sql: ${TABLE}.timer_first_program_response_elapsed_time ;;
    type: number
  }

  dimension: timer_first_program_response_elapsed_time_bus_hrs {
    sql: ${TABLE}.timer_first_program_response_elapsed_time/3600 ;;
    type: number
  }
#   for  % of reports that meets platform SLA, denominator should be timer_first_program_response_fail_at is not null,
# if timer_first_program_response_fail_at is null then timer has not started, maybe pre-submission
#
  dimension: failed_first_program_response_SLA_5d_has_elapsed_time {
    type: yesno
    sql: case when ${TABLE}.timer_first_program_response_elapsed_time > 432000 then true
      else false end ;;
  }

  dimension: failed_first_program_response_SLA_5d_no_elapsed_timer{
    type: yesno
    sql: case when ${TABLE}.timer_first_program_response_elapsed_time is null and timer_first_program_response_fail_at < now() then true else false end ;;
  }

  dimension: failed_first_program_response_SLA_24_bus_hrs {
    type: yesno
    sql: case when ${TABLE}.timer_first_program_response_elapsed_time > 86400 then true
         when ${TABLE}.timer_first_program_response_elapsed_time is null and timer_first_program_response_fail_at < now() then true
      else false end ;;
  }

  dimension: failed_first_program_response_SLA_24_48_bus_hrs {
    type: yesno
    sql: case when ${h1_program__c.program_edition__c} ilike '%Ent%' and ${TABLE}.timer_first_program_response_elapsed_time > 86400 then true
            when ${h1_program__c.program_edition__c} ilike '%Pro%' and ${TABLE}.timer_first_program_response_elapsed_time > 172800 then true
         when  ${TABLE}.timer_first_program_response_elapsed_time is null and timer_first_program_response_fail_at < now() then true
      else false end ;;
  }



  dimension: failed_first_program_response_SLA_48_bus_hrs {
    type: yesno
    sql: case when ${TABLE}.timer_first_program_response_elapsed_time > 172800 then true
         when ${TABLE}.timer_first_program_response_elapsed_time is null and timer_first_program_response_fail_at < now() then true
      else false end ;;
  }

  dimension: failed_first_program_response_SLA_5d {
    type: yesno
    sql: case when ${TABLE}.timer_first_program_response_elapsed_time > 432000 then true
         when ${TABLE}.timer_first_program_response_elapsed_time is null and timer_first_program_response_fail_at < now() then true
      else false end ;;
  }


  dimension: failed_triage_SLA_10d {
    type: yesno
    sql: case when ${TABLE}.timer_report_triage_elapsed_time > 864000 then true
         when ${TABLE}.timer_report_triage_elapsed_time is null and timer_report_triage_fail_at < now() then true
      else false end ;;
  }

  dimension_group: timer_first_program_response_miss_at {
    sql: ${TABLE}.timer_first_program_response_miss_at ;;
    type: time
  }

  dimension_group: timer_first_program_response_fail_at {
    sql: ${TABLE}.timer_first_program_response_fail_at ;;
    type: time
  }


  dimension: assigned_to_triager {
    type: string
    sql: case
              when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=0 and ${current_hour} < 4 then 'Jeren_AlexA'
              when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Everton_Ed_Abdou_AlexA'
             when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Everton_Prash_Yasser_Yassine_AlexB'
             when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Everton_Ebrahim_Yassine_AlexB_Sandeep'
             when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Jaz_Rojan_Abdou'
               when ${current_time_day_of_week} = 'Monday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Jaz_Rojan_Jeren'
              when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=0 and ${current_hour} < 4 then  'Jeren_AlexA'
              when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Everton_Ed_Abdou_AlexA'
             when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Everton_Yassine_AlexB'
             when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Everton_Ebrahim_Yassine_AlexB_Sandeep'
             when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=16 and ${current_hour} < 20 then  'Jaz_Rojan_Abdou'
               when ${current_time_day_of_week} = 'Tuesday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Jaz_Rojan_Jeren'
              when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=0 and ${current_hour} < 4 then  'Jeren_AlexA'
              when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Everton_Ed_Abdou_AlexA'
             when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Everton_Yassine_AlexB'
             when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=12 and ${current_hour} < 16 then  'Everton_Ebrahim_Yassine_AlexB_Sandeep'
             when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Jaz_Rojan_Abdou'
               when ${current_time_day_of_week} = 'Wednesday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Jaz_Rojan_Jeren'
              when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=0 and ${current_hour} < 4 then  'Jeren_AlexA'
              when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Everton_Ed_Abdou_AlexA'
             when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=8 and ${current_hour} < 12 then  'Everton_Yassine_AlexB'
             when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Everton_Ebrahim_Yassine_AlexB_Sandeep'
             when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Rojan_Abdou'
               when ${current_time_day_of_week} = 'Thursday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Rojan_Jeren'
              when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=0 and ${current_hour} < 4 then  'Jeren_AlexA_Ed'
              when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Everton_Abdou_Prash_AlexA'
             when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Everton_Yassine_AlexB'
             when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Everton_Ebrahim_Yassine_AlexB_Sandeep'
             when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Abdou_Ebrahim_Rojan'
               when ${current_time_day_of_week} = 'Friday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Yasser_Jeren_Rojan'
              when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=0 and ${current_hour} < 4 then 'Yasser_Ed'
              when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Ed_Prash'
             when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Prash_Rojan_Ebrahim'
             when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Rojan_Sandeep_Ebrahim'
             when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Anyone_Working'
               when ${current_time_day_of_week} = 'Saturday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Yasser'
              when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=0 and ${current_hour} < 4 then 'Yasser_Jeren_Ed'
              when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=4 and ${current_hour} < 8 then 'Ed_Rojan_Prash'
             when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=8 and ${current_hour} < 12 then 'Prash_Rojan'
             when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=12 and ${current_hour} < 16 then 'Sandeep_Ebrahim'
             when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=16 and ${current_hour} < 20 then 'Jaz'
               when ${current_time_day_of_week} = 'Sunday' and ${current_hour} >=20 and ${current_hour} < 24 then 'Jaz_Jeren'
      else 'Anyone_Working' end ;;
  }

  measure: 50th_percentile_first_program_response_hrs_handle {
    type: percentile
    label: "median first response bus hrs"
    percentile: 50
    sql: ${timer_first_program_response_elapsed_time}/60.0/60.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: average_first_program_response_hrs_handle {
    type: average
    label: "average first response bus hrs"
    sql: ${timer_first_program_response_elapsed_time}/60.0/60.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }
# for IBM
  dimension: missing_resolved_SLA_1d{
    type: number
#     label: "missing_resolved_SLA_1_day"
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }
# for IBM
  dimension: missing_resolved_SLA_7d{
    type: number
#     label: "missing_resolved_SLA_1_day"
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0"
  }

  measure: missing_resolved_SLA_1d_crit_only{
    type: count_distinct
#     label: "missing_resolved_SLA_1_day"
    sql: case when  ${reports.severity_rating} = 'critical' and (${timer_report_resolved_elapsed_time}/60.0/60.0/24.0 )> 1 then ${id} else null end ;;
    value_format: "0"
  }

  measure: missing_resolved_SLA_7d_high_only{
    type: count_distinct
#     label: "missing_resolved_SLA_1_day"
    sql: case when ${reports.severity_rating} = 'high' and (${timer_report_resolved_elapsed_time}/60.0/60.0/24.0) > 7 then ${id} else null end ;;
  }

  measure: 5th_percentile_days_to_resolved{
    type: percentile
    label: "5th percentile bus days to resolved"
    percentile: 5
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }

  measure: 25th_percentile_days_to_resolved{
    type: percentile
    label: "25th percentile bus days to resolved"
    percentile: 25
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }
  measure: 50th_percentile_days_to_resolved{
    type: percentile
    label: "50th percentile bus days to resolved"
    percentile: 50
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }

  measure: 75th_percentile_days_to_resolved{
    type: percentile
    label: "75th percentile bus days to resolved"
    percentile: 75
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }

  measure: 90th_percentile_days_to_resolved{
    type: percentile
    label: "90th percentile bus days to resolved"
    percentile: 90
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }

  measure: 95th_percentile_days_to_resolved{
    type: percentile
    label: "95th percentile bus days to resolved"
    percentile: 95
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }

  measure: average_days_to_resolved{
    type: average
    label: "average bus days to resolved"
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0  ;;
    value_format: "0.0"
  }



  measure: 50th_percentile_first_program_response_crit_high_hrs_handle {
    type: percentile
    label: "median first response crit/high bus hrs"
    percentile: 50
    sql:case when ${reports.severity_rating} in ('critical','high') then  ${timer_first_program_response_elapsed_time}/60.0/60.0 else null end ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 50th_percentile_triage_hrs_handle {
    type: percentile
    label: "median triage bus hrs"
    percentile: 50
    sql: ${timer_report_triage_elapsed_time}/60.0/60.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 50th_percentile_triage_crit_high_hrs_handle {
    type: percentile
    label: "median triage crit/high bus hrs"
    percentile: 50
    sql:case when ${reports.severity_rating} in ('critical','high') then  ${timer_report_triage_elapsed_time}/60.0/60.0 else null end ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 50th_percentile_resolved_days_handle {
    type: percentile
    label: "median resolved bus days"
    percentile: 50
    sql: ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 50th_percentile_resolved_crit_high_days_handle {
    type: percentile
    label: "median resolved crit/high bus days"
    percentile: 50
    sql:case when ${reports.severity_rating} in ('critical','high') then  ${timer_report_resolved_elapsed_time}/60.0/60.0/24.0 else null end ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

# timer is from triage to bounty
  measure: 50th_percentile_bounty_hrs_handle {
    type: percentile
    label: "median bounty bus days"
    percentile: 50
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

# timer is from triage to bounty
  measure: 50th_percentile_bounty_days_handle_L90d {
    type: percentile
    label: "median triage to bounty L90d (bus days)"
    percentile: 50
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
    filters: {
      field: bounty_awarded_at_date
      value: "90 days"
    }
  }

# timer is from triage to bounty
  measure: 90th_percentile_bounty_days_handle_L90d {
    type: percentile
    label: "90th percentile bounty bus days L90d"
    percentile: 90
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
    filters: {
      field: bounty_awarded_at_date
      value: "90 days"
    }
  }

  measure: average_bounty_hrs_handle {
    type: average
    label: "average to bounty bus days"
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

  }

  measure: 50th_percentile_bounty_crit_high_hrs_handle {
    type: percentile
    label: "median bounty crit/high bus days"
    percentile: 50
    sql:case when ${reports.severity_rating} in ('critical','high') then  ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 else null end ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 5th_percentile_bounty_hrs_handle {
    type: percentile
    label: "5th percentile bounty bus days"
    percentile: 5
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }
  measure: 25th_percentile_bounty_hrs_handle {
    type: percentile
    label: "25th percentile bounty bus days"
    percentile: 25
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 95th_percentile_bounty_hrs_handle {
    type: percentile
    label: "95th percentile bounty bus days"
    percentile: 95
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 75th_percentile_bounty_hrs_handle {
    type: percentile
    label: "75th percentile bounty bus days"
    percentile: 75
    sql: ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: 75th_percentile_bounty_crit_high_hrs_handle {
    type: percentile
    label: "75th percentile bounty crit/high bus days"
    percentile: 75
    sql:case when ${reports.severity_rating} in ('critical','high') then  ${timer_bounty_awarded_elapsed_time}/60.0/60.0/24.0 else null end ;;
    value_format: "0.0"

    filters: {
      field: customer_filter
      value: "yes"
    }
  }

  measure: average_timer_report_triage_elapsed_time {
    type: average
    sql: ${TABLE}.timer_report_triage_elapsed_time ;;
  }

  measure: average_timer_first_program_response_elapsed_time {
    type: average
    sql: ${TABLE}.timer_first_program_response_elapsed_time ;;
  }

  measure: severity_rating_reports_count {
    type: count_distinct
    sql: case
        when ${severity_rating} in ('critical') then ${id}
        when ${severity_rating} in ('high') then ${id}
        when ${severity_rating} in ('medium') then ${id}
        when ${severity_rating} in ('low') then ${id}
        when ${severity_rating} in ('none') then ${id}
        else null
        end
       ;;
  }

  measure: reports_count_2016 {
    type: count_distinct
    sql: CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2016-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2016-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
       ;;
  }

  measure: reports_count_2017 {
    type: count_distinct
    sql: CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
       ;;
  }

  measure: reports_count_2018 {
    type: count_distinct
    description: "created in 2018"
    sql: CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2018-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2018-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${TABLE}.id
      ELSE NULL
      END
       ;;
  }

  measure: reports_count_2018_Q1 {
    type: count_distinct
    description: "created in 2018_Q1"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-01-01') AND (reports.created_at ) < (TIMESTAMP '2018-04-01'))))  then ${id} else null end ;;
  }

  measure: reports_count_2018_Q2 {
    type: count_distinct
    description: "created in 2018_Q2"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-04-01') AND (reports.created_at ) < (TIMESTAMP '2018-07-01'))))  then ${id} else null end ;;
  }
  measure: reports_count_2018_Q3 {
    type: count_distinct
    description: "created in 2018_Q3"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-07-01') AND (reports.created_at ) < (TIMESTAMP '2018-10-01'))))  then ${id} else null end ;;
  }
  measure: reports_count_2018_Q4 {
    type: count_distinct
    description: "created in 2018_Q4"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-10-01') AND (reports.created_at ) < (TIMESTAMP '2019-01-01'))))  then ${id} else null end ;;
  }

  measure: reports_count_2017_Q4 {
    type: count_distinct
    description: "created in 2017_Q4"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-10-01') AND (reports.created_at ) < (TIMESTAMP '2018-01-01'))))  then ${id} else null end ;;
  }

  measure: reports_count_2017_Q3 {
    type: count_distinct
    description: "created in 2017_Q3"
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-07-01') AND (reports.created_at ) < (TIMESTAMP '2017-10-01'))))  then ${id} else null end ;;
  }


  measure: resolved_or_triaged_2018_01 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-01-01') AND (reports.created_at ) < (TIMESTAMP '2018-02-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_02 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-02-01') AND (reports.created_at ) < (TIMESTAMP '2018-03-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_03 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-03-01') AND (reports.created_at ) < (TIMESTAMP '2018-04-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_04 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-04-01') AND (reports.created_at ) < (TIMESTAMP '2018-05-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_05 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-05-01') AND (reports.created_at ) < (TIMESTAMP '2018-06-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_06 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-06-01') AND (reports.created_at ) < (TIMESTAMP '2018-07-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_07 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-07-01') AND (reports.created_at ) < (TIMESTAMP '2018-08-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_08 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-08-01') AND (reports.created_at ) < (TIMESTAMP '2018-09-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_09 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-09-01') AND (reports.created_at ) < (TIMESTAMP '2018-10-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }

  measure: resolved_or_triaged_2018_10 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-10-01') AND (reports.created_at ) < (TIMESTAMP '2018-11-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_11 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-11-01') AND (reports.created_at ) < (TIMESTAMP '2018-12-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2018_12 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2018-12-01') AND (reports.created_at ) < (TIMESTAMP '2019-01-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }

  measure: resolved_or_triaged_2017_01 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-01-01') AND (reports.created_at ) < (TIMESTAMP '2017-02-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_02 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-02-01') AND (reports.created_at ) < (TIMESTAMP '2017-03-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_03 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-03-01') AND (reports.created_at ) < (TIMESTAMP '2017-04-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_04 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-04-01') AND (reports.created_at ) < (TIMESTAMP '2017-05-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_05 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-05-01') AND (reports.created_at ) < (TIMESTAMP '2017-06-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_06 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-06-01') AND (reports.created_at ) < (TIMESTAMP '2017-07-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_07 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-07-01') AND (reports.created_at ) < (TIMESTAMP '2017-08-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_08 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-08-01') AND (reports.created_at ) < (TIMESTAMP '2017-09-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_09 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-09-01') AND (reports.created_at ) < (TIMESTAMP '2017-10-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }

  measure: resolved_or_triaged_2017_10 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-10-01') AND (reports.created_at ) < (TIMESTAMP '2017-11-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_11 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-11-01') AND (reports.created_at ) < (TIMESTAMP '2017-12-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }
  measure: resolved_or_triaged_2017_12 {
    type: count_distinct
    sql: case when ((((reports.created_at ) >= (TIMESTAMP '2017-12-01') AND (reports.created_at ) < (TIMESTAMP '2018-01-01'))))   AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved') then ${id} else null end ;;
  }

  measure: triaged_or_resolved_reports_count_2018 {
    type: count_distinct
    description: "created in 2018"
    sql: CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2018-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2018-01-01' + (1 || ' year')::INTERVAL))))) and ${TABLE}.substate in ('triaged','resolved')
      THEN ${TABLE}.id
      ELSE NULL
      END
       ;;
  }



  measure: reports_count_2017_format {
    type: count_distinct
    sql: CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
       ;;
    html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
  }

  measure: count_distinct_participating_hackers {
    type: count_distinct
    sql: ${TABLE}.reporter_id ;;
  }

  measure: count_distinct_hackers_with_valid_reports {
    type: count_distinct
    sql: case when ${TABLE}.substate in ('resolved','triaged') then ${TABLE}.reporter_id else null end;;
  }

  measure: count_distinct_participating_hackers_2017 {
    type: count_distinct
    sql:CASE WHEN (((${TABLE}.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (${TABLE}.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
      then ${TABLE}.reporter_id end ;;
    html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
  }

  measure: count_distinct_participating_hackers_L90d {
    type: count_distinct
    sql:  ${TABLE}.reporter_id;;
    html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }

  dimension: pre_submission_review_state {
    type: string
    sql: ${TABLE}.pre_submission_review_state ;;
  }

  dimension: anc_pre_submission_rejected_reports {
    type: yesno
    sql: case when reports.pre_submission_review_state in ('pre-submission-rejected','pre-submission-pending') and reports.state = 'closed' then true end ;;
  }

  dimension: has_H1_triager_activity {
    type:  yesno
    sql: CASE WHEN ${first_activity_on_report_by_h1_triager.report_id}  is NULL THEN false
      ELSE true
      END
       ;;
  }

  dimension: h1_triaged_exceeds_2d_SLA {
    type:  yesno
    sql: CASE WHEN ${h1_triaged_exceeds_2day_sla.h1_triaged_exceeds_2d_SLA} = 'More Than 2d' then true
      ELSE false
      END
       ;;
  }


  dimension: report_has_weakness {
    type: string
    sql: case when ${TABLE}.report_weakness_id is null then 'no' else 'yes' end ;;
  }

  measure: all_time_bounty_eligible_reports {
    type: count_distinct
    sql: case when ${teams.offers_bounties} AND (${teams.state} IN (4,5)) AND (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) AND (${reports.substate} = 'triaged' OR reports.substate = 'resolved')
      then ${id} else null end
       ;;
  }

  measure: all_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: all_reports_bounty_eligible_count_mtd {
    sql: count(distinct case when (((reports.created_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (reports.created_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
       and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: severity_critical_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and ${severity_rating} = 'critical' and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: severity_high_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and ${severity_rating} = 'high' and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: severity_medium_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and ${severity_rating} = 'medium' and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: severity_low_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and ${severity_rating} = 'low' and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else  null end)
       ;;
  }

  measure: severity_none_reports_bounty_eligible_count_ytd {
    sql: count(distinct case when ((((reports.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND ((reports.created_at)) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))) AND date(reports.bounty_awarded_at) IS NULL and reports.substate in ('resolved','triaged')
        and  ( ${severity_rating} is null or ${severity_rating} = 'none') and (NOT COALESCE(${reports.ineligible_for_bounty}, FALSE)) then  ${id} else null  end)
       ;;
  }

  measure: snapshot_L90d_submits {
    type: number
    sql: count(distinct case when (reports.created_at <= snapshot_date_key.snapshot_date and  reports.created_at > (snapshot_date_key.snapshot_date -90))
                 then reports.id else null end )
       ;;
  }

  measure: weekly_snapshot_L90d_triage_or_resolved {
    type: number
    sql: count(distinct case when (reports.created_at <= key_date.date_key_week and  reports.created_at > (key_date.date_key_week -90) and reports.substate in ('triaged' ,'resolved'))
                 then reports.id else null end )
       ;;
  }

  measure: count_failed_first_program_response_SLA_5d_l90d {
    # all currently open reports that have no responses for more than 7 days
    type: count_distinct
#     sql:  CASE WHEN ${failed_first_program_response_SLA_5d} and (((reports.created_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)))
#        AND (reports.created_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)
#       + (90 || ' day')::INTERVAL)))))
#         THEN reports.id  ELSE NULL END ;;
    sql: case  when  ${failed_first_program_response_SLA_5d}  then reports.id else null end;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }

  measure: count_failed_first_program_response_SLA_24_48_l90d {
    # all currently open reports that have no responses for more than 7 days
    type: count_distinct
#     sql:  CASE WHEN ${failed_first_program_response_SLA_5d} and (((reports.created_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)))
#        AND (reports.created_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)
#       + (90 || ' day')::INTERVAL)))))
#         THEN reports.id  ELSE NULL END ;;
    sql: case  when  ${failed_first_program_response_SLA_24_48_bus_hrs}  then reports.id else null end;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }
  measure: count_failed_first_program_response_SLA_24_bushrs_l90d {
    # all currently open reports that have no responses for more than 7 days
    type: count_distinct
#     sql:  CASE WHEN ${failed_first_program_response_SLA_5d} and (((reports.created_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)))
#        AND (reports.created_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)
#       + (90 || ' day')::INTERVAL)))))
#         THEN reports.id  ELSE NULL END ;;
    sql: case  when  ${failed_first_program_response_SLA_24_bus_hrs}  then reports.id else null end;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }

  measure: count_failed_first_program_response_SLA_24_bushrs{
    # all currently open reports that have no responses for more than 7 days
    type: count_distinct
#     sql:  CASE WHEN ${failed_first_program_response_SLA_5d} and (((reports.created_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)))
#        AND (reports.created_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL)
#       + (90 || ' day')::INTERVAL)))))
#         THEN reports.id  ELSE NULL END ;;
    sql: case  when  ${failed_first_program_response_SLA_24_bus_hrs}  then reports.id else null end;;

  }


  measure: count_failed_triage_SLA_10d {
    # all currently open reports that have no responses for more than 7 days
    type: count_distinct
    sql: case  when  ${failed_triage_SLA_10d} then reports.id else null end;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }



  measure: failing_first_response_in_7d {
    type: number
    sql: count (distinct   case
                    when reports.created_at > snapshot_date_key.snapshot_date then null --'created_after-ss'
                    when ((reports.state = 'open' and reports.substate <> 'needs-more-info') or (reports.closed_at > snapshot_date_key.snapshot_date))
                           and (reports.first_program_activity_at is null or (first_program_activity_at > snapshot_date_key.snapshot_date))
                           and extract(epoch from snapshot_date_key.snapshot_date  - reports.created_at ) /86400 >= 7  then reports.id --'failed:no program act at ss, or closed after ss' -- reports never triaged and closed may bneed to add or r.substate = 'needs-more-info'
                    when reports.first_program_activity_at is not null and reports.first_program_activity_at <snapshot_date_key.snapshot_date
                            and reports.first_program_activity_at >= snapshot_date_key.snapshot_date -7
                            and extract(epoch from reports.first_program_activity_at  - reports.created_at ) /86400 >= 7 then reports.id --'failed:program act in  ss'
                         -- reports open, triaged  after snapshot date then snapshot - create >14d
                    when reports.first_program_activity_at is null and closed_at is not null
                          and reports.closed_at <= snapshot_date_key.snapshot_date  and reports.closed_at > snapshot_date_key.snapshot_date -7
                          and  extract(epoch from reports.closed_at  - reports.created_at ) /86400 >= 7 then reports.id --'failed:no_prgram act, closed in  ss'
                      else null end)
       ;;
  }

  measure: open_have_not_responded_in7d {
    # all currently open reports that have no responses for more than 7 days
    label: "# failed response in7d"
    type: count_distinct
    sql: case  when reports.state = 'open' and reports.first_program_activity_at is null
      and (reports.pre_submission_review_state  is null or reports.pre_submission_review_state = 'pre-submission-accepted') and ( extract(epoch from now() - reports.created_at ) /86400) >= 7 then reports.id end;;
  }

  measure: open_have_not_responded_in7d_format_cond {
    # all currently open reports that have no responses for more than 7 days
    label: "# needs first response (submitted > 7d ago)"
    type: count_distinct
    drill_fields: [users.username, id, teams.handle, reports.created_date, reports.first_program_activity_at,reports.state, reports.substate ]
    sql:  ${TABLE}.id;;
    #     sql: case  when reports.state = 'open' and reports.first_program_activity_at is null
#          and (reports.pre_submission_review_state  is null or reports.pre_submission_review_state = 'pre-submission-accepted')
#          and ( extract(epoch from now() - reports.created_at ) /86400) >= 7 then reports.id end;;
    html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% endif %}
          ;;
    filters: {
      field: reports.state
      value: "open"
    }
    filters: {
      field: reports.substate
      value: "new"
    }
    filters: {
      field: reports.first_program_response_at_date
      value: "NULL"
    }
    filters: {
      field: reports.created_date
      value: "before 7 days ago"
    }
  }


  measure: open_was_not_responded_in7d_format_cond {
    label: "# responded >7d (submitted in L90d)"
    type: count_distinct
    sql:  case  when  reports.first_program_activity_at is not null and ( extract(epoch from first_program_activity_at - reports.created_at ) /86400) >= 7 then reports.id end;;
    html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
          {% endif %}
          ;;
    filters: {
      field: reports.created_date
      value: "90 days"
    }
  }


  #wierd
  dimension: datefilter_option {
    type: string
    sql: 'one' ;;
    html:
         {% assign vartwo= "Date Range: " %}
         {% assign var=  _filters['reports.created_date'] %}
         {{ vartwo | append: var}}
 ;;
  }


  measure: open_fail_triage_in14d {
    type: count_distinct
    sql:  case  when reports.state = 'open'
          and reports.triaged_at is null  and ( extract(epoch from first_program_activity_at - reports.created_at ) /86400) < 7  and extract(epoch from now() - reports.created_at ) /86400 >= 14 then reports.id
                     -- when reports.state = 'open' and reports.triaged_at is not null and  extract(epoch from reports.first_triaged_at - reports.created_at ) /86400 <7  and extract(epoch from now() - reports.created_at ) /86400 >= 14then reports.id
                      end
                      ;;
  }

  measure: open_fail_triage_in14d_noNMI_format_cond {
    label: "# needs triage (submitted > 14d ago)"
    type: count_distinct
    drill_fields: [users.username, id,teams.handle, reports.created_date, reports.first_program_response_at_date,reports.state, reports.substate ]
    sql:  ${TABLE}.id;;
#     --case  when reports.state = 'open' and reports.triaged_at is null
#     --and ( extract(epoch from first_program_activity_at - reports.created_at ) /86400) < 7
#     --and extract(epoch from now() - reports.created_at ) /86400 >= 14 then reports.id
#     --                        end;;
    html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% endif %}
          ;;
    filters: {
      field: reports.state
      value: "open"
    }
    filters: {
      field: reports.substate
      value: "-needs-more-info"
    }
    filters: {
      field: reports.substate
      value: "new, pre-submission"
    }
    filters: {
      field: reports.triaged_at_date
      value: "NULL"
    }
    filters: {
      field: reports.first_program_response_at_date
      value: "-NULL"
    }
    filters: {
      field: reports.created_date
      value: "before 14 days ago"
    }
  }

  measure: open_fail_triage_in14d_format_cond {
    label: "# needs triage (incl NMI submitted > 14d ago)"
    type: count_distinct
    sql:  case  when reports.state = 'open' and reports.first_program_activity_at is not  null and reports.pre_submission_review_state  <> 'pre-submission-needs-more-info'
          and  reports.triaged_at is null and ( extract(epoch from first_program_activity_at - reports.created_at ) /86400) < 7
                and extract(epoch from now() - reports.created_at ) /86400 >= 14 then reports.id
                          --  when reports.state = 'open' and reports.triaged_at is not null and  extract(epoch from reports.first_triaged_at - reports.created_at ) /86400 <7  and extract(epoch from now() - reports.created_at ) /86400 >= 14then reports.id
                                        end;;
    html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
          {% endif %}
          ;;
  }

  measure: open_fail_bounty_in28d {
    type: count_distinct
    sql:  case when reports.state = 'open' and reports.bounty_awarded_at is null
                and reports.triaged_at is not null and   extract(epoch from now() - reports.created_at ) /86400 >= 28 then reports.id
                end ;;

    }
    measure: open_fail_bounty_in28d_format_cond {
      label: "# needs bounty (incl NMI, submitted > 28d ago)"
      type: count_distinct
      drill_fields: [users.username, id, reports.created_date, reports.state, reports.substate ]
      sql:  ${TABLE}.id;;
#     sql:  case when reports.state = 'open' and reports.bounty_awarded_at is null and teams.offers_bounties
#                 and reports.triaged_at is not null and   extract(epoch from now() - reports.created_at ) /86400 >= 28 then reports.id
#
#                 end ;;
      html: {% if value >= 5 %}
            <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
            {% else %}
            <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
            {% endif %}
            ;;
      filters: {
        field: reports.state
        value: "open"
      }
      filters: {
        field: teams.offers_bounties
        value: "yes"
      }

      filters: {
        field: reports.ineligible_for_bounty
        value: "no"
      }

      filters: {
        field: reports.bounty_awarded_at_date
        value: "NULL"
      }
      filters: {
        field: reports.triaged_at_date
        value: "-NULL"
      }
      filters: {
        field: reports.created_date
        value: "before 28 days ago"
      }
    }

    measure: open_fail_bounty_in28d_noNMI_format_cond {
      label: "# needs bounty (submitted > 28d ago)"
      type: count_distinct
      drill_fields: [users.username, id,teams.handle, teams.offers_bounties, reports.created_date, reports.first_program_response_at_date,reports.state, reports.substate ]
      sql:  ${TABLE}.id;;
#     sql:  case when reports.state = 'open' and reports.bounty_awarded_at is null and teams.offers_bounties
#                 and reports.triaged_at is not null and   extract(epoch from now() - reports.created_at ) /86400 >= 28 then reports.id
#                 end ;;
      html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% endif %}
          ;;

        filters: {
          field: reports.state
          value: "open"
        }
        filters: {
          field: reports.substate
          value: "-needs-more-info,-new"
        }

        filters: {
          field: teams.offers_bounties
          value: "yes"
        }

        filters: {
          field: reports.ineligible_for_bounty
          value: "no"
        }

        filters: {
          field: reports.bounty_awarded_at_date
          value: "NULL"
        }
        filters: {
          field: reports.triaged_at_date
          value: "-NULL"
        }
        filters: {
          field: reports.created_date
          value: "before 28 days ago"
        }
      }

      measure: open_NMI {
        type: count_distinct
        sql:  case when reports.substate = 'needs-more-info' and ((reports.created_at < (SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-28 || ' day')::INTERVAL)))) then reports.id  ;;
      }

      measure: open_NMI_format_cond {
        type: count_distinct
        label: "# open and NMI (submitted >28d ago)"
        drill_fields: [users.username, id,teams.handle,  reports.created_date, reports.first_program_response_at_date,reports.state, reports.substate ]

        sql:  ${TABLE}.id;;
        html: {% if value >= 5 %}
          <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% else %}
          <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"><a href: {{linked_value}} </a></p>
          {% endif %}
          ;;

          filters: {
            field: reports.substate
            value: "needs-more-info"
          }
          filters: {
            field: reports.created_date
            value: "before 28 days ago"
          }

        }

        measure: unresponsive {
          type: yesno
          sql: ${open_have_not_responded_in7d_format_cond} >=5 or
                      ${open_fail_triage_in14d_noNMI_format_cond} >=5 or
                      ${open_fail_bounty_in28d_noNMI_format_cond} >=5
                 ;;
        }

#                  when reports.state = 'open' and reports.triaged_at is null and  extract(epoch from reports.first_program_activity_at - reports.created_at ) /86400 <7  and extract(epoch from now() - reports.created_at ) /86400 >= 14then reports.id
# when reports.bounty_awarded_at is null and reports.state ='open' and
#               and coalesce((extract(epoch from now() - reports.triaged_at ) /86400) >= 14,extract(epoch from now() - reports.created_at ) /86400 >= 28)  then reports.id
#           case when reports.bounty_awarded_at is null and reports.state ='open'
#               and coalesce((extract(epoch from now() - reports.triaged_at ) /86400) >= 14,extract(epoch from now() - reports.created_at ) /86400 >= 28) then 1
#              else 0 end as open_failing_bounty_in28d

        measure: failing_triaged_in_14d {
          type: number
          sql: count (distinct     case
                    when reports.created_at > snapshot_date_key.snapshot_date then null --'created_after-ss'
                    when ((reports.state = 'open' and reports.substate <> 'needs-more-info') or (reports.closed_at > snapshot_date_key.snapshot_date))
                           and (reports.triaged_at is null or (reports.triaged_at > snapshot_date_key.snapshot_date))
                           and extract(epoch from snapshot_date_key.snapshot_date  - reports.created_at ) /86400 >= 14  then reports.id --'failed:no triaged at ss, or closed after ss' -- reports never triaged and closed may bneed to add or r.substate = 'needs-more-info'
                    when reports.triaged_at is not null and reports.triaged_at <snapshot_date_key.snapshot_date
                            and reports.triaged_at >= snapshot_date_key.snapshot_date -7
                            and extract(epoch from reports.triaged_at  - reports.created_at ) /86400 >= 14 then reports.id --'failed:triaged in  ss'
                         -- reports open, triaged  after snapshot date then snapshot - create >14d
                    when reports.triaged_at is null and reports.closed_at is not null
                          and reports.closed_at <= snapshot_date_key.snapshot_date  and reports.closed_at > snapshot_date_key.snapshot_date -7
                          and  extract(epoch from reports.closed_at  - reports.created_at ) /86400 >= 14 then reports.id --'failed:no_triaged, closed in  ss'
                      else null end)
       ;;
        }

        measure: failing_bounty_in_28d {
          type: number
          sql: count ( distinct case
                    when reports.created_at > snapshot_date_key.snapshot_date then null --'created_after-ss'
                    when ineligible_for_bounty = true or teams.offers_bounties = false then null --'inelible for bounty'
                    when ineligible_for_bounty = false and ((reports.state = 'open' and reports.substate <> 'needs-more-info') or (reports.closed_at > snapshot_date_key.snapshot_date))
                           and (reports.bounty_awarded_at is null or (reports.bounty_awarded_at > snapshot_date_key.snapshot_date))
                           and extract(epoch from snapshot_date_key.snapshot_date  - reports.created_at ) /86400 >= 28  then reports.id --'failed:no bounty at ss, or closed after ss' -- reports never triaged and closed may bneed to add or r.substate = 'needs-more-info'
                    when reports.bounty_awarded_at is not null and reports.bounty_awarded_at <snapshot_date_key.snapshot_date
                            and reports.bounty_awarded_at >= snapshot_date_key.snapshot_date -7
                            and extract(epoch from reports.bounty_awarded_at  - reports.created_at ) /86400 >= 26 then reports.id --'failed:bounty in ss'
                         -- reports open, triaged  after snapshot date then snapshot - create >14d
                    when reports.bounty_awarded_at is null and reports.closed_at is not null and substate = 'resolved' and ineligible_for_bounty = false
                          and reports.closed_at <= snapshot_date_key.snapshot_date  and reports.closed_at > snapshot_date_key.snapshot_date -7
                          and  extract(epoch from reports.closed_at  - reports.created_at ) /86400 >= 28 then reports.id --failed:bounty, closed in ss'
                      else null end)
       ;;
        }


        measure: reports_count_mtd {
          type: number
          sql: count(distinct case when  (((reports.created_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (reports.created_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL)))))   then ${id} else null end)
            ;;
        }

        dimension: hour {
          sql: EXTRACT(hour FROM reports.created_at) ;;
          type: number
        }

        dimension: filed_day_of_week {
          sql: EXTRACT(dow FROM reports.created_at) ;;
          type: number
        }

        dimension: outcome_category {
          sql: CASE when ${substate} = 'duplicate' then 'duplicate'
                  when ${substate} = 'informative' then 'ignored'
                  when ${substate} in ('not-applicable', 'spam') then 'invalid'
                  when ${substate} = 'resolved' then 'valid'
                  END
                   ;;
        }

        dimension: new_and_triaged_category {
          sql: CASE WHEN ${substate} = 'new' OR ${substate} = 'triaged' THEN 'new or triaged'
                  ELSE 'rest of population'
                  END
                   ;;
        }

        #from Andrew
        measure: filed_reports_new_triaged_count {
          type: count_distinct
          sql: case
                    when ${substate} in ('new','triaged')
                    then ${id}
                    else null
                  end
                   ;;
        }

        measure: reporter_w_bounty_count {
          type: count_distinct
          sql: case
                    when ${TABLE}.bounty_awarded_at is not NULL
                    then ${reporter_id}
                    else null
                  end
                   ;;
        }

        measure: reporter_w_bounty_count_l90d {
          type: count_distinct
          sql: case
                    when ${TABLE}.bounty_awarded_at is not NULL
                    then ${reporter_id}
                    else null
                  end
                   ;;
          filters: {
            field: reports.created_date
            value: "90 days"
          }
        }

        measure: reporter_w_resolved_count {
          type: count_distinct
          sql: case when ${substate} = 'resolved'
                    then ${reporter_id}
                    else null
                  end
                   ;;
        }

        measure: reporter_w_resolved_count_L90d {
          type: count_distinct
          sql: case when ${substate} = 'resolved'
                    then ${reporter_id}
                    else null
                  end
                   ;;
          filters: {
            field: reports.created_date
            value: "90 days"
          }
        }

        measure: reporter_w_resolved_crit_high_count {
          type: count_distinct
          sql: case when ${substate} = 'resolved' and ${severity_rating} in ('high','critical')
                    then ${reporter_id}
                    else null
                  end
                   ;;
        }

        measure: reporter_w_crit_high_count {
          type: count_distinct
          sql: case when ${severity_rating} in ('high','critical')
                    then ${reporter_id}
                    else null
                  end
                   ;;
        }

        measure: reporter_w_resolved_crit_high_count_90d {
          type: count_distinct
          sql: case when ${substate} = 'resolved' and ${severity_rating} in ('high','critical')
                    then ${reporter_id}
                    else null
                  end
                   ;;
          filters: {
            field: reports.created_date
            value: "90 days"
          }
        }

        measure: valid_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} in ('resolved','triaged')
                    then ${id}
                    else null
                    end
                   ;;
        }

        measure: invalid_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} in ('not-applicable', 'spam','informative')
                    then ${id}
                    else null
                    end
                   ;;
        }

        measure: duplicate_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} in ('duplicate')
                    then ${id}
                    else null
                    end
                   ;;
        }


        measure: resolved_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
        }

        measure: new_reports_count {
          type: count_distinct
          sql: case
                    when ${TABLE}.substate = 'new'
                    then ${TABLE}.id
                    else null
                  end
                   ;;
        }

        measure: nominal_signal_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} = 'informative' or ${substate} = 'duplicate'
                    then ${id}
                    else null
                  end
                   ;;
        }

        measure: noise_exlc_anc_reports_count {
          type: count_distinct
          sql: case
                    when (${substate} IN ('not-applicable', 'spam')
                              AND (${reports.pre_submission_review_state} IS NULL OR ${reports.pre_submission_review_state} != 'pre-submission-rejected'))
                    then ${id}
                    else null
                  end
                   ;;
        }


        measure: noise_reports_count {
          type: count_distinct
          sql: case
                    when ${substate} IN  ('not-applicable', 'spam')
                    then ${id}
                    else null
                  end
                   ;;
        }


        measure: valid_reports_count_2017_format {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
          filters: {
            field: reports.created_year
            value: "2017"
          }

        }

        measure: valid_reports_count_L90d_format {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
          filters: {
            field: reports.created_date
            value: "90 days"

          }
        }

        measure: valid_reports_closed_L90d {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: closed_at_date
            value: "90 days"

          }
        }

        measure: valid_reports_closed_L1_completed_w {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: closed_at_date
            value: "1 weeks ago for 1 weeks"

          }
        }

        measure: triaged_reports_triaged_L1_completed_w {
          type: count_distinct
          sql: case
                    when ${substate} = 'triaged'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: triaged_at_date
            value: "1 weeks ago for 1 weeks"

          }
        }


        measure: valid_closed_L90d_format_15_threshhold {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: closed_at_date
            value: "90 days"
          }
          drill_fields: [users.username, id,teams.handle, reports.created_date, reports.first_program_response_at_date,reports.state, reports.substate ]
          html: {% if value < 15 %}
                <p style="color: black; background-color: tomato; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                {% else %}
                <p style="color: black; background-color: lightgreen; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                {% endif %}
                ;;
        }

        measure: valid_crit_high_closed_L90d_format_3_threshhold {
          type: count_distinct
          sql: case
                    when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved') then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: reports.closed_at_date
            value: "90 days"
          }
          drill_fields: [users.username, id,teams.handle, reports.created_date, reports.first_program_response_at_date,reports.state, reports.substate ]
          html: {% if value < 3 %}
                <p style="color: black; background-color: tomato; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                {% else %}
                <p style="color: black; background-color: lightgreen; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                {% endif %}
                ;;
        }

        measure: valid_reports_created_L12m {
          type: count_distinct
          sql: case
                    when ${substate} = 'resolved'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: reports.created_date
            value: "365 days"

          }
        }

#   measure: valid_reports_created_L12m_HS {
#     type: count_distinct
#
#     sql: case
#     when   ${TABLE}.substate = 'resolved' and (((reports.closed_at) >=
#     ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'))))
#     AND (reports.closed_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) then ${id}
#     else null
#     end
#     ;;
#   }
#
#   dimension: valid_reports_created_L12m_HS_tier {
#     type: tier
#     style: integer
#     sql: ${valid_reports_created_L12m_HS};;
#     tiers: [
#       0,
#       5,
#       20
#     ]
#   }


        measure: triaged_reports_triaged_L90d {
          type: count_distinct
          sql: case
                    when ${substate} = 'triaged'
                    then ${id}
                    else null
                  end
                   ;;
          filters: {
            field: triaged_at_date
            value: "90 days"

          }
        }


        measure: bounty_reports_count {
          type: count_distinct
          sql: case
                    when ${TABLE}.bounty_awarded_at is not null
                    then ${id}
                    else null
                  end
                   ;;
        }

        measure: bounty_reports_count_customer {
          type: count_distinct
          sql: case
                    when ${TABLE}.bounty_awarded_at is not null
                    then ${id}
                    else null
                  end
                   ;;

            filters: {
              field: customer_filter
              value: "yes"
            }
          }

          measure: bounty_reports_count_peer {
            type: count_distinct
            sql: case
                      when ${TABLE}.bounty_awarded_at is not null
                      then ${id}
                      else null
                    end
                     ;;

              filters: {
                field: peer_state_filter_logic
                value: "yes"
              }

              filters: {
                field: peer_offer_bounty_filter_logic
                value: "yes"
              }
            }

            measure: bounty_reports_crit_high_count {
              type: count_distinct
              sql: case
                        when ${TABLE}.bounty_awarded_at is not null and ${TABLE}.severity_rating in ('critical','high')
                        then ${id}
                        else null
                      end
                       ;;
            }



            measure: closed_reports_count {
              type: count_distinct
              sql: case
                        when ${TABLE}.state = 'closed' then ${TABLE}.id
                        else null
                      end
                       ;;
            }

            measure: percent_valid {
              type: number
              sql: 100.00 * ${valid_reports_count} / nullif(${total_filed_reports_count},0) ;;
              value_format: "#.00\%"
              drill_fields: [created_date, id]
            }

            measure: reports_with_severity_rating_count {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating is not null then ${id}
                        else null
                      end
                       ;;
            }

            measure: reports_with_critical_or_high_severity_rating_count {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating in ('critical','high') then ${id}
                        else null
                      end
                       ;;
            }


            measure: valid_reports_with_critical_or_high_severity_rating_count_L90d {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved') then ${id}
                        else null
                      end
                       ;;
              filters: {
                field: reports.created_date
                value: "90 days"
              }
            }

            measure: valid_reports_with_critical_or_high_severity_rating_closed_L90d {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved') then ${id}
                        else null
                      end
                       ;;
              filters: {
                field: reports.closed_at_date
                value: "90 days"
              }
            }

            measure: triaged_resolved_reports_w_crit_or_high_severity_count {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate in ('triaged', 'resolved')) then ${id}
                        else null
                      end
                       ;;
            }

            measure: triaged_resolved_reports_w_med_or_low_severity_count {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating not in ('critical','high') and ${TABLE}.substate in ('triaged', 'resolved')) then ${id}
                        else null
                      end
                       ;;
            }

            measure: triaged_resolved_reports_w_crit_or_high_severity_count_L90d {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate in ('triaged', 'resolved')) then ${id}
                        else null
                      end
                       ;;
              filters: {
                field: reports.created_date
                value: "90 days"
              }
            }

            measure: valid_reports_with_critical_or_high_severity_rating_count {
              type: count_distinct
              sql: case
                        when  (${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved') then ${id}
                        else null
                      end
                       ;;
            }


            measure: valid_reports_with_critical_or_high_severity_rating_count_mtd {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved' and (((reports.closed_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (reports.closed_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: valid_reports_with_critical_or_high_severity_rating_count_l30d {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved' and
                       (((reports.closed_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL)))
                        AND (reports.closed_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL) + (30 || ' day')::INTERVAL)))))
                        then ${TABLE}.id
                        else null
                      end
                       ;;
            }

            measure: valid_reports_count_mtd {
              type: count_distinct
              sql: case
                        when  ${TABLE}.substate = 'resolved' and (((reports.closed_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (reports.closed_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: valid_reports_count_l30d {
              type:  count_distinct
              sql:   CASE WHEN ${TABLE}.substate = 'resolved' and (((reports.closed_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL)))
                AND (reports.closed_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL) + (30 || ' day')::INTERVAL))))) THEN ${TABLE}.id  ELSE NULL END;;
            }

            measure: valid_reports_count_201709 {
              type: count_distinct
              sql: case
                        when  ${TABLE}.substate = 'resolved' and ((((reports.closed_at) >= (TIMESTAMP '2017-09-01') AND (reports.closed_at) < (TIMESTAMP '2017-10-01')))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: valid_reports_with_critical_or_high_severity_rating_count_201709 {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved' and ((((reports.closed_at) >= (TIMESTAMP '2017-09-01') AND (reports.closed_at) < (TIMESTAMP '2017-10-01')))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: valid_reports_count_201803 {
              type: count_distinct
              sql: case
                        when  ${TABLE}.substate = 'resolved' and ((((reports.closed_at) >= (TIMESTAMP '2018-03-01') AND (reports.closed_at) < (TIMESTAMP '2018-04-01')))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: valid_reports_with_critical_or_high_severity_rating_count_201803 {
              type: count_distinct
              sql: case
                        when  ${TABLE}.severity_rating in ('critical','high') and ${TABLE}.substate = 'resolved' and ((((reports.closed_at) >= (TIMESTAMP '2018-03-01') AND (reports.closed_at) < (TIMESTAMP '2018-04-01')))) then ${id}
                        else null
                      end
                       ;;
            }

            measure: teams_with_critical_or_high_severity_reports_count {
              type: count_distinct
              sql: case
                      when  ${TABLE}.severity_rating in ('critical','high') then ${teams.id}
                      else null
                      end
                       ;;
            }

            measure: teams_with_valid_critical_or_high_severity_reports_count {
              type: count_distinct
              sql: case
                      when  ${TABLE}.severity_rating in ('critical','high') and ${reports.substate} = 'resolved' then ${teams.id}
                      else null
                      end
                       ;;
            }

            measure: teams_with_valid_reports_count {
              type: count_distinct
              sql: case
                      when   ${reports.substate} = 'resolved' then ${teams.id}
                      else null
                      end
                       ;;
            }
            measure: total_filed_reports_count {
              type: count_distinct
              sql: ${id} ;;
            }

            measure: teams_count {
              type: count_distinct
              sql:${TABLE}.team_id ;;
            }

            measure: open_reports_count {
              type:  count_distinct
              sql:  case when ${TABLE}.state = 'open' and ${TABLE}.substate not in ('duplicate','not-applicable','informative','resolved','spam') then ${id} else null end ;;
            }



            measure: total_filed_reports_count_excl_uber {
              type: count_distinct
              sql: case
                        when teams.handle not in ('uber')  then ${id}
                        else null
                      end
                       ;;
            }

            measure: total_filed_reports_count_uber {
              type: count_distinct
              sql: case
                        when teams.handle in ('uber')  then ${id}
                        else null
                      end
                       ;;
            }

            measure: percent_of_new_triaged {
              type: number
              sql: 100.00 * ${filed_reports_new_triaged_count} / nullif(${total_filed_reports_count},0) ;;
              value_format: "#.00\%"
              drill_fields: [created_date, id]
            }

            dimension: team_id {
              type: number
              # hidden: true
              sql: ${TABLE}.team_id ;;
            }

            dimension: original_report_id {
              type: number
              # hidden: true
              sql: ${TABLE}.original_report_id ;;
            }

            dimension: recognized {
              type: yesno
              sql: ${substate} = 'resolved' OR (${duplicate_reports.substate} = 'resolved' AND ${substate} = 'duplicate') ;;
            }

            dimension: comments_closed {
              type: yesno
              sql: ${TABLE}.comments_closed;;
            }

            dimension: days_from_report_creation {
              type: number
              sql: current_date -${TABLE}.created_at::date ;;
            }

            dimension: hours_from_report_creation {
              type: number
              value_format_name: decimal_0
              sql:  (EXTRACT(EPOCH FROM current_date -${TABLE}.created_at)/3600.00);;
            }

            dimension: bus_hours_from_report_creation {
              type: number
              value_format_name: decimal_2
              sql:  (EXTRACT(epoch FROM  timediff_bus_hours(reports.created_at::timestamp, reports.first_program_activity_at::timestamp ) )/3600.00 +.5);;
            }

#  EXTRACT(epoch FROM  timediff_bus_hours(reports.created_at::timestamp, response_time.first_team_response::timestamp ) )/3600 +.5 - 8
#     else  EXTRACT(epoch FROM  timediff_bus_hours(reports.created_at::timestamp, response_time.first_team_response::timestamp ) )/3600 +.5 end as filed_to_first_response_in_bus_hours
#
            dimension: days_from_filed_to_closed {
              type: number
              sql: ${TABLE}.closed_at::date -${TABLE}.created_at::date ;;
            }

            dimension: hours_from_filed_to_closed {
              type: number
#     sql:  (EXTRACT(EPOCH FROM   timediff(reports.created_at::timestamp ,reports.closed_at::timestamp )))/3600.00 ;;
              sql: (EXTRACT(EPOCH FROM ${TABLE}.closed_at::timestamp -${TABLE}.created_at::timestamp ::timestamp)/3600.00) ;;
            }

            dimension: days_from_filed_to_resolved {
              type: number
              sql: ${resolved_at_date} -${TABLE}.created_at::date ;;
            }

            dimension: days_from_filed_to_triaged {
              type: number
              sql: ${TABLE}.triaged_at::date -${TABLE}.created_at::date ;;
            }

            dimension: days_from_filed_to_first_program_response {
              type: number
              sql: ${TABLE}.first_program_activity_at::date -${TABLE}.created_at::date ;;
            }

            dimension: days_from_filed_to_bounty {
              type: number
              sql: ${TABLE}.bounty_awarded_at::date -${TABLE}.created_at::date ;;
            }

            dimension: hours_from_filed_to_first_program_response {
              type: number
              sql:  (EXTRACT(EPOCH FROM ${TABLE}.first_program_activity_at -${TABLE}.created_at)/3600.00);;
#      (${TABLE}.first_program_activity_at::timestamp -${TABLE}.created_at::timestamp )/3600;;
            }

            dimension: hours_from_filed_to_triaged {
              type: number
              sql: (EXTRACT(EPOCH FROM ${TABLE}.triaged_at::timestamp -${TABLE}.created_at::timestamp)/3600.00) ;;
            }

            dimension: hours_from_filed_to_bounty {
              type: number
#     sql: (EXTRACT(EPOCH FROM ${TABLE}.bounty_awarded_at::timestamp - ${TABLE}.created_at::timestamp/3600)::Integer ;;
              sql: (EXTRACT(EPOCH FROM ${TABLE}.bounty_awarded_at::timestamp -${TABLE}.created_at::timestamp)/3600.00) ;;
            }

            dimension: hours_from_filed_to_resolved {
              type: number
              sql: EXTRACT(EPOCH FROM ${resolved_at_time}::timestamp-${TABLE}.created_at::timestamp) / 3600 ;;
            }

            dimension: reference {
              type: number
              sql: ${TABLE}.reference ;;
            }


            measure: avg_days_from_filed_to_closed {
              type: average
              sql: ${TABLE}.closed_at::date -${TABLE}.created_at::date ;;
            }

            measure: 50th_percentile_days_from_filed_to_closed {
              type: percentile
              percentile: 50
              sql: ${days_from_filed_to_closed} ;;
            }

            measure: 50th_percentile_days_from_filed_to_resolved {
              type: percentile
              percentile: 50
              sql: ${days_from_filed_to_resolved} ;;
            }

            measure: 50th_percentile_days_from_filed_to_triaged {
              type: percentile
              percentile: 50
              sql: ${days_from_filed_to_triaged} ;;
            }

            measure: 50th_percentile_days_from_filed_to_bounty {
              type: percentile
              percentile: 50
              sql: ${days_from_filed_to_bounty} ;;
            }

            measure: 50th_percentile_days_from_filed_to_first_program_response {
              type: percentile
              percentile: 50
              sql: ${days_from_filed_to_first_program_response} ;;
            }


            measure: 50th_percentile_hours_from_filed_to_triaged {
              type: percentile
              percentile: 50
              sql: ${hours_from_filed_to_triaged};;
              value_format: "0.##"
            }

            measure: 50th_percentile_hours_from_filed_to_bounty {
              type: percentile
              percentile: 50
              sql: ${hours_from_filed_to_bounty};;
              value_format: "0.##"
            }

            measure: 50th_percentile_hours_from_filed_to_resolved {
              type: percentile
              percentile: 50
              sql: ${hours_from_filed_to_resolved};;
              value_format: "0.##"
            }

            measure: 50th_percentile_hours_from_filed_to_first_program_response {
              type: percentile
              percentile: 50
              sql: ${hours_from_filed_to_first_program_response} ;;
              value_format: "0.##"
            }

            filter: customer {
              type: string
              suggest_dimension: teams.handle
            }

            dimension: customer_filter {
              type: yesno
              hidden: yes
              sql: {% condition customer%} ${teams.handle} {% endcondition %} ;;
            }

            filter: state_peer {
              type: string
              suggest_dimension: teams.state
            }

            filter: offer_bounty_peer {
              type: string
              suggest_dimension: teams.offers_bounties
            }

            dimension: peer_state_filter_logic {
              type: yesno
              hidden: yes
              sql: {% condition teams.state %} ${teams.state} {% endcondition %} ;;
            }

            dimension: peer_offer_bounty_filter_logic {
              type: yesno
              hidden: yes
              sql: {% condition teams.offers_bounties %} ${teams.offers_bounties} {% endcondition %} ;;
            }

            measure: 50th_percentile_hours_from_filed_to_first_program_response_handle {
              type: percentile
              label: "median hours to first response"
              percentile: 50
              sql: ${hours_from_filed_to_first_program_response} ;;
              value_format: "0.##"

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: count_submit_handle {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: new_staleness_threshold {
              label: "first response target"
              type: min
              sql: teams.new_staleness_threshold/3600;;

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: triaged_staleness_threshold {
              label: "triage target"
              type: min
              sql: teams.triaged_staleness_threshold/3600;;

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: resolved_staleness_threshold {
              label: "resolved target"
              type: min
              sql: teams.resolved_staleness_threshold/86400;;

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: bounty_staleness_threshold {
              label: "bounty target"
              type: min
              sql: teams.bounty_awarded_staleness_threshold/86400;;

              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: count_submit_handle_top5 {
              type: count_distinct
              label: "# submits (top 5)"
              sql: case when  team_2018_bounty_rank.team_bounty_rank <= 5 then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top20 {
              type: count_distinct
              label: "# submits (top 20)"
              sql: case when team_2018_bounty_rank.team_bounty_rank <= 20  then ${id} else null end;;
              value_format: "0"
            }


            measure: count_submit_handle_top100_private {
              type: count_distinct
              label: "# submits (top 100 private)"
              sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 100  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top20_vdp {
              type: count_distinct
              label: "# submits (top 20 vdp)"
              sql: case when ${team_vdp_submit_rank_2018.submit_rank} <= 20  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top50_private {
              type: count_distinct
              label: "# submits (top 50 private)"
              sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 50  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top40_private {
              type: count_distinct
              label: "# submits (top 40 private)"
              sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 40  then ${id} else null end;;
              value_format: "0"
            }
            measure: count_submit_handle_top30_private {
              type: count_distinct
              label: "# submits (top 30 private)"
              sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 30  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top20_private {
              type: count_distinct
              label: "# submits (top 20 private)"
              sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 20  then ${id} else null end;;
              value_format: "0"
            }


            measure: count_submit_handle_top100_public {
              type: count_distinct
              label: "# submits (top 100 public)"
              sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 100  then ${id} else null end;;
              value_format: "0"
            }


            measure: count_submit_handle_top50_public {
              type: count_distinct
              label: "# submits (top 50 public)"
              sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 50  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top40_public {
              type: count_distinct
              label: "# submits (top 40 public)"
              sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 40  then ${id} else null end;;
              value_format: "0"
            }
            measure: count_submit_handle_top30_public {
              type: count_distinct
              label: "# submits (top 30 public)"
              sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 30  then ${id} else null end;;
              value_format: "0"
            }

            measure: count_submit_handle_top20_public {
              type: count_distinct
              label: "# submits (top 20 public)"
              sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 20  then ${id} else null end;;
              value_format: "0"
            }


            measure: 50th_percentile_hours_from_filed_to_first_program_response_top20 {
              type: percentile
              label: "median hours to first response (top 20)"
              percentile: 50
              sql: case when  team_2018_bounty_rank.team_bounty_rank <= 20 then ${hours_from_filed_to_first_program_response} else null end ;;
              value_format: "0.##"

#     filters: {
#       field: team_2018_bounty_rank.team_bounty_rank
#       value: "<20"
#     }
            }

            measure: 50th_percentile_hours_from_filed_to_triaged_handle {
              type: percentile
              label: "median hours to triage"
              percentile: 50
              sql: ${hours_from_filed_to_triaged};;
              value_format: "0.##"
              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: 50th_percentile_hours_from_filed_to_triaged_top20 {
              type: percentile
              label: "median hours to triage (top 20)"
              percentile: 50
              sql: case when  team_2018_bounty_rank.team_bounty_rank <= 20 then  ${hours_from_filed_to_triaged} else null end ;;
              value_format: "0.##"
              # filters: {
              #   field: team_2018_bounty_rank.team_bounty_rank
              #   value: "<20"
              # }
            }


            measure: 50th_percentile_days_from_filed_to_resolved_handle {
              type: percentile
              label: "median days to resolved"
              percentile: 50
              sql: ${days_from_filed_to_resolved} ;;
              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: 50th_percentile_days_from_filed_to_resolved_top20 {
              type: percentile
              label: "median days to resolved (top 20)"
              percentile: 50
              sql: case when  team_2018_bounty_rank.team_bounty_rank <= 20 then  ${days_from_filed_to_resolved} else null end ;;
              # filters: {
              #   field: team_2018_bounty_rank.team_bounty_rank
              #   value: "<20"
              # }
            }

            measure: 50th_percentile_hours_from_filed_to_closed_handle {
              type: percentile
              label: "median hours to closed"
              percentile: 50
              sql: ${hours_from_filed_to_closed} ;;
              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: 50th_percentile_days_from_filed_to_bounty_handle {
              type: percentile
              label: "median days to bounty"
              percentile: 50
              sql: ${days_from_filed_to_bounty} ;;
              filters: {
                field: customer_filter
                value: "yes"
              }
            }

            measure: 50th_percentile_days_from_filed_to_bounty_handle_L90d {
              type: percentile
              label: "median days create to bounty L90"
              percentile: 50
              sql: ${days_from_filed_to_bounty} ;;
              filters: {
                field: customer_filter
                value: "yes"
              }
              filters: {
                field: bounty_awarded_at_date
                value: "90 days"
              }
              html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;

            }

            measure: 90th_percentile_days_from_filed_to_bounty_handle_L90d {
              type: percentile
              label: "90th perdentile days create to bounty L90"
              percentile: 90
              sql: ${days_from_filed_to_bounty} ;;
              filters: {
                field: customer_filter
                value: "yes"
              }
              filters: {
                field: bounty_awarded_at_date
                value: "90 days"
              }
              html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;

            }

            measure: 50th_percentile_days_from_filed_to_bounty_top20 {
              type: percentile
              label: "median days to bounty (top 20)"
              percentile: 50
              sql: case when  team_2018_bounty_rank.team_bounty_rank <= 20 then  ${days_from_filed_to_bounty} else null end ;;

              # filters: {
              #   field: team_2018_bounty_rank.team_bounty_rank
              #   value: "<20"
              # }
            }



            measure: 90th_percentile_hours_from_filed_to_first_program_response {
              type: percentile
              percentile: 90
              sql: ${hours_from_filed_to_first_program_response} ;;
              value_format: "0.##"
            }

            measure: days_since_last_report {
              type: number
              sql: current_date - date(${maximum_created_at}  ) ;;
            }

            measure: count {
              type: count_distinct
              sql:  ${id} ;;
              drill_fields: [detail*]
            }

            measure: count_distinct {
              type: count_distinct
              sql: ${id} ;;
            }

            measure: count_distinct_crit_high {
              type: count_distinct
              sql: case when ${reports.severity_rating} in ('critical','high') then ${id} else null end ;;
            }

            measure: count_resolved_crit {
              type: count_distinct
              sql: case when ${reports.severity_rating} in ('critical') and ${reports.substate} in ('resolved') then ${id} else null end ;;
            }

            measure: count_resolved_high {
              type: count_distinct
              sql: case when ${reports.severity_rating} in ('high') and ${reports.substate} in ('resolved') then ${id} else null end ;;
            }

            measure: count_resolved_med {
              type: count_distinct
              sql: case when ${reports.severity_rating} in ('medium') and ${reports.substate} in ('resolved') then ${id} else null end ;;
            }

            measure: count_resolved_low {
              type: count_distinct
              sql: case when ${reports.severity_rating} in ('low') and ${reports.substate} in ('resolved') then ${id} else null end ;;
            }


            measure: count_submit {
              type: count_distinct
              sql: ${id} ;;
            }

            measure: count_anc {
              type: count_distinct
              sql:  CASE WHEN teams.anc_enabled AND array_length(reports.anc_reasons, 1) > 0 THEN ${id} ELSE NULL END ;;
            }

            measure: average_reports_count_per_hacker {
              type: number
              sql: ${count_distinct}/count(distinct ${users.id}) ;;
            }

            measure: average_reports_count_per_team {
              type: number
              sql: ${count_distinct}/count(distinct ${teams.id}) ;;
            }

            measure: count_distinct_l7d {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: reports.created_date
                value: "7 days"
              }
            }

            measure: count_distinct_l7d_format {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: reports.created_date
                value: "7 days"
              }
              html: {% if value < 5 %}
                    <p style="color: black; background-color: tomato; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                    {% else %}
                    <p style="color: black; background-color: lightgreen; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                    {% endif %}
                    ;;
            }


            measure: count_distinct_valid_l7d {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: closed_at_date
                value: "7 days"
              }
              filters: {
                field: substate
                value: "resolved"
              }
            }

            measure: count_new_reports_created_over_7_days_ago {
              type: count_distinct
              sql: case when ((reports.created_at < (SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-7 || ' day')::INTERVAL)))) AND (reports.substate = 'new') then ${id} else null end ;;
            }

            measure: 30_or_more_new_reports_created_over_7_days_ago {
              type: yesno
              sql: ${count_new_reports_created_over_7_days_ago} >= 30 ;;
            }

            measure: count_distinct_l30d {
              type: count_distinct
              sql: ${TABLE}.id ;;

              filters: {
                field: created_date
                value: "30 days"
              }
            }

            measure: count_distinct_teams_l30d {
              type: count_distinct
              sql: ${TABLE}.team_id ;;

              filters: {
                field: created_date
                value: "30 days"
              }
            }


            measure: teams_with_filed_reports_count {
              type: count_distinct
              sql: ${team_id} ;;
            }

            measure: teams_with_reports_count_distinct_l30d {
              type: count_distinct
              sql: ${team_id} ;;

              filters: {
                field: created_date
                value: "30 days"
              }
            }

            measure: 5_or_fewer_reports_filed_l30d {
              type: yesno
              sql: ${count_distinct_l30d} <= 5 or ${count_distinct_l30d} is null ;;
            }

            measure: count_distinct_l60d {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: created_date
                value: "60 days"
              }
            }

            measure: count_distinct_l90d {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: created_date
                value: "90 days"
              }
            }

            measure: count_distinct_l12M {
              type: count_distinct
              sql: ${id} ;;

              filters: {
                field: reports.created_date
                value: "365 days"

              }
            }


            measure: count_submits_l90d_format {
              type: count_distinct
              sql: ${TABLE}.id ;;
              filters: {
                field: created_date
                value: "90 days"
              }
              html: <p style="font-size:120%;  text-align:center">{{ rendered_value }}</p>;;
            }

            measure: count_submits_l90d_format_cond {
              label: "# submits L90d"
              type: count_distinct
              sql: ${TABLE}.id ;;
              filters: {
                field: created_date
                value: "90 days"
              }
              drill_fields: [id, teams.handle, reports.created_date, reports.state]
              html: {% if value < 15 %}
                    <p style="color: black; background-color: tomato; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                    {% else %}
                    <p style="color: black; background-color: lightgreen; border-radius: 100px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a> </p>
                    {% endif %}
                    ;;
            }

            measure: count_submits_L12M {
              label: "# submits L12M"
              type: count_distinct
              sql: ${TABLE}.id ;;
              filters: {
                field: created_date
                value: "365days"
              }
              drill_fields: [id, teams.handle, reports.created_date, reports.state]
            }

            measure: count_submits_l1completed_w {
              label: "# submits L1w"
              type: count_distinct
              sql: ${TABLE}.id ;;
              filters: {
                field: created_date
                value: "1 weeks ago for 1 weeks"
              }
              drill_fields: [id, teams.handle, reports.created_date, reports.state]
            }

            measure: count_last_week {
              type: count_distinct
              sql: case when ((((reports.created_at) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL))) AND (reports.created_at) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) then count(distinct reports.id) else null end
                ;;
            }

            measure: reports_created_yesterday {
              type: count_distinct
              sql: case when ((((reports.created_at) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-1 || ' day')::INTERVAL))) AND (reports.created_at) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-1 || ' day')::INTERVAL) + (1 || ' day')::INTERVAL)))))) then ${id} else null end
                ;;
            }

            #- measure: reports_created_last_month
            #  type: count_distinct
            #  sql: |
            #    CASE
            #     WHEN (${TABLE}.created_at >= dateadd('month',-1,getdate()) and ${TABLE}.created_at < now() THEN ${id} else null
            #    END)


            measure: submit_after_invite {
              type: count_distinct
              sql: CASE WHEN ${reports.team_id} = ${whitelisted_reporters.team_id}
                       AND  ${reports.reporter_id} = ${whitelisted_reporters.user_id}
                       AND ${reports.created_date} >= ${whitelisted_reporters.created_date}
                      then  count(distinct reports.id)
                        ELSE NULL END
                       ;;
            }

            measure: count_percent_of_total {
              label: "Count (Percent of Total)"
              type: percent_of_total
              value_format_name: decimal_1
              sql: ${count} ;;
            }

            measure: count_percent_change {
              label: "Count (Percent Change)"
              type: percent_of_previous
              value_format_name: decimal_1
              sql: ${count} ;;
            }

            measure: cumulative_count {
              type: running_total
              sql: ${count} ;;
            }

            measure: count_created_date {
              type: count_distinct
              sql: ${reports.created_date} ;;
            }

            measure: avg_monthly_reports_count {
              type: number
              value_format: "0"
              sql: count(distinct reports.id)/nullif(min(${first.months_since_team_first_launched}),0) ;;
            }

            measure: avg_monthly_triaged_or_resolved_reports_count {
              type: number
              value_format: "0"
              sql: coalesce(count(distinct case when ${TABLE}.substate in ('triaged','resolved') then ${TABLE}.id else null end)/nullif(min(${first.months_since_team_first_launched}),0),0) ;;
            }

            measure: distinct_teams_submitted_to_l7d {
              type: count_distinct
              sql: ${reports.team_id} ;;

              filters: {
                field: reports.created_date
                value: "7 days"
              }
            }

            measure: distinct_teams_submitted_to_l30d {
              type: count_distinct
              sql: ${reports.team_id} ;;

              filters: {
                field: reports.created_date
                value: "30 days"
              }
            }

            measure: distinct_teams_submitted_to_l60d {
              type: count_distinct
              sql: ${reports.team_id} ;;

              filters: {
                field: reports.created_date
                value: "60 days"
              }
            }

            measure: distinct_teams_submitted_to_l90d {
              type: count_distinct
              sql: ${reports.team_id} ;;

              filters: {
                field: reports.created_date
                value: "90 days"
              }
            }

            measure: distinct_teams_submitted_to_lifetime {
              type: count_distinct
              sql: ${reports.team_id} ;;
            }

            filter: team_peer_filter {
              suggest_dimension: teams.handle
            }

            dimension: team_comparitor {
              sql: CASE
                      WHEN {% condition team_peer_filter %} ${teams.handle} {% endcondition %}
                        THEN ${teams.handle}
                      ELSE 'Rest of Population'
                       END
                       ;;
            }

            dimension: created_at_daysSinceUserCreated {
              # the default value, could be excluded
              type: number
              sql: ${reports.created_date} - ${users.created_date} ;;
            }

            dimension: created_at_months_since_User_Created {
              type: number
              sql: FLOOR(${created_at_daysSinceFirstLaunch}/(30)) ;;
            }


            measure: valid_vs_team_goals {
#     alias: [valid_vs_team_goals]
            type:  string
            sql: case when ${reports.valid_reports_count}>=${teams.goal_valid_reports_90d} then 'exceeds'
                        when ${reports.valid_reports_count}>=(${teams.goal_valid_reports_90d} *.90) then '90%'
                           when ${reports.valid_reports_count}>=(${teams.goal_valid_reports_90d} *.75) then '75%'
                          when ${reports.valid_reports_count}<(${teams.goal_valid_reports_90d} *.75) then 'below 75%' else 'UNK' end
                          ;;
          }


          measure: meets_valid_reports_goal_mtd {
            alias: [meets_valid_reports_goal]
            type:  number
            sql: case when ${reports.valid_reports_count_mtd}<${teams.goal_valid_reports} then 0 else 1 end ;;
          }


          measure: meets_valid_reports_goal_l30d {
            type:  number
            sql: case when ${valid_reports_count_l30d}<${teams.goal_valid_reports} then 0 else 1 end ;;
          }

          measure: reports_still_needed_to_meet_valid_reports_goal {
            alias: [meets_valid_reports_goal]
            sql: case when ${reports.valid_reports_count_mtd}<${teams.goal_valid_reports} then 0 else 1 end ;;
          }

          measure: meets_valid_vhc_reports_goal_mtd {
            alias: [ meets_valid_vhc_reports_goal]
            type:  number
            sql: if(${reports.valid_reports_with_critical_or_high_severity_rating_count_mtd}<${teams.goal_vhc_reports},0,1) ;;
          }
          measure: meets_valid_vhc_reports_goal_l30d {
            type:  number
            sql: case when ${valid_reports_with_critical_or_high_severity_rating_count_l30d}<${teams.goal_vhc_reports} then 0 else 1 end ;;
          }

          measure: triaged_reports_count {
            type:  count_distinct
            sql:  case when ${TABLE}.substate = 'triaged' then ${TABLE}.id else null end ;;
          }

          measure: triaged_or_resolved_l7d {
            type: count_distinct
            sql: case
                    when coalesce(reports.triaged_at,reports.closed_at) >=
                      ((select (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-6 || ' day')::INTERVAL)))
                    and coalesce(reports.triaged_at,reports.closed_at) <
                      ((select ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-6 || ' day')::INTERVAL) + (7 || ' day')::INTERVAL)))
                    and reports.substate IN ('triaged', 'resolved')
                    then ${TABLE}.id
                    else null
                    end ;;
          }

          measure: triaged_or_resolved_l30d {
            type: count_distinct
            sql: case
                    when coalesce(${TABLE}.triaged_at,${TABLE}.closed_at) >=
                      ((select (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL)))
                    and coalesce(${TABLE}.triaged_at,${TABLE}.closed_at) <
                      ((select ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-29 || ' day')::INTERVAL) + (30 || ' day')::INTERVAL)))
                    and ${TABLE}.substate IN ('triaged', 'resolved')
                    then ${TABLE}.id
                    else null
                    end ;;
          }

          measure: triaged_or_resolved_l90d {
            # reports triaged L90d or resolved last 90d by triaged or closed date
            type: count_distinct
            sql:  CASE WHEN ((((${TABLE}.closed_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL))) AND
                        (${TABLE}.closed_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL) + (90 || ' day')::INTERVAL))))) and  ${TABLE}.substate = 'resolved'
                        ) or
                         ( (((${TABLE}.triaged_at ) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL))) AND
                          (${TABLE}.triaged_at ) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-89 || ' day')::INTERVAL) + (90 || ' day')::INTERVAL)))))
                        and  ${TABLE}.substate = 'triaged')
                        then reports.id else null end;;
          }

          measure: triaged_or_resolved_l1_completed_week {
            # reports triaged or resolved last completed wwrk
            type: count_distinct
            sql:  CASE WHEN ((((${TABLE}.closed_at ) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL)))  AND
                        (${TABLE}.closed_at ) <((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))  and  ${TABLE}.substate = 'resolved'
                        ) or
                         ( (((${TABLE}.triaged_at ) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL)))  AND
                          (${TABLE}.triaged_at ) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))
                        and  ${TABLE}.substate = 'triaged')
                        then reports.id else null end;;
          }


          measure: percent_of_adjusted_goal_triaged_resolved_l90d {

            type: number
            sql: case when ${teams.goal_adjusted_valid_reports_90d} = 0 and ${triaged_or_resolved_l90d} = 0 then 1
              when ${teams.goal_adjusted_valid_reports_90d} = 0 and ${triaged_or_resolved_l90d} > 0 then 1
              else ${triaged_or_resolved_l90d}/nullif(${teams.goal_adjusted_valid_reports_90d},0) end ;;
            value_format_name: percent_0
          }

          measure: meets_adjusted_goal_triaged_resolved_l90d {

            type: number
            sql: case when ${percent_of_adjusted_goal_triaged_resolved_l90d} >=1 then 1
              else 0 end ;;
            value_format_name: decimal_0
          }


          measure: triaged_or_resolved_l90d_format {
            sql:  ${percent_of_adjusted_goal_triaged_resolved_l90d} ;;
            value_format_name: decimal_0
            html: {% if value < 0.60 %}
                    <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ triaged_or_resolved_l90d  }}</p>
                    {% elsif value < 0.90 %}
                    <p style="color: black; background-color: orange; border-radius: 25px; font-size:120%; text-align:center">{{ triaged_or_resolved_l90d  }}</p>
                     {% elsif value < 1 %}
                    <p style="color: black; background-color: yellow; border-radius: 25px; font-size:120%; text-align:center">{{ triaged_or_resolved_l90d  }}</p>
                    {% elsif value >= 1 %}
                    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ triaged_or_resolved_l90d  }}</p>
                    {% else %}
                    <p style="color: black; background-color: gray;border-radius: 25px;  font-size:120%; text-align:center">{{ triaged_or_resolved_l90d  }}</p>
                    {% endif %}
                    ;;
          }

          measure: percent_of_adjusted_goal_triaged_or_resolved_l90d_format {
            sql:  ${percent_of_adjusted_goal_triaged_resolved_l90d} ;;
            value_format: "0.00\%"
            html: {% if value < 0.60 %}
                     <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_adjusted_goal_triaged_resolved_l90d._rendered_value  }}</p>
                    {% elsif value <0.90 %}
                    <p style="color: black; background-color: orange; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_adjusted_goal_triaged_resolved_l90d._rendered_value  }}</p>
                    {% elsif value < 1 %}
                    <p style="color: black; background-color: yellow; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_adjusted_goal_triaged_resolved_l90d._rendered_value  }}</p>
                    {% elsif value >= 1 %}
                    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_adjusted_goal_triaged_resolved_l90d._rendered_value  }}</p>
                    {% else %}
                    <p style="color: black; background-color: gray;border-radius: 25px;  font-size:120%; text-align:center"> {{ 0 }} </p>
                    {% endif %}
                    ;;

            }

            measure: percent_of_failed_first_response_5d_SLA_l90d {
              # reports triaged L90d resolved last 90d by triaged or closed date
              type: number
#     sql:   ${count_submits_l90d_format} ;;
              sql: case when ${count_distinct_l90d} = 0  then 0
                else (${count_failed_first_program_response_SLA_5d_l90d}/(${count_submits_l90d_format}*1.00)) end ;;
              value_format_name: percent_0
            }


            measure: failed_first_response_in5d_l90d_format {
              sql:  ${percent_of_failed_first_response_5d_SLA_l90d} ;;
              value_format_name: decimal_0
              html: {% if value > 0.90 %}
                              <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ count_failed_first_program_response_SLA_5d_l90d  }}</p>
                              {% elsif value > 0.60 %}
                              <p style="color: black; background-color: orange; border-radius: 25px; font-size:120%; text-align:center">{{ count_failed_first_program_response_SLA_5d_l90d  }}</p>
                               {% elsif value > 0.0 %}
                              <p style="color: black; background-color: yellow; border-radius: 25px; font-size:120%; text-align:center">{{ count_failed_first_program_response_SLA_5d_l90d  }}</p>
                              {% elsif value == 0 %}
                              <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ count_failed_first_program_response_SLA_5d_l90d  }}</p>
                              {% else %}
                              <p style="color: black; background-color: gray;border-radius: 25px;  font-size:120%; text-align:center">{{ count_failed_first_program_response_SLA_5d_l90d  }}</p>
                              {% endif %}
                              ;;
            }

            measure: failed_percent_of_first_response_in5d_l90d_format {
              sql:  ${percent_of_failed_first_response_5d_SLA_l90d} ;;
              value_format: "0.00\%"
              html: {% if value > 0.90 %}
                               <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_failed_first_response_5d_SLA_l90d._rendered_value  }}</p>
                              {% elsif value  > 0.60 %}
                              <p style="color: black; background-color: orange; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_failed_first_response_5d_SLA_l90d._rendered_value  }}</p>
                              {% elsif value > 0 %}
                              <p style="color: black; background-color: yellow; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_failed_first_response_5d_SLA_l90d._rendered_value  }}</p>
                              {% elsif value == 0 %}
                              <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ percent_of_failed_first_response_5d_SLA_l90d._rendered_value  }}</p>
                              {% else %}
                              <p style="color: black; background-color: gray;border-radius: 25px;  font-size:120%; text-align:center"> {{ 0 }} </p>
                              {% endif %}
                              ;;
            }

            measure: triaged_or_resolved {
              type: count_distinct
              sql: case
                      when ${TABLE}.substate IN ('triaged', 'resolved')
                      then ${TABLE}.id
                      else null
                      end;;
            }

            measure: triaged_or_resolved_coalesce {
              type: number
              sql: coalesce(count(distinct case
                      when ${TABLE}.substate IN ('triaged', 'resolved')
                      then ${TABLE}.id
                      else null
                      end),0);;
            }

            measure: hackers_with_submits {
              type: count_distinct
              sql: ${TABLE}.reporter_id ;;
            }

            measure: hackers_with_triaged_resolved_or_duplicate {
              type: count_distinct
              sql: case
                      when ${TABLE}.substate IN ('triaged', 'resolved','duplicate')
                      then ${TABLE}.reporter_id
                      else null
                      end ;;
            }

            measure: hackers_with_triaged_resolved_or_duplicate_crit_high {
              type: count_distinct
              sql: case
                      when ${TABLE}.substate IN ('triaged', 'resolved','duplicate') and   ${TABLE}.severity_rating in ('critical','high')
                      then ${TABLE}.reporter_id
                      else null
                      end ;;
            }

            measure: hackers_with_triaged_or_resolved_reports {
              type: count_distinct
              sql: case
                      when ${TABLE}.substate IN ('triaged', 'resolved')
                      then ${TABLE}.reporter_id
                      else null
                      end ;;
            }

            measure: hackers_with_triaged_or_resolved_crit_high_reports {
              type: count_distinct
              sql: case
                      when ${TABLE}.substate IN ('triaged', 'resolved') and  ${TABLE}.severity_rating in ('critical','high')
                      then ${TABLE}.reporter_id
                      else null
                      end ;;
            }

            dimension_group: timer_first_program_response_fail {
              type: time
              timeframes: [
                time,
                date,
                week,
                month,
                year,
                raw,
                day_of_week,
                quarter,
                hour
              ]
              sql: ${TABLE}.timer_first_program_response_fail_at ;;
            }

            dimension_group: timer_report_triage_fail {
              type: time
              timeframes: [
                time,
                date,
                week,
                month,
                year,
                raw,
                day_of_week,
                quarter,
                hour
              ]
              sql: ${TABLE}.timer_report_triage_fail_at_date ;;
            }



            measure: failing_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_fail_at < NOW()))
                or (${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_fail_at < NOW()))) then ${TABLE}.id else null end ;;
            }

            measure: failing_report_triage_reports {
              type:  count_distinct
              sql:  case when ${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_fail_at < NOW())
                then ${TABLE}.id else null end ;;
            }

            measure: failing_first_response_reports {
              type:  count_distinct
              sql:  case when ${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_fail_at < NOW())
                then ${TABLE}.id else null end ;;
            }

            measure: missing_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_miss_at < NOW()))
                      or (${TABLE}.timer_bounty_awarded_elapsed_time is null and (${TABLE}.timer_bounty_awarded_miss_at < NOW()))
                      or (${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_miss_at < NOW()))
                      or (${TABLE}.timer_report_resolved_elapsed_time is null and (${TABLE}.timer_report_resolved_miss_at < NOW()))
                      ) then ${TABLE}.id else null end ;;
            }

            measure: missing_report_triage_sla_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_miss_at < NOW()))
                ) then ${TABLE}.id else null end ;;
            }

            measure: missing_bounty_awarded_sla_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_bounty_awarded_elapsed_time is null and (${TABLE}.timer_bounty_awarded_miss_at < NOW()))
                ) then ${TABLE}.id else null end ;;
            }

            measure: missing_report_resolved_sla_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_report_resolved_elapsed_time is null and (${TABLE}.timer_report_resolved_miss_at < NOW()))
                ) then ${TABLE}.id else null end ;;
            }


            measure: missing_first_program_response_sla_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_miss_at < NOW()))
                ) then ${TABLE}.id else null end ;;
            }

            measure: reports_1_month_before_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at)  <= 31 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) >= 1) then reports.id else null end ;;
            }

            measure: reports_1_month_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <= 30) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) >= 0) then reports.id else null end  ;;
            }

            measure: reports_2_months_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when  (DATE(reports.created_at) - DATE(first_auto_invite.created_at) > 30) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=60) then reports.id else null end ;;
            }

            measure: reports_3_months_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) > 60) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=90) then reports.id else null end  ;;
            }

            measure: reports_4_months_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) > 90) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=120) then reports.id else null end  ;;
            }


            measure: reports_5_months_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) > 120) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=150) then reports.id else null end  ;;
            }

            measure: reports_6_months_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) > 150) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=180) then reports.id else null end  ;;
            }



            measure: reports_2_months_before_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at) > 31 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) <= 61) then reports.id else null end ;;

            }

            measure: reports_3_months_before_first_auto_invite  {
              alias: [reports_61_90_days_before_first_auto_invite ]
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at) > 61 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) <= 91) then reports.id else null end ;;

            }

            measure: reports_90_days_before_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at) >= 1 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) <= 91) then reports.id else null end ;;

            }

            measure: reports_90_days_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) >= 0) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=90) then reports.id else null end  ;;
            }

            measure: valid_reports_90_days_before_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at) >= 1 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) <= 91) and reports.substate = 'resolved' then reports.id else null end ;;

            }

            measure: closed_reports_90_days_before_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(first_auto_invite.created_at) - DATE(reports.created_at) >= 1 and DATE(first_auto_invite.created_at) - DATE(reports.created_at) <= 91) and reports.substate in ('spam','duplicate','informative','not-applicable','resolved') then reports.id else null end ;;

            }

            measure: valid_reports_90_days_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) >= 0) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=90) and reports.substate = 'resolved' then reports.id else null end  ;;
            }

            measure: closed_reports_90_days_after_first_auto_invite  {
              type:  count_distinct
              sql:  case when (DATE(reports.created_at) - DATE(first_auto_invite.created_at) >= 0) and (DATE(reports.created_at) - DATE(first_auto_invite.created_at) <=90) and reports.substate in ('spam','duplicate','informative','not-applicable','resolved') then reports.id else null end  ;;
            }



#  measure: failing_reports {
#    type:  count_distinct
#    sql:  case when ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_miss_at < NOW())) -- triage
#      ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_miss_at < NOW())) -- bounty
#      ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_miss_at < NOW())) -- resolution
#      or (${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_fail_at < NOW()))) -- -- first response
#     then ${TABLE}.id else null end ;;
#  }

            measure: distinct_hackers_with_failing_reports {
              type:  count_distinct
              sql:  case when ((${TABLE}.timer_report_triage_elapsed_time is null and (${TABLE}.timer_report_triage_fail_at < NOW()))
                or (${TABLE}.timer_first_program_response_elapsed_time is null and (${TABLE}.timer_first_program_response_fail_at < NOW()))) then ${TABLE}.reporter_id else null end ;;
              html: {% if value >= 5 %}
                    <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
                    {% else %}
                    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center">{{ rendered_value }}</p>
                    {% endif %}
                    ;;

              }

              measure: reports_count_YTD {
                type: count_distinct
                sql: case when   (((${TABLE}.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (${TABLE}.created_at) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL)))))   then ${TABLE}.id else null end
                  ;;
              }

#   dimension: isSaaS {
#     type:  yesno
#     sql:  case when ${teams_saas_details_from_platform_and_sf.program_type} ilike ('SaaS') and
#                (reports.bounty_awarded_at)  >= ${teams_saas_details_from_platform_and_sf.started_at}
#               and (reports.bounty_awarded_at)  < ${teams_saas_details_from_platform_and_sf.ended_at} then true
#       else false end ;;
#   }

              dimension: isSaaS {
                type:  string
                sql:  case when ${teams_saas_details_from_platform_and_sf.program_type} ilike ('SaaS') and
                                 (reports.bounty_awarded_at)  >= ${teams_saas_details_from_platform_and_sf.started_at}
                                and (reports.bounty_awarded_at)  < ${teams_saas_details_from_platform_and_sf.ended_at} then 'Saas'
                        else 'non-SaaS' end ;;
              }


              #- measure: count_reports_for_triage_cap
              #  type: count_distinct
              #  sql: |
              #    CASE WHEN ${teams.handle} in ('zenefits',
              #      'starbucks',
              #      'worldpay',
              #      'geico',
              #      'concur',
              #      'bigcartel',
              #     'doordash',
              #      'swisscom',
              #     'shoprunner',
              #    'lendingclub',
              #   'secureauth',
              #      'brave',
              #     'global_personals',
              #      'showmax',
              #      'usaa',
              #      'aboutdotcom',
              #     'cargurus',
              #      'square',
              #      'lyst',
              #     'friendfinder_networks_inc') THEN ${reports.id}
              #    ELSE NULL
              #    END

              #- measure: triage_cap
              #  type: count_distinct
              #  sql: |
              #    case when (max(${reports.team_id}) = 1989 and count(distinct reports.id) > 100) then true
              #   --when (triage.handle = ('zenefits') and count(distinct reports.id) > 100000) then ${reports.id}
              #    --when (triage.handle = ('geico') and count(distinct reports.id) > 20) then ${reports.id}
              #    --when (triage.handle = ('worldpay') and count(distinct reports.id) > 20) then ${reports.id}
              #    --when (triage.handle = ('concur') and count(distinct reports.id) > 100000) then ${reports.id}
              #    --when (triage.handle = ('bigcartel') and count(distinct reports.id) > 20) then count(distinct reports.id)
              #    --when (teams.handle = ('doordash') and count(distinct reports.id) > 30) then count(distinct reports.id)
              #    --when (teams.handle = ('swisscom') and count(distinct reports.id) > 130) then count(distinct reports.id)
              #    --when (teams.handle = ('shoprunner') and count(distinct reports.id) > 20) then count(distinct reports.id)
              #    --when (teams.handle = ('lendingclub') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('secureauth') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('brave') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('global_personals') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('usaa') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('aboutdotcom') and count(distinct reports.id) > 20) then count(distinct reports.id)
              #    --when (teams.handle = ('square') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('lyst') and count(distinct reports.id) > 40) then count(distinct reports.id)
              #    --when (teams.handle = ('friendfinder_networks_inc') and count(distinct reports.id) > 20) then count(distinct reports.id)
              #    else null end
              #    --when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)
              #    --when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)
              #     -- when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)
              #    --when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)
              #    --when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)
              #    --when (teams.handle = ('starbucks') and count(distinct reports.id) > 190) then count(distinct reports.id)





              # ----- Sets of fields for drilling ------
              set: detail {
                fields: [teams.id, teams.name]
              }
            }



view: bounties {
  sql_table_name: bounties ;;
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      month_name,
      year,
      raw,
      fiscal_year,
      day_of_week,
      day_of_month,
      hour_of_day,
      quarter
    ]
    sql: ${TABLE}.created_at ;;
  }


  filter: timeframe_picker_create {
    type: string
    suggestions: ["day", "week", "month", "quarter","year"]
  }

  dimension: dynamic_timeframe_create {
    type: string
    label: " bounty awarded at"
    sql:
    CASE
    WHEN {% condition timeframe_picker_create %} 'day' {% endcondition %} THEN ${bounties.created_date}::varchar
    WHEN {% condition timeframe_picker_create %} 'week' {% endcondition %} THEN ${bounties.created_week}
    WHEN {% condition timeframe_picker_create %} 'month' {% endcondition %} THEN ${bounties.created_month}
    WHEN {% condition timeframe_picker_create %} 'quarter' {% endcondition %} THEN ${bounties.created_quarter}
    WHEN {% condition timeframe_picker_create %} 'year' {% endcondition %} THEN ${bounties.created_year}::varchar
    --else ${bounties.created_quarter}
    END ;;
  }


  dimension: created_day_of_week_tier_halfmonth {
    type: tier
    tiers: [1, 16]
# the default value, could be excluded
    style: integer
    sql: ${created_day_of_month}::int ;;
  }

  dimension: created_day_of_week_tier_quartermonth {
    type: tier
    tiers: [1, 8, 16, 24]
# the default value, could be excluded
    style: integer
    sql: ${created_day_of_month}::int ;;
  }



  dimension: bounty_created_at_daysSinceFirstLaunch {
# the default value, could be excluded
  type: number
  sql: ${bounties.created_date} - ${first.launch_date} ;;
}

dimension: bounty_created_at_months_since_first_launch {
  type: number
  sql: FLOOR(${bounty_created_at_daysSinceFirstLaunch}/(30)) ;;
}

dimension: bounty_created_at_years_since_first_launch {
  type: number
  sql: FLOOR(${bounty_created_at_daysSinceFirstLaunch}/(365)) ;;
}

dimension: created_at_quarters_since_first_launch {
  type: number
  sql: FLOOR(${bounty_created_at_daysSinceFirstLaunch}/(90)) ;;
}

dimension: bounty_created_at_daysSinceFirstLaunch_tier {
  type: tier
  style: integer
  sql: ${bounty_created_at_daysSinceFirstLaunch} ;;
  tiers: [
    0,
    6,
    13,
    30,
    60,
    90,
    120,
    150,
    180,
    360
  ]
}

dimension: bounty_created_at_daysSinceFirstLaunch_tier_byHalfYear {
  type: tier
  style: integer
  sql: ${bounty_created_at_daysSinceFirstLaunch} ;;
  tiers: [0, 183, 366]
}

dimension: special_event_bounty_type {
  type: string
  sql: case when
    teams.handle ilike ('%h1702%')
    or teams.handle ilike ('%h13120%')
    or teams.handle ilike ('%h1415%')
    or teams.handle ilike ('%h1-702%') then 'hackathon'
    when teams.handle ilike ('%hackthe%') then 'DoD'
    when ${reports.created_pst_date} >= '2017-07-27' and ${reports.created_pst_date} < '2017-07-28' and ${teams.handle} = 'uber' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-28' and ${reports.created_pst_date} < '2017-07-29' and ${teams.handle} = 'salesforce' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-29' and ${reports.created_pst_date} < '2017-07-30' and ${teams.handle} = 'zenefits' then 'hackathon'
    -- when ${reports.created_pst_date} >= '2017-10-16' and ${reports.created_pst_date} < '2017-11-17' then 'HacktheWorld'
    else 'regular' end ;;
}

dimension: special_event_bounty_type_with_challenges {
  type: string
  sql: case when
    teams.handle ilike ('%h1702%')
    or teams.handle ilike ('%h13120%')
    or teams.handle ilike ('%h1415%')
    or teams.handle ilike ('%h1-702%') then 'hackathon'
    when teams.handle ilike ('%hackthe%') then 'DoD'
    when teams.handle ilike ('%h1c%') then 'challenge'
    when ${reports.created_pst_date} >= '2017-07-27' and ${reports.created_pst_date} < '2017-07-28' and ${teams.handle} = 'uber' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-28' and ${reports.created_pst_date} < '2017-07-29' and ${teams.handle} = 'salesforce' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-29' and ${reports.created_pst_date} < '2017-07-30' and ${teams.handle} = 'zenefits' then 'hackathon'
    -- when ${reports.created_pst_date} >= '2017-10-16' and ${reports.created_pst_date} < '2017-11-17' then 'HacktheWorld'
    else 'regular' end ;;
}

dimension: special_event_bounty_type_with_challenges_private_public {
  type: string
  sql: case when
    teams.handle ilike ('%h1702%')
    or teams.handle ilike ('%h13120%')
    or teams.handle ilike ('%h1415%')
    or teams.handle ilike ('%h1-702%') then 'hackathon'
    when teams.handle ilike ('%hackthe%') then 'DoD'
    when teams.handle ilike ('%h1c%') then 'challenge'
    when ${reports.created_pst_date} >= '2017-07-27' and ${reports.created_pst_date} < '2017-07-28' and ${teams.handle} = 'uber' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-28' and ${reports.created_pst_date} < '2017-07-29' and ${teams.handle} = 'salesforce' then 'hackathon'
    when ${reports.created_pst_date} >= '2017-07-29' and ${reports.created_pst_date} < '2017-07-30' and ${teams.handle} = 'zenefits' then 'hackathon'
    -- when ${reports.created_pst_date} >= '2017-10-16' and ${reports.created_pst_date} < '2017-11-17' then 'HacktheWorld'
    when ${teams.state} = 4 then 'regular_private'
    when ${teams.state} = 5 then 'regular_public'
    else null end ;;
}

dimension: bounty_created_at_daysSinceFirstLaunch_tier_byMonth {
  type: tier
  style: integer
  sql: ${bounty_created_at_daysSinceFirstLaunch} ;;
  tiers: [
    0,
    30,
    60,
    90,
    120,
    150,
    180,
    210,
    240,
    270,
    300,
    330,
    360,
    720,
    1080,
    1440
  ]
}

dimension: bounty_created_at_daysSinceFirstPublicLaunch {
# the default value, could be excluded
type: number
sql: ${bounties.created_date} - ${first_public.launch_date} ;;
}

dimension: bounty_created_at_daysSinceFirstPublicLaunch_tier {
  type: tier
  style: integer
  sql: ${bounty_created_at_daysSinceFirstPublicLaunch} ;;
  tiers: [
    0,
    30,
    60,
    90,
    120,
    150,
    180,
    210,
    240,
    270,
    300,
    330,
    360
  ]
}

measure: maximum_created_at {
  type: date
  sql: max(${TABLE}.created_at) ;;
}

measure: days_since_last_bounty {
  type: number
  sql: current_date - date(${maximum_created_at}) ;;
}

dimension: report_id {
  type: number
  sql: ${TABLE}.report_id ;;
}

measure: count_distinct_report_id {
  type: count_distinct
  sql: ${TABLE}.report_id ;;
}

measure: count_distinct_report_id_L90d {
  type: count_distinct
  sql: ${TABLE}.report_id ;;
  filters: {
    field: created_date
    value: "90 days"
  }
}

measure: average_bounty_per_report_L90d {
  type: number
  value_format_name: usd_0
  sql: ${total_financial_rewards_l90d}/${count_distinct_report_id_L90d} ;;

}

measure: average_bounty_per_report {
  type: number
  value_format_name: usd_0
  sql: ${total_financial_rewards_amount}/${count_distinct_report_id} ;;

}

dimension: amount {
  type: number
  value_format: "$#,##0.00"
  sql: coalesce(${TABLE}.amount,0) ;;
}

dimension: bonus_amount {
  type: number
  value_format: "$#,##0.00"
  sql: coalesce(${TABLE}.bonus_amount,0) ;;
}

dimension: bounties_plus_bonus_amount {
  type: number
  value_format: "$#,##0.00"
  sql: ${amount} + ${bonus_amount} ;;
}


dimension: isSaaS {
  type: yesno
  sql: case when ${teams_saas_details_from_platform_and_sf.program_type} ilike ('SaaS') and
    (bounties.created_at) >= ${teams_saas_details_from_platform_and_sf.started_at}
    and (bounties.created_at) < ${teams_saas_details_from_platform_and_sf.ended_at} then true
    else false end ;;
}

dimension: not_paid_through_hackerone {
  type: yesno
  sql: ${TABLE}.not_paid_through_hackerone ;;
}

measure: less_than_100 {
  type: count_distinct
  sql: case
    when ${bounties_plus_bonus_amount} < 100
    then ${bounties.id} else null end
    ;;
}

measure: bounty_more_than_500 {
  type: count_distinct
  sql: case
    when ${bounties_plus_bonus_amount} >500
    then ${reports.id} else null end
    ;;
}

measure: bounty_more_than_5000 {
  type: count_distinct
  sql: case
    when ${bounties_plus_bonus_amount} >5000
    then ${reports.id} else null end
    ;;
}

measure: bounty_more_than_10000 {
  type: count_distinct
  sql: case
    when ${bounties_plus_bonus_amount} >10000
    then ${reports.id} else null end
    ;;
}


dimension: bounty_bucket {
  type: tier
  style: integer
  sql: ${amount} ;;
  tiers: [
    0,
    25,
    50,
    75,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    1000,
    1500,
    2000,
    2500,
    3000,
    3500,
    4000,
    4500,
    5000,
    7500,
    10000,
    15000,
    20000,
    30000,
    40000,
    50000
  ]
}
dimension: severity_by_bounty_amount {
  type: tier
  style: integer
  sql: ${amount} ;;
  tiers: [
    0,
    150,
    500,
    1400
  ]
}

dimension: severity_by_bounty_amount_mid_tier {
  type: tier
  style: integer
  sql: ${amount} ;;
  tiers: [
    0,
    351,
    751,
    2001
  ]
}
# commented out for LOOKML migrations: need to fix post migration
# measure: bounty_tier {
# type: tier
# #X# style:"integer"
# sql: ${total_financial_rewards_amount} ;;
# #X# Invalid LookML inside "measure": {"tiers":[0,5000,15000,25000,50000,100000,250000]}
# }

measure: total_financial_rewards_amount {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: total_financial_rewards_amount_crit_high {
  type: sum
  value_format: "$#,##0"
  sql: case when ${reports.severity_rating} in ('critical','high') then ${bounties_plus_bonus_amount} else null end;;
}

measure: max_total_financial_rewards_amount {
  type: max
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: min_total_financial_rewards_amount {
  type: min
  value_format: "$#,##0"
  sql: case when ${bounties_plus_bonus_amount} > 0 then ${bounties_plus_bonus_amount} end ;;


}

#redefinition of field per ning report
measure: bounty_plus_bonus_all {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: bounty_handle_top20 {
  type: sum
  label: "$ bounty (top 20)"
  sql: case when team_2018_bounty_rank.team_bounty_rank <= 20 then ${bounties_plus_bonus_amount} else null end;;
  value_format_name: usd_0
}

measure: bounty_handle_private_top20 {
  type: sum
  label: "$ bounty (top 20 private)"
  sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 20 then ${bounties_plus_bonus_amount} else null end;;
  value_format_name: usd_0
}

measure: bounty_handle_public_top20 {
  type: sum
  label: "$ bounty (top 20 public)"
  sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 20 then ${bounties_plus_bonus_amount} else null end;;
  value_format_name: usd_0
}

measure: bounty_handle_private_top100 {
  type: sum
  label: "$ bounty (top 100 private)"
  sql: case when team_2018_bounty_rank_private.team_bounty_rank <= 100 then ${bounties_plus_bonus_amount} else null end;;
  value_format_name: usd_0
}

measure: bounty_handle_public_top100 {
  type: sum
  label: "$ bounty (top 100 public)"
  sql: case when team_2018_bounty_rank_public.team_bounty_rank <= 100 then ${bounties_plus_bonus_amount} else null end;;
  value_format_name: usd_0
}



measure: bounty_plus_bonus_IBB {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.internet_bug_bounty} is true
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_H1 {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('security','withinsecurity')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_ibb_h1 {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN (${teams.handle} in ('security','withinsecurity') or ${teams.internet_bug_bounty} is true)
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_uber {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('uber')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_zenefits {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('zenefits')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_shopifyscripts {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('shopify-scripts')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_hackathon {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('airbnb-h1415','shopify-h1415','worldpay-h13120')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_DoD {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('hackthearmy','hackthepentagon')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_pornhub {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${teams.handle} in ('pornhub')
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_post_sub_start {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN ${bounties.created_date} - ${opportunity.of_subscription_start_date} >0
    THEN ${amount} + ${bonus_amount}
    ELSE 0
    END
    ;;
    # sql_distinct_key: ${bounties.id};;
  }

# dimension: bounty_plus_bonus_post_opp_close_dim {
# type: number
# value_format: "$#,##0"
# sql: CASE WHEN ${bounties.created_date} - ${opportunity.closedate_date} >0
# THEN ${bounties_plus_bonus_amount}
# ELSE 0
# END
# ;;
# }
#
# measure: bounty_plus_bonus_post_opp_close_sum {
# type: sum
# value_format: "$#,##0"
# sql: ${bounty_plus_bonus_post_opp_close_dim}
# ;;
# }


  measure: bounty_plus_bonus_starbucks {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN ${teams.handle} in ('starbucks')
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_plus_bonus_excl_specialevents {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (${teams.handle} not in ('uber','hackthearmy','hackthepentagon','shopify-scripts','zenefits','airbnb-h1415','shopify-h1415','worldpay-h13120','security','withinsecurity' ) and (NOT COALESCE(${teams.internet_bug_bounty}, FALSE)))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_plus_bonus_excl_Top10 {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (${teams.handle} not in ('salesforce','uber','yahoo','shopify-scripts','riot','zenefits','twitter','ubnt','qualcomm','airbnb-vip','security','withinsecurity' ) and (NOT COALESCE(${teams.internet_bug_bounty}, FALSE)))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_plus_bonus_Top5 {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (${teams.handle} in ('salesforce','uber','yahoo','shopify-scripts','riot') and (NOT COALESCE(${teams.internet_bug_bounty}, FALSE)))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_plus_bonus_Top6_10 {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (${teams.handle} in ('zenefits','twitter','ubnt','qualcomm','airbnb-vip' ) and (NOT COALESCE(${teams.internet_bug_bounty}, FALSE)))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_plus_bonus_2016 {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2016-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2016-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

# dimension: bounty_plus_bonus_2017_dimension {
# type: number
# value_format: "$#,##0"
# sql: ${bounty_plus_bonus_2017}
# ;;
# }

  measure: bounty_bonus_amount_diff_2017vs2016
  {
    type: number
    value_format: "$#,##0"
    sql: ${bounty_plus_bonus_2017} - ${bounty_plus_bonus_2016}
      ;;
  }

  measure: bounty_bonus_percent_diff_2017vs2016
  {
    type: number
    value_format: "0%"
    sql: case when ${bounty_plus_bonus_2016} = 0 or ${bounty_plus_bonus_2016} = NULL then 1
      when ${bounty_plus_bonus_2017} = 0 or ${bounty_plus_bonus_2017} = NULL then 0
      else ${bounty_plus_bonus_2017} / ${bounty_plus_bonus_2016}-1 end
      ;;
  }

  measure: bounty_plus_bonus_2018 {
    type: sum
    value_format: "$#,##0"
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2018-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2018-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_count_2016 {
    type: count_distinct
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2016-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2016-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_count_2017 {
    type: count_distinct
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_count_2018 {
    type: count_distinct
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2018-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2018-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${id}
      ELSE NULL
      END
      ;;
  }

  measure: bounty_percent_diff_2017_vs_2016 {
    type: sum
    value_format: "#0%"
    sql: (${bounty_plus_bonus_2017_dim}-${bounty_plus_bonus_2016_dim})/${bounty_plus_bonus_2016_dim} ;;
  }

  measure: bounty_dollars_diff_2017_vs_2016 {
    type: sum
    value_format: "$#,##0"
    sql: (${bounty_plus_bonus_2017_dim}-${bounty_plus_bonus_2016_dim});;
  }

  dimension: bounty_plus_bonus_2016_dim {
    hidden: yes
    type: number
    value_format: "$#,##0"
    sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2016-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2016-01-01' + (1 || ' year')::INTERVAL)))))
      THEN ${bounties_plus_bonus_amount}
      ELSE NULL
      END
      ;;
  }

  dimension: category_teams_that_paid_2016 {
#type: count_distinct
  sql: case when ${bounty_plus_bonus_2016_dim} <> 0 then 'yes' else 'no' end
    ;;
}

measure: count_teams_that_paid_2016 {
  type: count_distinct
  sql: case when ${bounty_plus_bonus_2016_dim} <> 0 then ${teams.id} else null end
    ;;
}

measure: bounty_plus_bonus_2017 {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: bounty_plus_bonus_2017_format {
  type: sum
  value_format: "$#,##0"
  sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2017-01-01' + (1 || ' year')::INTERVAL)))))
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
  html: <p style="font-size:120%; text-align:center">{{ rendered_value }}</p>;;
}

dimension: bounty_plus_bonus_2017_dim {
  hidden: yes
  type: number
  value_format: "$#,##0"
  sql: CASE WHEN (((bounties.created_at) >= ((SELECT TIMESTAMP '2017-01-01')) AND (bounties.created_at) < ((SELECT (TIMESTAMP '2018-01-01' + (1 || ' year')::INTERVAL)))))
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

dimension: category_teams_that_paid_2017 {
#type: count_distinct
sql: case when ${bounty_plus_bonus_2017_dim} <> 0 then 'yes' else 'no' end
  ;;
}

measure: count_teams_that_paid_2017 {
  type: count_distinct
  sql: case when ${bounty_plus_bonus_2017_dim} <> 0 then ${teams.id} else null end
    ;;
}

#for ning report
measure: bounty_plus_bonus_exl_h1_IBB {
  type: sum
  value_format: "$#,##0"
  sql: CASE when
    (${teams.handle} <> 'security' AND teams.handle <> 'withinsecurity' OR teams.handle IS NULL) AND (NOT COALESCE(${teams.internet_bug_bounty}, FALSE))
    THEN ${bounties_plus_bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: less_than_base_bounty {
  type: count_distinct
  sql: case when ${bounties_plus_bonus_amount} < ${teams.base_bounty} then ${bounties.id}
    when ${teams.base_bounty} > 0 and ${bounties_plus_bonus_amount} is null then ${bounties.id}
    when ${teams.base_bounty} > 0 and ${bounties_plus_bonus_amount} = 0 then ${bounties.id} else null end
    ;;
}

measure: percentage_less_than_base_bounty {
  type: number
  value_format: "#0\%"
  sql: 100.00 * ${less_than_base_bounty}/NULLIF(${count},0) ;;
}

measure: total_financial_rewards_amount_last_week {
  type: sum
  value_format: "$#,##0"
  sql: case when ((((bounties.created_at) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL))) AND (bounties.created_at) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_MTD {
  type: sum
  value_format: "$#,##0"
  sql: case when (((bounties.created_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (bounties.created_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_201709 {
  type: sum
  value_format: "$#,##0"
  sql: case when (((bounties.created_at) >= (TIMESTAMP '2017-09-01') AND (bounties.created_at) < (TIMESTAMP '2017-10-01'))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_201803 {
  type: sum
  value_format: "$#,##0"
  sql: case when (((bounties.created_at) >= (TIMESTAMP '2018-03-01') AND (bounties.created_at) < (TIMESTAMP '2018-04-01'))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: bounties_count_MTD {
  type: count_distinct
  sql: (case when (((bounties.created_at) >= ((SELECT DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (bounties.created_at) < ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' month')::INTERVAL))))) then ${id} else null end)
    ;;
}

measure: total_financial_rewards_YTD {
  type: sum
  value_format: "$#,##0"
  sql: case when (((bounties.created_at) >= ((SELECT DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')))) AND (bounties.created_at) < ((SELECT (DATE_TRUNC('year', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (1 || ' year')::INTERVAL))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_today {
  type: sum
  value_format: "$#,##0"
  sql: case when ((((bounties.created_at) >= ((SELECT DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'))) AND (bounties.created_at) < ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (1 || ' day')::INTERVAL)))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_yesterday {
  type: sum
  value_format: "$#,##0"
  sql: case when ((((bounties.created_at) >= ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-1 || ' day')::INTERVAL))) AND (bounties.created_at) < ((SELECT ((DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (-1 || ' day')::INTERVAL) + (1 || ' day')::INTERVAL)))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

dimension: total_financial_rewards_today_dim {
  hidden: yes
  value_format: "$#,##0"
  sql: case when ((((bounties.created_at) >= ((SELECT DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC'))) AND (bounties.created_at) < ((SELECT (DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + (1 || ' day')::INTERVAL)))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

measure: total_financial_rewards_amount_avg {
  type: average
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

dimension: payment_id {
  type: number
  sql: ${TABLE}.payment_id ;;
}

dimension: user_id {
  type: number
  sql: ${TABLE}.user_id ;;
}

measure: count {
  type: count_distinct
  sql: ${id} ;;
}

#drill_fields: detail*

measure: sum {
  type: sum
  sql: ${bounties.amount} ;;
}

measure: bonus_sum {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties.bonus_amount} ;;
}

#for ning report
measure: bonus_exl_h1_IBB {
  type: sum
  value_format: "$#,##0"
  sql: CASE when
    (${teams.handle} <> 'security' AND teams.handle <> 'withinsecurity' OR teams.handle IS NULL) AND (NOT COALESCE(${teams.internet_bug_bounty}, FALSE))
    THEN ${bounties.bonus_amount}
    ELSE NULL
    END
    ;;
}

measure: amount_sum {
  type: sum
  value_format: "$#,##0.00"
  sql: ${amount} ;;
}

measure: sample_amount_sum {
#fake amount created for sales dashbaord
type: sum
value_format: "$#,##0"
sql: ${amount} *0.90 ;;
}

measure: amount_sum_integer {
  type: sum
  value_format: "$#,##0"
  sql: ${amount} ;;
}

#for ning report
measure: bounty_exl_h1_IBB {
  type: sum
  value_format: "$#,##0"
  sql: CASE when
    (${teams.handle} <> 'security' AND teams.handle <> 'withinsecurity' OR teams.handle IS NULL) AND (NOT COALESCE(${teams.internet_bug_bounty}, FALSE))
    THEN ${amount}
    ELSE NULL
    END
    ;;
}

measure: amount_avg {
  type: average
  value_format: "$#,##0"
  sql: ${amount} ;;
}

measure: running_bounty_total {
  type: running_total
  sql: ${total_financial_rewards_amount} ;;
}

dimension: days_public {
  type: number
  sql: date_part('days', now() - ${teams.became_public_date}) ;;
}

measure: minimum_created_at {
  type: time
  timeframes: [time, date]
  sql: min(${TABLE}.created_at) ;;
}

measure: days_from_first_launch_to_first_bounty {
  type: number
  sql: TRUNC(DATE_PART('day', (${TABLE}.minimum_created_at_date - min(${first.launch_raw}))))
    ;;
}

measure: count_created_date {
  type: count_distinct
  sql: ${bounties.created_date} ;;
}

measure: count_hackers_with_bounties {
  alias: [count_reporter_id]
  type: count_distinct
  sql: ${TABLE}.user_id ;;
}

measure: count_hackers_with_bounties_running_total {
  type: running_total
  sql: ${TABLE}.user_id ;;
}


measure: avg_monthly_bounty_spend {
  type: number
  value_format: "$#,##0"
  sql: ${total_financial_rewards_amount}/nullif(min(${first.months_since_team_first_launched}),0) ;;
}

measure: 5000_month_avg_bounty_spend {
  type: yesno
  sql: ${avg_monthly_bounty_spend} >= 5000 ;;
}

measure: bug_bounty_or_vdp {
  case: {
    when: {
      sql: ${total_financial_rewards_amount} > 0 ;;
      label: "bug bounty"
    }

    when: {
      sql: ${total_financial_rewards_amount} = 0 or ${total_financial_rewards_amount} is null ;;
      label: "vdp"
    }
  }
}

measure: 25th_percentile {
  type: percentile
  percentile: 25
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 50th_percentile {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 50th_percentile_L90d {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
  filters: {
    field: created_date
    value: "90 days"
  }
}

filter: customer {
  type: string
  suggest_dimension: teams.handle
}

dimension: customer_filter {
  type: yesno
  hidden: yes
  sql: {% condition customer%} ${teams.handle} {% endcondition %} ;;
}

measure: sum_bounty_handle {
  type: sum
  sql: ${bounties_plus_bonus_amount} ;;
  value_format_name: usd_0
  filters: {
    field: customer_filter
    value: "yes"
  }
}


measure: 50th_percentile_handle {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  label: "50th percentile bounty$"
  sql: ${bounties_plus_bonus_amount} ;;
  filters: {
    field: customer_filter
    value: "yes"
  }
}

measure: 50th_percentile_top_20 {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  label: "50th percentile bounty$ (top 20)"
  sql: case when ${team_2018_bounty_rank.team_bounty_rank} <= 20 then ${bounties_plus_bonus_amount} else null end;;
}

measure: 95th_percentile_handle {
  type: percentile
  percentile: 95
  value_format: "$#,##0"
  label: "95th percentile bounty$"
  sql: ${bounties_plus_bonus_amount} ;;
  filters: {
    field: customer_filter
    value: "yes"
  }
}

measure: 95th_percentile_top_20 {
  type: percentile
  percentile: 95
  value_format: "$#,##0"
  label: "95th percentile bounty$ (top 20)"
  sql: case when ${team_2018_bounty_rank.team_bounty_rank} <= 20 then ${bounties_plus_bonus_amount} else null end;;
}


measure: 50th_percentile_2017 {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  sql: case when ${created_year} = 2017 then ${bounties_plus_bonus_amount} end ;;
}

measure: 50th_percentile_2016 {
  type: percentile
  percentile: 50
  value_format: "$#,##0"
  sql: case when ${created_year} = 2016 then ${bounties_plus_bonus_amount} end ;;
}

measure: median_bounty_amount_diff_2017vs2016 {
  type: number
  value_format: "$#,##0"
  sql: coalesce(${50th_percentile_2017},0)- coalesce(${50th_percentile_2016} ,0);;
}

measure: median_bounty_percent_diff_2017vs2016 {
  type: number
  value_format: "#0%"
  sql: case when ${50th_percentile_2016} = 0 or ${50th_percentile_2016} is NULL then 1
    when ${50th_percentile_2017} = 0 or ${50th_percentile_2017} is NULL then 0
    else ${50th_percentile_2017}/ ${50th_percentile_2016}-1 end;;
}

measure: 55th_percentile {
  type: percentile
  percentile: 55
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 60th_percentile {
  type: percentile
  percentile: 60
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 65th_percentile {
  type: percentile
  percentile: 65
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 70th_percentile {
  type: percentile
  percentile: 70
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 75th_percentile {
  type: percentile
  percentile: 75
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 80th_percentile {
  type: percentile
  percentile: 80
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 85th_percentile {
  type: percentile
  percentile: 85
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 90th_percentile {
  type: percentile
  percentile: 90
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 95th_percentile {
  type: percentile
  percentile: 95
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: 99th_percentile {
  type: percentile
  percentile: 99
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount} ;;
}

measure: percent_rank_bounty_ytd {
  type: number
  sql: row_number() over (partition by ${reports.reporter_id} order by ${total_financial_rewards_YTD} desc) ;;
}

measure: total_financial_rewards_l12m {
  type: sum
  value_format: "$#,##0"
  sql: case when ((((bounties.created_at) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-11 || ' month')::INTERVAL))) AND (bounties.created_at) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-11 || ' month')::INTERVAL) + (12 || ' month')::INTERVAL)))))) then ${bounties_plus_bonus_amount} else null end
    ;;
}

# dimension: total_financial_rewards_l12m_HS_tier {
# type: tier
# style: integer
# value_format: "$#,##0"
# sql: ${total_financial_rewards_l12m};;
# tiers: [
# 0,
# 200,
# 5000,
# 25000
# ]
# }



measure: total_financial_rewards_l90d {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;

  filters: {
    field: created_date
    value: "90 days"
  }

}

measure: bounty_count_l90d {
  type: count_distinct
  value_format_name:decimal_0
  sql: ${bounties.id};;

  filters: {
    field: created_date
    value: "90 days"
  }

}

measure: total_financial_rewards_l30d {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;

  filters: {
    field: created_date
    value: "30 days"
  }

}
measure: total_financial_rewards_l90d_format {
  type: sum
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;

  filters: {
    field: created_date
    value: "90 days"
  }
  html: <p style="font-size:120%; text-align:center">{{ rendered_value }}</p>;;

}

measure: total_financial_rewards_l90d_format_cond {
  type: sum
  label: "$ bounty L90d"
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;
  drill_fields: [ bounties_plus_bonus_amount, teams.handle, created_date, report_id, reports.severity_rating]
  filters: {
    field: created_date
    value: "90 days"
  }
  html: {% if value < 5000 %}
    <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% else %}
    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% endif %}
    ;;
}

measure: total_financial_rewards_l12m_format_cond {
  type: sum
  label: "$ bounty L12m"
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;
  drill_fields: [ bounties_plus_bonus_amount, teams.handle, created_date, report_id, reports.severity_rating]
  filters: {
    field: created_date
    value: "365 days"
  }
  html: {% if value < 60000 %}
    <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% else %}
    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% endif %}
    ;;
}

# dimension: total_financial_rewards_l12m_tier {
# label: "$ bounty L12m tiers"
# type: tier
# tiers: [5000, 10000, 20000, 50000,100000,200000,500000]
# # the default value, could be excluded
# style: integer
# sql: ${total_financial_rewards_l12m_format_cond}::int ;;
#
# }


measure: average_financial_rewards_l90d_format_cond {
  type: average
  label: "$ avg bounty L90d"
  value_format: "$#,##0"
  sql: ${bounties_plus_bonus_amount};;
  drill_fields: [ bounties_plus_bonus_amount, teams.handle, created_date, report_id, reports.severity_rating]
  filters: {
    field: created_date
    value: "90 days"
  }
  html: {% if value < 500 %}
    <p style="color: black; background-color: tomato; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% else %}
    <p style="color: black; background-color: lightgreen; border-radius: 25px; font-size:120%; text-align:center"> <a href: {{linked_value}} </a></p>
    {% endif %}
    ;;
}


measure: bounties_count_l12m {
  type: count_distinct
  sql: case when ((((bounties.created_at) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-11 || ' month')::INTERVAL))) AND (bounties.created_at) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'UTC')) + (-11 || ' month')::INTERVAL) + (12 || ' month')::INTERVAL)))))) then ${id} else null end
    ;;
}

measure: meets_bounty_goal_mtd {
  alias: [meets_bounty_goal]
  type: number
  sql: case when ${bounties.total_financial_rewards_MTD}>= ${teams.goal_budget} then 1 else 0 end ;;
}

measure: meets_bounty_goal_l30d {
  alias: [meets_bounty_goal]
  type: number
  sql: case when ${bounties.total_financial_rewards_l30d}>= ${teams.goal_budget} then 1 else 0 end ;;
}



}
