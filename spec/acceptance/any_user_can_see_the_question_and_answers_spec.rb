require 'rails_helper'

feature 'See all questions', %q{
  any user can see the questions index view page
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'user visit questions index' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content I18n.t('questions.show.answers_list')
    expect(page).to have_content answer.body
  end
end
