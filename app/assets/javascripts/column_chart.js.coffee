window.ColumnChart = class ColumnChart extends Chart
  constructor: (@respondents) ->
    super(@respondents, '/questions/5002')

  drawChart: (chart_data) ->
    data = new google.visualization.arrayToDataTable(chart_data['answers'])

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
    @drawRowChart(chart_data['row_answers']) if chart_data['row_answers']

  drawRowChart: (chart_data) ->
    data = new google.visualization.arrayToDataTable(chart_data)

    options = {
      height: 400,
      legend: { position: 'top', maxLines: 1 },
      isStacked: 'percent'
      hAxis: {
        minValue: 0,
        ticks: [0, .3, .6, .9, 1]
      }
    }
    chart = new google.visualization.BarChart(document.getElementById('barchart'))
    chart.draw(data, options)


  hashToArray: (hash) ->
    super(hash, true)

  addData: (answers) ->
    colors = ['#111', '#555', '#777', '#222', '#999']
    answers.map((answer) ->
      answer.push colors.shift()
    )
    answers.unshift(['Element', 'Density', {role: 'style'}])
    answers.push(['Not answered', 32, colors.shift()])
