$ ->
  source = $("#day-off-template").html()
  template = Handlebars.compile(source)

  $(".day-off-list .btn.add-period").click ->
    addPeriodButton = $(this)
    addPeriodButton.before template()

    addedRow = $(".day-off-list").find('.day-off-row:last')
    addedRow.find(".btn.remove-period").click -> addedRow.remove()