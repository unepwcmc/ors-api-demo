window.Demo = class Demo
  constructor: ->
    @initCharts()
    @respondents = []

  initCharts: ->
    @getData((data) =>
      @parseRespondents(data)
      @submissionChart()
      #@habitatConservationChart()
      @leadShotChart()
      #@illegalTakingChart()
      #@catchOfSeabirdsChart()
      #@awarenessChart()
    )

  ajaxRequest: (params) ->
    base_url = 'http://cms-ors-api.ort-staging.linode.unep-wcmc.org/api/v1/questionnaires/48'
    respondents = []

    $.ajax
      url: base_url + params['question_id']
      data: params['data']
      type: 'GET'
      dataType: 'json'
      contentType: 'text/plain'
      beforeSend: (request) ->
        request.setRequestHeader("X-Authentication-Token", 'VJSsaKTayZgIkZCM4')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) =>
        params['callback'](data)

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
    params['question_id'] = '/questions/5113'
    @ajaxRequest(params)

  leadShotChart: ->
    column_chart = new ColumnChart(@respondents, 5002)
    @ajaxRequest(column_chart.params)

  illegalTakingChart: ->
    pie_chart = new PieChart(@respondents)
    @ajaxRequest(pie_chart.params)

  catchOfSeabirdsChart: ->
    column_chart = new ColumnChart(@respondents, 4472)
    @ajaxRequest(column_chart.params)

  awarenessChart: ->
    column_chart = new ColumnChart(@respondents, 4808)
    @ajaxRequest(column_chart.params)

  getData: (next) ->
    params = {}
    params['callback'] = next
    params['sync'] = 'sync'
    @ajaxRequest(params)

  parseRespondents: (data) =>
    respondents = data.questionnaire.respondents
    respondents_by_country = []
    for r in respondents
      if r.respondent.status == 'Submitted'
        respondent = @parseRespondentCountry(r.respondent.full_name)
        respondents_by_country.push respondent if respondent
    @respondents = respondents_by_country

  parseRespondentCountry: (respondent) ->
    country = respondent.split(':')[1]
    if country
      country.trim()
    else
      null


$(document).on 'ready page:load', ->
  $.support.cors = true
  google.setOnLoadCallback =>
    new Demo()
