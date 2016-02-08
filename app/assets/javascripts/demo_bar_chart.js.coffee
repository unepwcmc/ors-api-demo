window.DemoBarChart = class DemoBarChart extends Chart
  constructor: (@respondents, @question_id, @containers) ->
    @data = []
    super(@respondents, @question_id, @containers[0])

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
          height: 100,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' }
        },
        nationally_important_sites: {
          title: "Nationally important sites",
          height: 100,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' }
          legend: { position: 'bottom' },
        },
        internationally_important_sites: {
          title: "Internationally important sites",
          height: 100,
          colors: ['#b08c58', '#6d88c4', '#2c53a7'],
          legend: { position: 'bottom' },
          hAxis: {
            gridlines: { color: '#d6d6d6' },
            minorGridlines: { color: '#f1f1f1' },
            textPosition: 'none',
            maxValue: 200000
          },
          vAxis: { textPosition: 'none' }
        }
      }
      @drawPartial(partial_data, key, options[key])

  displayArea: (data, area) ->
   national_sites = data.nationally_important_sites
   international_sites = data.internationally_important_sites

   $('.nationally-important').append(area.nationally_important_area)
   $('.internationally-important').append(area.internationally_important_area)

  drawPartial: (partial_data, container, options) ->
    data = new google.visualization.arrayToDataTable(partial_data)
    chart = new google.visualization.BarChart(document.getElementById(container))
    chart.draw(data,options)

  gatherData: (chart_data) ->
    nationally_important = []
    internationally_important = []
    nationally_important_area = 0
    internationally_important_area = 0
    total = []

    for data in chart_data
      if data.question_id in [5007, 4997, 4989]
        internationally_important.push(@getTotal(data.answers))
      else if data.question_id in [4726, 4581, 4679]
        nationally_important.push(@getTotal(data.answers))
      else if data.question_id ==  4801
        internationally_important_area = @getTotal(data.answers)
      else if data.question_id == 4459
        nationally_important_area = @getTotal(data.answers)

    for number, index in nationally_important
      total.push(number + internationally_important[index])

    data = {
      total_sites: total,
      nationally_important_sites: nationally_important,
      internationally_important_sites: internationally_important,
    }
    area = {
      nationally_important_area: nationally_important_area,
      internationally_important_area: internationally_important_area
    }

    @displayArea(data, area)
    @addMetaData(data)

  addMetaData: (data) ->
    keys = Object.keys(data)
    metadata = ['Sites', 'Total', 'Protected', 'Protected with management']
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
