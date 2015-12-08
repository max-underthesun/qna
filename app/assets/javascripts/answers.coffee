# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

form = (answer_id) -> $('#edit_answer_' + answer_id)
errors = (answer_id) -> $('#' + answer_id + '.answer-errors')
destroy = (answer_id) -> $('#' + answer_id + '.destroy-answer-link')

cancel = ->
  $(document.body).on 'click', '.edit-answer-link.cancel', (e) ->
  # $('.edit-answer-link.cancel').click (e) ->
    e.preventDefault();

    answer_id = $(this).attr('id')
    # form = f(answer_id)
    # form = $('#edit_answer_' + answer_id)
    # errors = $('#' + answer_id + '.answer-errors')
    # destroy = $('#' + answer_id + '.destroy-answer-link')

    $(this).html 'Edit'
    $(this).removeClass 'cancel'

    form(answer_id).hide()
    errors(answer_id).hide()
    destroy(answer_id).show()
    # edit()

edit = ->
  $(document.body).on 'click', '.edit-answer-link', (e) ->
  # $('.edit-answer-link').click (e) ->
    e.preventDefault();
    if !$(this).hasClass('cancel')

      answer_id = $(this).attr('id')
      # form = $('#edit_answer_' + answer_id)
      # errors = $('#' + answer_id + '.answer-errors')
      # destroy = $('#' + answer_id + '.destroy-answer-link')

      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'

      form(answer_id).show()
      errors(answer_id).show()
      destroy(answer_id).hide()
      # cancel()

ready = ->
  edit()
  cancel()

$(document).ready(ready)
# $(document).on('page:load', ready)
# $(document).on('page:update', ready)
