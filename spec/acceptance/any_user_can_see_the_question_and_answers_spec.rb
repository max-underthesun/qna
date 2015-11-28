require_relative 'acceptance_helper'

feature 'SEE QUESTION AND ANSWERS', %q(
  any user can see the question and all answers for it
) do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'user visit question show' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content I18n.t('questions.show.answers_list')
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
