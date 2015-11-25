require 'rails_helper'

feature 'CREATE ANSWER', %q(
  authenticated user has to be able to give answers for the questions
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }

  scenario 'Authenticated user creates an answer' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('confirmations.answers.create')
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user try to create invalid answer' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    fill_in I18n.t('activerecord.attributes.answer.body'), with: invalid_answer.body
    click_on I18n.t('answers.new.submit')

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.answer.body')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
  end

  scenario 'Unauthenticated user try to create an answer' do
    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
