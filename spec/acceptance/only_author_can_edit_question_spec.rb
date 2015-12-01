require_relative 'acceptance_helper'

feature 'EDIT QUESTION', %q(
  author should have abiliti to edit his question
) do
  scenario '- unauthenticated user could not edit question'
  scenario '- authenticated user could not edit question of other user'
  scenario '- author successfully edit his question'
end
