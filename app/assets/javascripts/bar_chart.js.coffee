window.BarChart = class BarChart
  constructor: (data, options)->
    @drawChart(data, options)

  drawChart: (chart_data, options) ->
    data = new google.visualization.arrayToDataTable(chart_data)


    chart = new google.visualization.BarChart(document.getElementById(options.container))
    chart.draw(data, options.chart_options)
