window.DemoBarChart = class DemoBarChart extends Chart
  constructor: (@respondents, @question_id, @containers) ->
    @data = []
    super(@respondents, @question_id)

  initChart: (data) ->
    @data.push(@parseData(data))
    if DemoUtils.questions_ids.length > 0
      params = {
        question_id: "/questions/#{DemoUtils.questions_ids.shift()}",
        callback: @initChart
      }
      DemoUtils.ajaxRequest(params)
    else
      @drawChart(@data)

  drawChart: (chart_data) ->
    gathered_data = @gatherData(chart_data)
    for key, partial_data of gathered_data
      @drawPartial(partial_data, key)


  drawPartial: (partial_data, container) ->
    data = new google.visualization.arrayToDataTable(partial_data)
    options = {
        title: "Density of Precious Metals",
        width: 600,
        height: 400,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
    }

    chart = new google.visualization.BarChart(document.getElementById(container))
    chart.draw(data,options)

  gatherData: (chart_data) ->
    nationally_important = []
    internationally_important = []
    total = []

    for data, index in chart_data
      if index < 3
        internationally_important.push(@getTotal(data.answers))
      else
        nationally_important.push(@getTotal(data.answers))

    for number, index in nationally_important
      total.push(number + internationally_important[index])

    data = {
      total_sites: total,
      nationally_important_sites: nationally_important,
      internationally_important_sites: internationally_important
    }

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
    total = values.reduce (t, s) -> parseInt(t, 10) + parseInt(s, 10)

  addData: (answers) ->
