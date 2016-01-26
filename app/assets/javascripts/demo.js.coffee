window.Demo = class Demo
  constructor: ->
    @initCharts()
    @respondents = []

  initCharts: ->
    @getRespondents()
    #@submissionChart()
    #@habitatConservationChart()
    #@leadShotChart()
    @illegalTakingChart()
    #@catchOfSeabirdsChart()
    #@awarenessChart()

  ajaxRequest: (params) ->
    base_url = 'http://cms-ors-api.ort-staging.linode.unep-wcmc.org/api/v1/questionnaires/48'
    respondents = []

    $.ajax
      url: base_url + params['question_id']
      data: params['data']
      type: 'GET'
      dataType: 'json'
      async: false
      contentType: 'text/plain'
      beforeSend: (request) ->
        request.setRequestHeader("X-Authentication-Token", 'VJSsaKTayZgIkZCM4')
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "AJAX Error: #{textStatus}"
      success: (data, textStatus, jqXHR) =>
        respondents = params['callback'](data)

    respondents

  habitatConservationChart: ->
    params['question_id'] = '/questions/5113'
    @ajaxRequest(params)

  leadShotChart: ->
    params['question_id'] = '/questions/5002'
    @ajaxRequest(params)

  illegalTakingChart: ->
    params = {}
    params['question_id'] = '/questions/5020'
    params['callback'] = @parseYesOrNo
    @ajaxRequest(params)

  catchOfSeabirdsChart: ->
    params['question_id'] = '/questions/4472'
    @ajaxRequest(params)

  awarenessChart: ->
    params['question_id'] = '/questions/4808'
    @ajaxRequest(params)

  getRespondents: ->
    params = {}
    params['callback'] = @parseRespondents
    @ajaxRequest(params)

  parseRespondents: (data) =>
    respondents = data.questionnaire.respondents
    respondents_by_country = []
    for r in respondents
      if r.respondent.status == 'Submitted'
        respondent = @parseRespondentCountry(r.respondent.full_name)
        respondents_by_country.push respondent if respondent
    @constructor.respondents = respondents_by_country

  parseYesOrNo: (data) =>
    res = @constructor.respondents
    debugger
    answers = data.question.answers
    answers_by_country = {}
    for a in answers
      respondent = @parseRespondentCountry(a.answer.respondent)
      if respondent and respondent in @constructor.respondents
        answers_by_country[respondent] = a.answer.answer_text

  parseRespondentCountry: (respondent) ->
    country = respondent.split(':')[1]
    if country
      country.trim()
    else
      null


$(document).on 'ready page:load', ->
  $.support.cors = true
  new Demo()
