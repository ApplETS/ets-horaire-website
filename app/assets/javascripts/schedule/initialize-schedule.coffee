$ ->
  return unless $('body#schedule').length

  initializeDayOffBehavior()
  initializeCourseSelectionBehavior()

initializeDayOffBehavior = ->
  $(".day-off-list").find('.day-off-row').each (index, element) ->
    removeRowOnButtonClickIn $(element)

  source = $("#day-off-template").html()
  template = Handlebars.compile(source)

  $(".day-off-list .btn.add-period").click ->
    addPeriodButton = $(this)
    addPeriodButton.before template()

    addedRow = $(".day-off-list").find('.day-off-row:last')
    removeRowOnButtonClickIn addedRow

initializeCourseSelectionBehavior = ->
  $('.course').each (index, course) ->
    $course = $(course)
    $course.first('input:checkbox').change (event) ->
      class_name = (if event.target.checked then 'success' else 'primary')
      $course.removeClass('label-primary').removeClass('label-success').addClass "label-#{class_name}"

removeRowOnButtonClickIn = (row) -> row.find(".btn.remove-period").click -> row.remove()