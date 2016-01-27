window.ColumnChart = class ColumnChart
  constructor: (@respondents) ->
    @params = {}
    @initChart()

  initChart: ->
    @params['question_id'] = '/questions/5002'
    @params['callback'] = @buildChart

  buildChart: (data) =>
   chart_data = @parseData(data)
   @drawChart(chart_data)

  drawChart: (chart_data) ->
    debugger
    data = new google.visualization.arrayToDataTable(chart_data)

    options = {
      width: 900,
      chart: {
        title: 'A titlte'
        subtitle: 'A subtitle'
      },
      vAxis: {
        viewWindow: {
          min: 0,
          max: 35
        },
        ticks: [0, 5, 10, 15, 20, 25, 30, 35]
      }
    }

    chart = new google.visualization.ColumnChart(document.getElementById('column_chart_div'))
    chart.draw(data,options)

  parseData: (data) ->
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
    new_hash = {}
    answers = []
    for key in keys
      @countHash(new_hash, hash[key])

    new_keys = Object.keys(new_hash)
    for key in new_keys
      answers.push [key, new_hash[key]]

    @addData(answers)
    answers

  countHash: (hash, key) ->
    if hash[key]
      hash[key]++
    else
      hash[key] = 1

  addData: (answers) ->
    answers.unshift(['Element', 'Density'])
    answers.push(['Not answered', 32])
