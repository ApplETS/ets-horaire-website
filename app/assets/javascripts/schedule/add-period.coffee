$ ->
  return unless $('body#schedule').length

  $(".day-off-list").find('.day-off-row').each (index, element) ->
    removeRowOnButtonClickIn $(element)

  source = $("#day-off-template").html()
  template = Handlebars.compile(source)

  $(".day-off-list .btn.add-period").click ->
    addPeriodButton = $(this)
    addPeriodButton.before template()

    addedRow = $(".day-off-list").find('.day-off-row:last')
    removeRowOnButtonClickIn addedRow

removeRowOnButtonClickIn = (row) -> row.find(".btn.remove-period").click -> row.remove()