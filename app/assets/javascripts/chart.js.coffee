window.Chart = class Chart
  constructor: (@respondents, @question_id, @container) ->
    @params = {
      question_id: @question_id,
      callback: @initChart
    }
    DemoUtils.processRequest(@params)

  initChart: (data) =>
    chart_data = @parseData(data)
    $("##{@container}").removeClass("loading")
    @drawChart(chart_data)

  parseData: (data) ->
    answers = data.question.answers
    answers_by_country = {}
    for a in answers
      respondent = DemoUtils.parseRespondentCountry(a.answer.respondent)
      if respondent and respondent in @respondents
        answers_by_country[respondent] = a.answer.answer_text
    @hashToArray(answers_by_country)

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

    data = {
      answers: answers
    }
    data['row_answers'] = @addRowData(new_keys, new_hash) if row_data
    data['target'] = @addTarget(new_keys, new_hash) unless @question_id == '/questions/4472'
    data

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
    [keys, values]

  addTarget: (keys, hash) ->
    progress = 0
    remainder = 0
    for key in keys
      if hash[key]
        if key in ['Fully', 'Partially', 'Yes, being implemented']
          progress += hash[key]
        else
          remainder += hash[key]

    remainder += 32
    progress_percentage = Math.round((progress / (progress + remainder)) * 100)
    keys = ['', 'Progress', {role: 'annotation'}, 'Target']
    values = ['Progress', progress, "#{progress_percentage}%", remainder]
    [keys, values]

