# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

form = (answer_id) -> $('#edit_answer_' + answer_id)
errors = (answer_id) -> $('#errors-answer-' + answer_id + '.answer-errors')
destroy = (answer_id) -> $('#destroy-answer-' + answer_id + '.destroy-answer-link')

cancel = ->
  $(document.body).on 'click', '.edit-answer-link.cancel', (e) ->
    e.preventDefault();

    answer_id = $(this).data('resourceId')

    $(this).html 'Edit'
    $(this).removeClass 'cancel'

    form(answer_id).hide()
    errors(answer_id).hide()
    destroy(answer_id).show()

edit = ->
  $(document.body).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();

    if !$(this).hasClass('cancel')
      answer_id = $(this).data('resourceId')

      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'

      form(answer_id).show()
      errors(answer_id).show()
      destroy(answer_id).hide()


ready = ->
  edit()
  cancel()

$(document).ready(ready)

# newAnswer = ->
#   $(document.body).on 'ajax:success', 'form.new_answer', (e, data, status, xhr) ->
#     answer = $.parseJSON(xhr.responseText)
#     $('.answers').append('<p>' + answer.body + '</p>')

  # newAnswer()

  # .on('ajax:success', 'form.new_answer', newAnswer)


  # $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    # $('.answers').append('<%= render_resource(@answer, remotipart_submitted?) %>');
