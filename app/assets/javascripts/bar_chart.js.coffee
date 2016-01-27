window.BarChart = class BarChart
  constructor: (data)->
    @drawChart(data)

  drawChart: (chart_data) ->
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
