window.BarChart = class BarChart
  constructor: (data)->
    @drawChart(data)

  drawChart: (chart_data) ->
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
