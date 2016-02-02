window.DemoUtils = {
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

  base_url: 'http://cms-ors-api.ort-staging.linode.unep-wcmc.org/api/v1/questionnaires/48'

  questions_ids: [],

  countries: {
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
}
