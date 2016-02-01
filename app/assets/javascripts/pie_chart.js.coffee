window.PieChart = class PieChart extends Chart
  constructor: (@respondents, @question_id) ->
    super(@respondents, "/questions/#{@question_id}")

  drawChart: (chart_data) ->
    data = new google.visualization.DataTable()
    data.addColumn('string', 'Answers')
    data.addColumn('number', 'Counts')
    data.addRows(chart_data['answers'])

    options = {
      'title':'A title',
      'width':400,
      'height':300
    }

    chart = new google.visualization.PieChart(document.getElementById('pie_chart_div'))
    chart.draw(data, options)

  addData: (answers) ->
    answers.push ['Not answered', 32]


