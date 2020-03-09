view: disclosures {
  derived_table: {
    sql:
      select
      'this is a really long disclosure this'
--is a really long disclosure this is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really '
-- long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurthis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis'
--is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosurethis is a really long disclosure'
      as 'disclosure_1'
      ;;
  }

  dimension: disclosure_1 {
    type: string
    sql: ${TABLE}.'disclosure_1' ;;
    html:
    {% assign words = {{value}} | split: ' ' %}
    {% assign numwords = 0 %}
    {% for word in words %}
    {{ word }}
    {% assign numwords = numwords | plus: 1 %}
    {% assign mod = numwords | modulo: 16 %}
    {% if mod == 0 %}
    <br>
    {% endif %}
    {% endfor %} ;;
  }
}
explore: disclosures {}
