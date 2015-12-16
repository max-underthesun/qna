# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

form = (answer_id) -> $('#edit_answer_' + answer_id)
errors = (answer_id) -> $('#' + answer_id + '.answer-errors')
destroy = (answer_id) -> $('#' + answer_id + '.destroy-answer-link')

cancel = ->
  $(document.body).on 'click', '.edit-answer-link.cancel', (e) ->
    e.preventDefault();

    answer_id = $(this).attr('id')

    $(this).html 'Edit'
    $(this).removeClass 'cancel'

    form(answer_id).hide()
    errors(answer_id).hide()
    destroy(answer_id).show()

edit = ->
  $(document.body).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();

    if !$(this).hasClass('cancel')
      answer_id = $(this).attr('id')

      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'

      form(answer_id).show()
      errors(answer_id).show()
      destroy(answer_id).hide()

ready = ->
  edit()
  cancel()

$(document).ready(ready)
