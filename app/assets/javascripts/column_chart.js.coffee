window.ColumnChart = class ColumnChart extends Chart
  constructor: (@respondents) ->
    super(@respondents, '/questions/5002')

  drawChart: (chart_data) ->
    data = new google.visualization.arrayToDataTable(chart_data['answers'])

    options = {
      bar: {groupWidth: '60%'},
      legend: {position: 'none'},
      height: 500,
      vAxis: {
        viewWindow: {
          min: 0,
          max: 35
        },
        ticks: [0, 5, 10, 15, 20, 25, 30, 35],
        gridlines: {color: '#d6d6d6', count: 1},
        minorGridlines: {color: '#f1f1f1', count: 4}
      },
      hAxis: {
        textPosition: 'none',
      },
      annotations: {
        alwaysOutside: true,
        textStyle: {
          fontSize: 14
        },
      },
    }
    chart = new google.visualization.ColumnChart(document.getElementById('column_chart_div'))
    chart.draw(data,options)
    @drawRowChart(chart_data['row_answers']) if chart_data['row_answers']

  drawRowChart: (chart_data) ->
    data = new google.visualization.arrayToDataTable(chart_data)

    options = {
      height: 100,
      legend: { position: 'bottom', maxLines: 2 },
      isStacked: 'percent'
      hAxis: {
        minValue: 0,
        ticks: [0, .3, .6, .9, 1]
        gridlines: {color: '#d6d6d6', count: 1},
        minorGridlines: {color: '#f1f1f1', count: 4},
        textPosition: 'none',
      }
    }
    chart = new google.visualization.BarChart(document.getElementById('barchart'))
    chart.draw(data, options)


  hashToArray: (hash) ->
    super(hash, true)

  addData: (answers) ->
    colors = ['#2c53a7', '#6d88c4', '#e17d2e', '#30a9bb', '#858585']
    answers.map((answer) ->
      answer.push colors.shift()
      answer.push answer[1]
    )
    answers.unshift(['Element', 'Density', {role: 'style'}, {role: 'annotation'}])
    answers.push(['Not answered', 32, colors.shift(), 32])
