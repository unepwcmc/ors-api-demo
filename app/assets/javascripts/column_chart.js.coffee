window.ColumnChart = class ColumnChart extends Chart
  constructor: (@respondents) ->
    super(@respondents, '/questions/5002')

  drawChart: (chart_data) ->
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

  addData: (answers) ->
    answers.unshift(['Element', 'Density'])
    answers.push(['Not answered', 32])
