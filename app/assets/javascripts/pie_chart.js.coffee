window.PieChart = class PieChart extends Chart
  constructor: (@respondents, @question_id, @container) ->
    super(@respondents, "/questions/#{@question_id}", @container)

  drawChart: (chart_data) ->
    data = new google.visualization.DataTable()
    data.addColumn('string', 'Answers')
    data.addColumn('number', 'Counts')
    data.addRows(chart_data['answers'])

    options = {
      colors: ['#2c53a7', '#e17d2e', '#30a9bb'],
      height: 500
    }

    chart = new google.visualization.PieChart(document.getElementById(@container))
    chart.draw(data, options)

  addData: (answers) ->
    answers.push ['Not answered', 32]


