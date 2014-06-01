$ ->
  return unless $('body.select_courses').length

  apply_filter_behavior_for 'leave'
  apply_filter_behavior_for 'restriction'

apply_filter_behavior_for = (name) ->
  $(".#{name}s-list").find(".#{name}-row").each (index, element) ->
    removeOnButtonClickIn $(element), name

  source = $("##{name}-template").html()
  template = Handlebars.compile(source)

  $(".#{name}s-list .btn.add-#{name}").click ->
    addPeriodButton = $(this)
    addPeriodButton.before template()

    addedRow = $(".#{name}s-list").find(".#{name}-row:last")
    removeOnButtonClickIn addedRow, name

removeOnButtonClickIn = (row, name) ->
  row.find(".btn.remove-#{name}").click ->
    row.remove()