# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

cancel = ->
  $('.edit-answer-link.cancel').click (e) ->
    e.preventDefault();

    answer_id = $(this).attr('id')
    form = $('#edit_answer_' + answer_id)
    errors = $('#' + answer_id + '.answer-errors')
    destroy = $('#' + answer_id + '.destroy-answer-link')

    $(this).html 'Edit'
    $(this).removeClass 'cancel'

    form.hide()
    errors.hide()
    destroy.show()
    edit()

edit = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    if !$(this).hasClass('cancel')

      answer_id = $(this).attr('id')
      form = $('#edit_answer_' + answer_id)
      errors = $('#' + answer_id + '.answer-errors')
      destroy = $('#' + answer_id + '.destroy-answer-link')

      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'

      form.show()
      errors.show()
      destroy.hide()
      cancel()

ready = ->
  edit()
  cancel()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
