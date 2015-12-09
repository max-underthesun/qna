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



# cancel = ->
#   $('.edit-question-link.cancel').click (e) ->
#     e.preventDefault();
#     $(this).html 'Edit'
#     $(this).removeClass 'cancel'
#     $('.edit_question').hide()
#     $('.question-errors').hide()
#     $('.destroy-question-link').show()
#     edit()

# edit = ->
#   $('.edit-question-link').click (e) ->
#     e.preventDefault();
#     if !$(this).hasClass('cancel')
#       $(this).html 'Cancel edit'
#       $(this).addClass 'cancel'
#       $('.edit_question').show()
#       $('.question-errors').show()
#       $('.destroy-question-link').hide()
#       cancel()

# ready = ->
#   edit()
#   cancel()

# $(document).ready(ready)
# $(document).on('page:load', ready)
# $(document).on('page:update', ready)


# ready = ->
#   $('.edit-question-link').click (e) ->
#     e.preventDefault();
#     if !$(this).hasClass('cancel')
#       $(this).html 'Cancel edit'
#       $(this).addClass 'cancel'
#       $('.question-errors').show()
#     else
#       $(this).html 'Edit'
#       $(this).removeClass 'cancel'
#       $('.question-errors').hide()
#     $('.edit_question').toggle()
#     $('.destroy-question-link').toggle()
#     # $('.question-errors').toggle()
# $(document).ready(ready)
# # $(document).on('page:load', ready)
# # $(document).on('page:update', ready)
# # $(document).on('page:partial-load', ready)


# $(document).ready ->
#   $('.edit-question-link').click (e) ->
#     e.preventDefault();
#     if !$(this).hasClass('cancel')
#       $(this).html 'Cancel edit'
#       $(this).addClass 'cancel'
#       $('.question-errors').show()
#     else
#       $(this).html 'Edit'
#       $(this).removeClass 'cancel'
#       $('.question-errors').hide()
#     $('.edit_question').toggle()
#     $('.destroy-question-link').toggle()
#     $('.question-errors').toggle()
#     return
#   return
