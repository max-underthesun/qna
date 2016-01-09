# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

alert = (value, type) -> (
    '<div class="alert alert-' + type + ' alert-dismissible" role="alert">
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
    <span aria-hidden="true">&times;</span></button>' + value + '</div>'
  )

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

  $(document.body).on 'ajax:success', 'a.vote_up', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    success = 'You voted successfully'
    $('#question_' + question.id + ' .rating-value').html(question.rating)
    # $('a#vote_up-question-' + question.id).hide()
    $('.flash').append(alert(success, 'success'))
  .on 'ajax:error', 'a.vote_up', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('.flash').empty()
    $.each errors, (index, value) ->
      $('.flash').append(alert(value, 'warning'))


        # '<div class="alert alert-warning alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + value + '</div>')


        # '<div class="alert alert-danger fade in  button close" data-dismiss="alert">' + value + '</div>')

  # $('a.vote_up').bind 'ajax:success', (e, data, status, xhr) ->
  #   question = $.parseJSON(xhr.responseText)
  #   $('#question_' + question.id + ' .rating-value').html(question.rating)
  # .bind 'ajax:error', (e, xhr, status, error) ->
  #   errors = $.parseJSON(xhr.responseText)
  #   $.each errors, (index, value) ->
  #     $('.flash').append(value)