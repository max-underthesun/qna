# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    if !$(this).hasClass('cancel')
      $(this).html 'Cancel edit'
      $(this).addClass 'cancel'
    else
      $(this).html 'Edit'
      $(this).removeClass 'cancel'
    $('.edit_question').toggle()
    $('.destroy-question-link').toggle()
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('page:partial-load', ready)
