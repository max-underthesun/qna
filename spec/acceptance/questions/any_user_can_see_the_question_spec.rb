require_relative '../acceptance_helper'

feature 'SEE QUESTION', %q(
  any user can see the question
) do
  given!(:question) { create(:question) }

  scenario '- user visit question show and see the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
