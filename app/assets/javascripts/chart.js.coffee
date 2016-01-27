window.Chart = class Chart
  constructor: (@respondents, question_id) ->
    @params = {
      question_id: question_id,
      callback: @initChart
    }

  initChart: (data) =>
    chart_data = @parseData(data)
    @drawChart(chart_data)

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

  hashToArray: (hash, row_data) ->
    keys = Object.keys(hash)
    new_hash = {}
    answers = []
    for key in keys
      @countHash(new_hash, hash[key])

    new_keys = Object.keys(new_hash)
    for key in new_keys
      answers.push [key, new_hash[key]]

    @addData(answers)

    if row_data
      row_answers = @addRowData(new_keys, new_hash)
      data = {
        answers: answers,
        row_answers: row_answers
      }
    else
      answers

  countHash: (hash, key) ->
    if hash[key]
      hash[key]++
    else
      hash[key] = 1

  addRowData: (keys, hash) ->
    values = (value for own prop, value of hash)
    keys.unshift ''
    values.unshift 'Answer'
    keys.push 'Not answered'
    values.push 32
    keys.push {role: 'annotation'}
    values.push ''
    [keys, values]
