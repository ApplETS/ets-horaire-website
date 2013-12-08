$ ->
  return unless $('body#select_file').length

  $.each ['input-file', 'input-link'], (index, inputId) ->
    $("##{inputId}").click ->
      $("##{inputId}-selected").click()