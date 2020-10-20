view: sort_bug {
 derived_table: {
   sql:
  select 'A' as foo, 'Test String' as s1, 'string a' as s2
  UNION ALL
  select 'a' as foo, 'Test String' as s1, 'string b' as s2
  UNION ALL
  select 'B' as foo, 'Test String' as s1, 'string a' as s2
  UNION ALL
  select 'b' as foo, 'Test String' as s1, 'string b' as s2
  UNION ALL
  select 'C' as foo, 'Test String' as s1, 'string a' as s2
  UNION ALL
  select 'c' as foo, 'Test String' as s1, 'string b' as s2
  ;;
 }

dimension: foo {
  type: string
}

dimension: s1 {
  type: string
}

dimension: s2 {
  type: string
}

}

explore: sort_bug {}
