window.Demo = class Demo
  constructor: ->
    @initCharts()
    @respondents = []

  initCharts: ->
    @getData((data) =>
      @parseRespondents(data)
      @submissionStats()
      new Map()
      @submissionChart()
      @habitatConservationChart()
      @leadShotChart()
      @illegalTakingChart()
      @catchOfSeabirdsChart()
      @awarenessChart()
    )

  submissionStats: ->
    num_countries = 0
    for key, value of DemoUtils.countries
      if key.indexOf('not_required') < 0
        num_countries += value.length

    num_respondents = @respondents.length
    percentage = Math.round((num_respondents / num_countries) * 100)
    $('.percentage-submitted').html("#{percentage}%")
    $('.num-submitted').html("#{num_respondents}/#{num_countries}")

  submissionChart: ->
    countries = DemoUtils.countries
    submitted_africa = countries.submitted_africa.length
    submitted_eurasia = countries.submitted_eurasia.length
    not_answered_africa = countries.not_answered_africa.length
    not_answered_eurasia = countries.not_answered_eurasia.length
    not_required_africa = countries.not_required_africa.length
    not_required_eurasia = countries.not_required_eurasia.length

    stats_africa = ['Africa', submitted_africa, not_answered_africa, not_required_africa]
    stats_eurasia = ['Eurasia', submitted_eurasia, not_answered_eurasia, not_required_eurasia]

    data = new google.visualization.arrayToDataTable([
      ['Region', 'Submitted', 'Not answered', 'Not required'],
      stats_africa,
      stats_eurasia
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
    questions_ids = [5007, 4997, 4989, 4726, 4581, 4679]
    bar_chart = new DemoBarChart(@respondents, questions_ids, ['total_sites', 'nationally_important_sites', 'internationally_important_sites'])

  leadShotChart: ->
    column_chart = new ColumnChart(@respondents, 5002, 'lead_shot_chart')

  illegalTakingChart: ->
    pie_chart = new PieChart(@respondents, 5020, 'illegal_taking_chart')

  catchOfSeabirdsChart: ->
    column_chart = new ColumnChart(@respondents, 4472, 'seabirds_chart')

  awarenessChart: ->
    column_chart = new ColumnChart(@respondents, 4808, 'awareness_chart')

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
