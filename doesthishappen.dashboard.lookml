- dashboard: doesthishappen
  title: Doesthishappen
  layout: tile
  tile_size: 100

  filters:

  elements:
    - name: add_a_unique_name_1551748891
      title: Untitled Visualization
      model: derpinthesme
      explore: secondexplore
      type: table
      series_colors: red
      series_name: firstexplorecolor
      fields: [secondexplore.id, secondexplore.user_id]
      limit: 500
      query_timezone: America/New_York
      limit: 500
      query_timezone: America/New_York
      series_types: {}
    - name: add_a_unique_name_1551749246
      title: Untitled Visualization
      model: derpinthesme
      explore: firstexplore
      type: looker_column
      series_colors: red
      series_name: firstexplorecolor
      # Possibly more series color assignments
      series_labels:
      series_name: desired series label
      fields: [firstexplore.id, firstexplore.user_id]
      limit: 500
      query_timezone: America/New_York
      series_types: {}
