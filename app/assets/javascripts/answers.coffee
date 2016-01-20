# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

form = (answer_id) -> $('#edit_answer_' + answer_id)
errors = (answer_id) -> $('#errors-answer-' + answer_id + '.answer-errors')
destroy = (answer_id) -> $('#destroy-answer-' + answer_id + '.destroy-answer-link')

voteButtonsToggleFor = (answer) ->
  $('.vote_up-answer-' + answer.id).toggle()
  $('.vote_down-answer-' + answer.id).toggle()
  $('.vote_destroy-answer-' + answer.id).toggle()

ratingRenewFor = (answer) ->
  $('#rating_for-answer_' + answer.id + ' .rating-value').html(answer.rating)

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

voteUp = ->
  $(document.body).on 'ajax:success', '.answers a.vote_up', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You voted up for the answer successfully'
    ratingRenewFor(answer)
    voteButtonsToggleFor(answer)
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

voteDown = ->
  $(document.body).on 'ajax:success', '.answers a.vote_down', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You voted down for the answer successfully'
    ratingRenewFor(answer)
    voteButtonsToggleFor(answer)
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

voteDestroy = ->
  $(document.body).on 'ajax:success', '.answers a.vote_destroy', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    success = 'You cancel your vote for the answer successfully'
    ratingRenewFor(answer)
    voteButtonsToggleFor(answer)
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_destroy', (e, xhr, status, error) ->
    failure = 'You can not cancel this vote'
    $('.flash').html(alert(failure, 'warning'))

privatePub = ->
  # gon.watch 'current_user_id'
  currentUserId = gon.current_user_id
  questionId = $('.answers').data('questionId')
  console.log(currentUserId)
  # console.log(gon.current_user_id)
  PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    rating = $.parseJSON(data['rating'])
    author = $.parseJSON(data['author'])
    attachments = $.parseJSON(data['attachments'])
    console.log(answer)
    if currentUserId != answer.user_id
      $('.answers').append(JST["answers/answer"]({
        answer: answer,
        rating: rating,
        author: author,
        current_user_id: currentUserId,
        question_id: questionId,
        question_user_id: gon.question_user_id,
        attachments: attachments
      }))

ready = ->
  edit()
  cancel()
  voteUp()
  voteDown()
  voteDestroy()
  privatePub()

$(document).ready(ready)
# $(document).on('page:load', privatePub)
# $(document).on('page:update', privatePub)
