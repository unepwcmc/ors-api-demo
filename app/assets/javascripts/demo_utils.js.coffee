window.DemoUtils = {
  base_url: 'http://cms-ors-api.ort-staging.linode.unep-wcmc.org/api/v1/questionnaires/48'

  questions_ids: []

  processRequest: (params) ->
    if params.question_id instanceof Array
      DemoUtils.questions_ids = params.question_id
      question_id = DemoUtils.questions_ids.shift()
      request_params =  {
        question_id: "/questions/#{question_id}",
        callback: params.callback
      }
      DemoUtils.ajaxRequest(request_params)
    else
      DemoUtils.ajaxRequest(params)

  ajaxRequest: (params) ->

    $.ajax
      url: DemoUtils.base_url + params['question_id']
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

  parseRespondentCountry: (respondent) ->
    country = respondent.split(':')[1]
    if country
      country.trim()
    else
      null

}
