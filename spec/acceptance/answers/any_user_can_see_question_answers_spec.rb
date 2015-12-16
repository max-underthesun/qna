require_relative '../acceptance_helper'

feature 'SEE QUESTION ANSWERS', %q(
  any user can see all the answers for the question
) do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario '- user visit question show and see the answers' do
    visit question_path(question)

    expect(page).to have_content I18n.t('questions.show.answers_list')
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
