window.DemoBarChart = class DemoBarChart extends Chart
  constructor: (@respondents, @question_id, @containers) ->
    @data = []
    super(@respondents, @question_id, @containers[0])

  initChart: (data) ->
    @data.push(@parseData(data))
    if DemoUtils.questions_ids.length > 0
      params = {
        question_id: "/questions/#{DemoUtils.questions_ids.shift()}",
        callback: @initChart
      }
      DemoUtils.ajaxRequest(params)
    else
      $("##{@container}").removeClass("loading")
      @drawChart(@data)

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
            textPosition: 'none'
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
            textPosition: 'none'
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
            textPosition: 'none'
          },
          vAxis: { textPosition: 'none' }
        }
      }
      @drawPartial(partial_data, key, options[key])


  drawPartial: (partial_data, container, options) ->
    data = new google.visualization.arrayToDataTable(partial_data)
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
      internationally_important_sites: internationally_important,
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
