# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

form = (answer_id) -> $('#edit_answer_' + answer_id)
errors = (answer_id) -> $('#errors-answer-' + answer_id + '.answer-errors')
destroy = (answer_id) -> $('#destroy-answer-' + answer_id + '.destroy-answer-link')

alert = (value, type) -> (
    '<div class="alert alert-' + type + ' alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    <span aria-hidden="true">&times;</span></button>' + value + '</div>'
  )

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

vote_up = ->
  $(document.body).on 'ajax:success', '.answers a.vote_up', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You voted up for the answer successfully'
    $('#answer_' + answer.id + ' .rating-value').html(answer.rating)
    $('.vote_up-answer-' + answer.id).hide()
    $('.vote_down-answer-' + answer.id).hide()
    $('.vote_destroy-answer-' + answer.id).show()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

vote_down = ->
  $(document.body).on 'ajax:success', '.answers a.vote_down', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You voted down for the answer successfully'
    $('#answer_' + answer.id + ' .rating-value').html(answer.rating)
    $('.vote_up-answer-' + answer.id).hide()
    $('.vote_down-answer-' + answer.id).hide()
    $('.vote_destroy-answer-' + answer.id).show()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

vote_destroy = ->
  $(document.body).on 'ajax:success', '.answers a.vote_destroy', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You cancel your vote for the answer successfully'
    $('#answer_' + answer.id + ' .rating-value').html(answer.rating)
    $('.vote_up-answer-' + answer.id).show()
    $('.vote_down-answer-' + answer.id).show()
    $('.vote_destroy-answer-' + answer.id).hide()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_destroy', (e, xhr, status, error) ->
    failure = 'You can not cancel this vote'
    $('.flash').html(alert(failure, 'warning'))


ready = ->
  edit()
  cancel()
  vote_up()
  vote_down()
  vote_destroy()

$(document).ready(ready)

# newAnswer = ->
#   $(document.body).on 'ajax:success', 'form.new_answer', (e, data, status, xhr) ->
#     answer = $.parseJSON(xhr.responseText)
#     $('.answers').append('<p>' + answer.body + '</p>')

  # newAnswer()

  # .on('ajax:success', 'form.new_answer', newAnswer)


  # $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    # $('.answers').append('<%= render_resource(@answer, remotipart_submitted?) %>');
