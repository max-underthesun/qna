require 'rails_helper'

feature 'DESTROY ANSWER', %q(
  an author has to be able to destroy his questions or answers,
  but to not be able to destroy others questions or answers
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario '- author destroying his answer successfully' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content answer.body
    click_on I18n.t('questions.answer.destroy_answer')

    expect(page).to_not have_content answer.body
    expect(page).to have_content I18n.t('confirmations.answers.destroy')
  end

  scenario '- user trying to destroy answer of other user with no success' do
    sign_in(other_user)

    visit questions_path
    click_on I18n.t('links.show')
    expect(page).to_not have_link(I18n.t('questions.answer.destroy_answer'),
                                  href: answer_path(answer))
  end
end
