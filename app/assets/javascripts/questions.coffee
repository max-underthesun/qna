# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $(document.body).on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    if !$(this).hasClass('cancel')
      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'
      $('.edit_question').show()
      $('.question-errors').show()
      $('.destroy-question-link').hide()

  $(document.body).on 'click', '.edit-question-link.cancel', (e) ->
    e.preventDefault();
    $(this).html 'Edit'
    $(this).removeClass 'cancel'
    $('.edit_question').hide()
    $('.question-errors').hide()
    $('.destroy-question-link').show()

  $(document.body).on 'ajax:success', '.question a.vote_up', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    success = 'You voted up for the question successfully'
    $('#rating_for-question_' + question.id + ' .rating-value').html(question.rating)
    $('.vote_up-question-' + question.id).hide()
    $('.vote_down-question-' + question.id).hide()
    $('.vote_destroy-question-' + question.id).show()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

  $(document.body).on 'ajax:success', '.question a.vote_down', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    success = 'You voted down for the question successfully'
    $('#rating_for-question_' + question.id + ' .rating-value').html(question.rating)
    $('.vote_up-question-' + question.id).hide()
    $('.vote_down-question-' + question.id).hide()
    $('.vote_destroy-question-' + question.id).show()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_down', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))

  $(document.body).on 'ajax:success', '.question a.vote_destroy', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    success = 'You cancel your vote for the question successfully'
    $('#rating_for-question_' + question.id + ' .rating-value').html(question.rating)
    $('.vote_up-question-' + question.id).show()
    $('.vote_down-question-' + question.id).show()
    $('.vote_destroy-question-' + question.id).hide()
    $('.flash').html(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_destroy', (e, xhr, status, error) ->
    failure = 'You can not cancel this vote'
    $('.flash').html(alert(failure, 'warning'))

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    author = $.parseJSON(data['author'])
    $('tbody').append(JST["questions/index"]({
        question: question,
        author: author
      }))

  $(document.body).on 'click', '.new-comment-for-question-link', (e) ->
    e.preventDefault();
    question_id = $(this).data('resourceId')
    if gon.current_user_id
      if !$(this).hasClass('cancel')
        $(this).html 'cancel adding new comment'
        $(this).addClass 'cancel'
        $('#new-comment-form-for-question-' + question_id).show()
        $('.comment-errors#comment-errors-for-question-' + question_id).show()
    else
      failure = 'You have to sign in for comment the question'
      $('.flash').html(alert(failure, 'warning'))

  $(document.body).on 'click', '.new-comment-for-question-link.cancel', (e) ->
    e.preventDefault();
    question_id = $(this).data('resourceId')
    $(this).html 'new comment'
    $(this).removeClass 'cancel'
    $('#new-comment-form-for-question-' + question_id).hide()
    $('.comment-errors#comment-errors-for-question-' + question_id).hide()

  currentUserId = gon.current_user_id
  questionId = $('.answers').data('questionId')
  console.log(questionId)
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    author = $.parseJSON(data['author'])
    if currentUserId != comment.user_id
      $('#comments-for-question-' + questionId).append(JST["comments/comment"]({
          comment: comment,
          author: author
        }))
