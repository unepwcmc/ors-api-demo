window.Demo = class Demo
  constructor: ->
    @initCharts()
    @respondents = []

  initCharts: ->
    @getData((data) =>
      @parseRespondents(data)
      #@submissionChart()
      #@habitatConservationChart()
      #@leadShotChart()
      @illegalTakingChart()
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

  habitatConservationChart: ->
    params['question_id'] = '/questions/5113'
    @ajaxRequest(params)

  leadShotChart: ->
    params['question_id'] = '/questions/5002'
    @ajaxRequest(params)

  illegalTakingChart: ->
    pie_chart = new PieChart(@respondents)
    @ajaxRequest(pie_chart.params)

  catchOfSeabirdsChart: ->
    params['question_id'] = '/questions/4472'
    @ajaxRequest(params)

  awarenessChart: ->
    params['question_id'] = '/questions/4808'
    @ajaxRequest(params)

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
