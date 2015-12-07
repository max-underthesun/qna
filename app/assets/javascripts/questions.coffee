# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

cancel = ->
  $('.edit-question-link.cancel').click (e) ->
    e.preventDefault();
    $(this).html 'Edit'
    $(this).removeClass 'cancel'
    $('.edit_question').hide()
    $('.question-errors').hide()
    $('.destroy-question-link').show()
    edit()

edit = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    if !$(this).hasClass('cancel')
      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'
      $('.edit_question').show()
      $('.question-errors').show()
      $('.destroy-question-link').hide()
      cancel()

ready = ->
  edit()
  cancel()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
