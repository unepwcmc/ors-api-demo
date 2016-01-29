window.DemoBarChart = class DemoBarChart extends Chart
  constructor: (@respondents, @question_id) ->
    super(@respondents, @question_id)

  drawChart: (chart_data) ->
    data = new google.visualization.arrayToDataTable(chart_data['row_answers'])
    options = {
        title: "Density of Precious Metals",
        width: 600,
        height: 400,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
    }

    chart = new google.visualization.BarChart(document.getElementById('barschart'))
    chart.draw(data,options)

  hashToArray: (hash) ->
    super(hash, true)

  addData: (answers) ->
