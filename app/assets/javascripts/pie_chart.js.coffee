window.PieChart = class PieChart
  constructor: (@respondents) ->
    @params = {}
    @initChart()

  initChart: ->
    @params['question_id'] = '/questions/5020'
    @params['callback'] = @buildChart

  buildChart: (data) =>
    chart_data = @parseYesOrNo(data)
    @drawChart(chart_data)

  drawChart: (chart_data) ->
    data = new google.visualization.DataTable()
    data.addColumn('string', 'Answers')
    data.addColumn('number', 'Counts')
    data.addRows(chart_data)

    options = {
      'title':'A title',
      'width':400,
      'height':300
    }

    chart = new google.visualization.PieChart(document.getElementById('pie_chart_div'))
    chart.draw(data, options)


  parseYesOrNo: (data) ->
    answers = data.question.answers
    answers_by_country = {}
    for a in answers
      respondent = @parseRespondentCountry(a.answer.respondent)
      if respondent and respondent in @respondents
        answers_by_country[respondent] = a.answer.answer_text
    @hashToArray(answers_by_country)

  parseRespondentCountry: (respondent) ->
    country = respondent.split(':')[1]
    if country
      country.trim()
    else
      null

  hashToArray: (hash) ->
    keys = Object.keys(hash)
    answers = []
    yeses = 0
    nos = 0
    for key in keys
      if hash[key] == 'Yes'
        yeses++
      else if hash[key] == 'No'
        nos++
    answers = [ ['Yes', yeses], ['No', nos], ['Not answered', 32] ]


  countHash: (hash, key) ->
    if hash[key]
      hash[key]++
    else
      hash[key] = 1


