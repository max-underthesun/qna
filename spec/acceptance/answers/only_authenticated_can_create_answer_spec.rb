require_relative '../acceptance_helper'

feature 'CREATE ANSWER', %q(
  authenticated user has to be able to give answers for the questions
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)

    visit question_path(question)
    within '.new-answer-form' do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
      click_on I18n.t('questions.show.submit_answer')
    end

    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('confirmations.answers.create')
    within('.answers') { expect(page).to have_content answer.body }
  end

  scenario 'Authenticated user try to create invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    within '.new-answer-form' do
      fill_in I18n.t('activerecord.attributes.answer.body'), with: invalid_answer.body
      click_on I18n.t('questions.show.submit_answer')
    end

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answer.body
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.answer.body')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
  end

  scenario 'Unauthenticated user try to create an answer' do
    visit question_path(question)
    fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
    click_on I18n.t('questions.show.submit_answer')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
