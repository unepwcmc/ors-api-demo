window.DemoUtils = class DemoUtils
  @ajaxRequest: (params) ->
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

  @parseRespondentCountry: (respondent) ->
    country = respondent.split(':')[1]
    if country
      country.trim()
    else
      null

