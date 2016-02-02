window.Map = class Map
  constructor: () ->
    @initMap()

  initMap: ->
    north_east = L.latLng(84.47, 92.46)
    south_west = L.latLng(-47.63, -45.52)
    bounds = L.latLngBounds(south_west, north_east)
    window.map = map = new L.Map('map', {
      zoomControl: false,
      center: [30, 20],
      maxBounds: bounds,
      zoom: 3
    })

    access_token = 'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2lqeTZ4OXVjMDAzcHYwbTAwbnN3em1kciJ9.cpj6r3ALYSoESrl6dbkb0A'
    L.tileLayer("https://api.mapbox.com/v4/unepwcmc.8ac2cdd1/{z}/{x}/{y}.png?access_token=#{access_token}").addTo(map)

    @addLayer(map)

  addLayer: (map) ->
    countries_css = @generateCartocss(DemoUtils.countries)
    countries_list = @parseCountries()

    cartodb.createLayer(map, {
      user_name: 'carbon-tool',
      type: 'cartodb',
      sublayers: [{
        sql: "SELECT * FROM ne_countries WHERE admin IN (#{countries_list})",
        cartocss: countries_css
      }]
    })
    .addTo(map)

  parseCountries: ->
    countries_array = []

    for key, value of DemoUtils.countries
      countries_array.push("'#{value.join("','")}'")

    countries_list = countries_array.join(',')

  generateCartocss: (countries) ->
    submitted_css = ''
    not_answered_css = ''
    not_required_css = ''
    for key, value of countries
      for country, index in value
        if key.indexOf('submitted') > -1
          submitted_css += "[admin='#{country}'],"
        else if key.indexOf('not_answered') > -1
          not_answered_css += "[admin='#{country}'],"
        else
          not_required_css += "[admin='#{country}'],"

    submitted_css += "{ polygon-fill: #2C53a7; }"
    not_answered_css += "{ polygon-fill: #E17D2E; } "
    not_required_css += "{ polygon-fill: #858585; }"
    countries_css = submitted_css + not_answered_css + not_required_css

