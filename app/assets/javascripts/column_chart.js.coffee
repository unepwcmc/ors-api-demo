window.ColumnChart = class ColumnChart extends Chart
  constructor: (@respondents, @question_id) ->
    super(@respondents, "/questions/#{@question_id}")

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
        gridlines: {color: '#d6d6d6', count: 1},
        minorGridlines: {color: '#f1f1f1', count: 4}
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
    @addRowChart(chart_data['row_answers']) if chart_data['row_answers']
    @addTargetChart(chart_data['target']) if chart_data['target']

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

  addRowChart: (chart_data) ->
    options = {
      container: 'barchart',
      chart_options: {
        height: 100,
        legend: { position: 'bottom', maxLines: 2 },
        isStacked: 'percent'
        colors: ['#2c53a7', '#6d88c4', '#e17d2e', '#30a9bb', '#858585']
        hAxis: {
          minValue: 0,
          ticks: [0, .3, .6, .9, 1]
          gridlines: {color: '#d6d6d6', count: 1},
          minorGridlines: {color: '#f1f1f1', count: 4},
          textPosition: 'none',
        },
        vAxis: {
          textPosition: 'none'
        }
      }
    }
    new BarChart(chart_data, options)

  addTargetChart: (chart_data) ->
    options = {
      container: 'target_chart'
      chart_options: {
        height: 100,
        legend: { position: 'none' },
        isStacked: 'percent'
        colors: ['#25437B', '#d6d6d6']
        hAxis: {
          minValue: 0,
          ticks: [0, .2, .4, .6, .8, 1]
          gridlines: {color: '#d6d6d6', count: 1},
          minorGridlines: {color: '#f1f1f1', count: 4},
          #textPosition: 'none',
        },
        vAxis: {
          textPosition: 'none'
        }
      }
    }

    new BarChart(chart_data, options)
