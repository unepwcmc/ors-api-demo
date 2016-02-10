window.DemoBarChart = class DemoBarChart extends Chart
  constructor: (@respondents) ->
    @data = []
    @questions = {
      5007: 'international_total',
      4997: 'international_protected',
      4989: 'international_with_management',
      4726: 'national_total',
      4581: 'national_protected',
      4679: 'national_with_management',
      4801: 'international_area',
      4459: 'national_area'
    }
    containers = ['total_sites', 'nationally_important_sites', 'internationally_important_sites']

    super(@respondents, Object.keys(@questions), containers[0])

  initChart: (data) ->
    @data.push(@parseData(data))
    if DemoUtils.questions_ids.length > 0
      DemoUtils.question_id = DemoUtils.questions_ids.shift()
      params = {
        question_id: "/questions/#{DemoUtils.question_id}",
        callback: @initChart
      }
      DemoUtils.ajaxRequest(params)
    else
      $("##{@container}").removeClass("loading")
      @drawChart(@data)

  parseData: (data) ->
    chart_data = super(data)
    chart_data['question_id'] = DemoUtils.question_id
    chart_data


  drawChart: (chart_data) ->
    gathered_data = @gatherData(chart_data)
    for key, partial_data of gathered_data
      options = {
        total_sites: {
          title: "Total for both nationally and internationally important sites",
          height: 200,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' },
          displayAnnotations: true,
          annotations: {}
        },
        nationally_important_sites: {
          title: "Nationally important sites",
          height: 200,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' },
          legend: { position: 'bottom' },
          displayAnnotations: true,
          annotations: {}
        },
        internationally_important_sites: {
          title: "Internationally important sites",
          height: 200,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' },
          annotations: {},
          displayAnnotations: true
        }
      }
      @drawPartial(partial_data, key, options[key])

  displayArea: (answers) ->
    national_sites = DemoUtils.numberWithCommas(answers.national_total)
    $('.national-sites .num-sites').append(national_sites)
    national_area = "#{DemoUtils.numberWithCommas(answers.national_area)} ha"
    $('.national-area .area-sites').append(national_area)
    international_sites = DemoUtils.numberWithCommas(answers.international_total)
    $('.international-sites .num-sites').append(international_sites)
    international_area = "#{DemoUtils.numberWithCommas(answers.international_area)} ha"
    $('.international-area .area-sites').append(international_area)

  drawPartial: (partial_data, container, options) ->
    data = new google.visualization.arrayToDataTable(partial_data)
    chart = new google.visualization.BarChart(document.getElementById(container))
    chart.draw(data,options)

  gatherData: (chart_data) ->
    answers = {}

    for data in chart_data
      question = @questions[data.question_id]
      answers[question] = @getTotal(data.answers)

    answers['total'] = {
      total: answers.international_total + answers.national_total,
      protected: answers.international_protected + answers.national_protected,
      with_management: answers.international_with_management + answers.national_with_management
    }

    @displayArea(answers)
    @answersToArray(answers)

  answersToArray: (answers) ->
    # Answers added to array twice, once for data, once for annotation
    national = [ answers.national_total, DemoUtils.numberWithCommas(answers.national_total),
                  answers.national_protected, DemoUtils.numberWithCommas(answers.national_protected),
                  answers.national_with_management, DemoUtils.numberWithCommas(answers.national_with_management) ]
    international = [ answers.international_total, DemoUtils.numberWithCommas(answers.international_total),
                      answers.international_protected, DemoUtils.numberWithCommas(answers.international_protected),
                      answers.international_with_management, DemoUtils.numberWithCommas(answers.international_with_management)]
    total = [ answers.total.total, DemoUtils.numberWithCommas(answers.total.total),
              answers.total.protected, DemoUtils.numberWithCommas(answers.total.protected),
              answers.total.with_management, DemoUtils.numberWithCommas(answers.total.with_management)]
    data = {
      nationally_important_sites: national,
      internationally_important_sites: international,
      total_sites: total
    }
    @addMetaData(data)

  addMetaData: (data) ->
    keys = Object.keys(data)
    metadata = ['Sites', 'Total', {type: 'string', role: 'annotation'}, 'Protected', {type: 'string', role: 'annotation'}, 'Protected with management', {type: 'string', role: 'annotation'}]
    for key in keys
      data[key].unshift('Sites')
      data[key] = [metadata, data[key]]
    data

  getTotal: (hash) ->
    values = (value for own prop, value of hash)
    total = values.reduce (t, s) ->
      s = s[0].match(/\d/g).join("")
      parseInt(t, 10) + parseInt(s, 10)

  addData: (answers) ->
