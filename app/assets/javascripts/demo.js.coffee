window.Demo = class Demo
  constructor: ->
    @initCharts()
    @respondents = []

  initCharts: ->
    @getData((data) =>
      @parseRespondents(data)
      new Map()
      @submissionChart()
      #@habitatConservationChart()
      #@leadShotChart()
      @illegalTakingChart()
      #@catchOfSeabirdsChart()
      #@awarenessChart()
    )

  submissionChart: ->
    data = new google.visualization.arrayToDataTable([
      ['Region', 'Submitted', 'Not answered', 'Not required'],
      ['Africa', 14, 18, 3],
      ['Eurasia', 25, 14, 1]
    ])

    options = {
      legend: {position: 'none'},
      height: 500,
      colors: ['#2c53a7', '#e17d2e', '#858585'],
      vAxis: {
        viewWindow: {
          min: 0,
          max: 35
        },
        ticks: [0, 5, 10, 15, 20, 25, 30, 35],
        gridlines: {color: '#d6d6d6', count: 1},
        minorGridlines: {color: '#f1f1f1', count: 4}
      },
      hAxis: {
        gridlines: {color: '#d6d6d6', count: 1},
        minorGridlines: {color: '#f1f1f1', count: 4}
      },
      annotations: {
        alwaysOutside: true,
        textStyle: {
          fontSize: 14
        },
      },
    }


    chart = new google.charts.Bar(document.getElementById('submission_chart'))
    chart.draw(data, options)

  habitatConservationChart: ->
    bar_chart = new DemoBarChart(@respondents, 5113)

  leadShotChart: ->
    column_chart = new ColumnChart(@respondents, 5002)

  illegalTakingChart: ->
    pie_chart = new PieChart(@respondents, 5020)

  catchOfSeabirdsChart: ->
    column_chart = new ColumnChart(@respondents, 4472)

  awarenessChart: ->
    column_chart = new ColumnChart(@respondents, 4808)

  getData: (next) ->
    params = {}
    params['callback'] = next
    DemoUtils.ajaxRequest(params)

  parseRespondents: (data) =>
    respondents = data.questionnaire.respondents
    respondents_by_country = []
    for r in respondents
      if r.respondent.status == 'Submitted'
        respondent = DemoUtils.parseRespondentCountry(r.respondent.full_name)
        respondents_by_country.push respondent if respondent
    @respondents = respondents_by_country


$(document).on 'ready page:load', ->
  $.support.cors = true
  google.setOnLoadCallback =>
    new Demo()
