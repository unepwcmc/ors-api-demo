window.Map = class Map
  constructor: () ->
    @initMap()

  initMap: ->
    map = new L.Map('map', {
      zoomControl: false,
      center: [30, 20],
      zoom: 3
    })

    access_token = 'pk.eyJ1IjoidW5lcHdjbWMiLCJhIjoiY2lqeTZ4OXVjMDAzcHYwbTAwbnN3em1kciJ9.cpj6r3ALYSoESrl6dbkb0A'
    L.tileLayer("https://api.mapbox.com/v4/unepwcmc.8ac2cdd1/{z}/{x}/{y}.png?access_token=#{access_token}").addTo(map)

    @addLayer(map)

  addLayer: (map) ->
    countries = @getCountries()
    countries_css = @generateCartocss(countries)
    countries_array = []

    for key, value of countries
      countries_array.push("'#{value.join("','")}'")

    countries_list = countries_array.join(',')

    cartodb.createLayer(map, {
      user_name: 'carbon-tool',
      type: 'cartodb',
      sublayers: [{
        sql: "SELECT * FROM ne_countries WHERE admin IN (#{countries_list})",
        cartocss: countries_css
      }]
    })
    .addTo(map)

  getCountries: ->
    countries = {
      submitted_africa: ['Morocco', 'Kenya', 'South Africa', 'Ghana', 'Tunisia',
                         'Uganda', 'Nigeria', 'Mali', 'Libya', 'Madagascar', 'Ethiopia',
                         'Algeria', 'Sudan', 'Swaziland'],

      submitted_eurasia: ['Albania', 'Bulgaria', 'Moldova', 'France', 'Sweden', 'Slovenia',
                          'Slovakia', 'United Kingdom', 'Croatia', 'Netherlands', 'Latvia',
                          'Cyprus', 'Luxembourg', 'Switzerland', 'Hungary', 'Czech Republic',
                          'Montenegro', 'Denmark', 'Syria', 'Estonia', 'Italy', 'Ukraine',
                          'Belgium', 'Norway', 'Germany'],

      not_answered_africa: ['Benin', 'Burkina Faso', 'Chad', 'Republic of the Congo',
                            'Ivory Coast', 'Djibouti', 'Egypt', 'Equatorial Guinea',
                            'Gabon', 'Gambia', 'Guinea', 'Guinea Bissau', 'Mauritius',
                            'Niger', 'Senegal', 'Togo', 'United Republic of Tanzania',
                            'Zimbabwe'],

      not_answered_eurasia: ['Finland', 'Macedonia', 'Georgia', 'Iceland', 'Ireland',
                             'Israel', 'Jordan', 'Lebanon', 'Lithuania', 'Monaco', 'Portugal',
                             'Romania', 'Spain', 'Uzbekistan'],

      not_required_africa: ['Burundi', 'Mauritania', 'Rwanda'],

      not_required_eurasia: ['The European Union']

    }

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

