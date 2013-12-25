$ ->
  return unless $('body#select_courses').length

  $(".leaves-list").find('.leave-row').each (index, element) ->
    removeRowOnButtonClickIn $(element)

  source = $("#leave-template").html()
  template = Handlebars.compile(source)

  $(".leaves-list .btn.add-period").click ->
    addPeriodButton = $(this)
    addPeriodButton.before template()

    addedRow = $(".leaves-list").find('.leave-row:last')
    removeRowOnButtonClickIn addedRow

removeRowOnButtonClickIn = (row) -> row.find(".btn.remove-period").click -> row.remove()