require 'rails_helper'

feature 'Destroy question or answer', %q{
  an author has to be able to destroy his questions or answers,
  but to not be able to destroy others questions or answers
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'author destroying his question' do
    sign_in(user)

    visit questions_path
    expect(page).to have_content question.title
    click_on I18n.t('links.show')

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    click_on I18n.t('links.destroy')

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
    expect(page).to have_content I18n.t('confirmations.questions.destroy')
  end

  scenario 'user trying to destroy question of other user' do
    sign_in(other_user)

    visit questions_path
    click_on I18n.t('links.show')
    expect(page).to_not have_link(I18n.t('links.destroy'), href: question_path(question))
  end

  scenario 'author destroying his answer' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content answer.body
    click_on I18n.t('questions.show.destroy_answer')

    expect(page).to_not have_content answer.body
    expect(page).to have_content I18n.t('confirmations.answers.destroy')
  end

  scenario 'user trying to destroy answer of other user' do
    sign_in(other_user)

    visit questions_path
    click_on I18n.t('links.show')
    expect(page).to_not have_link(I18n.t('questions.show.destroy_answer'),
                                  href: answer_path(answer))
  end
end
