require 'rails_helper'

feature 'Create answer', %q{
  I want to be able to give an answer for the question
} do
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }
  given(:invalid_answer) { build(:invalid_answer) }

  scenario 'user creates an answer' do
    visit question_path(question)
    click_on I18n.t('questions.show.answer')

    fill_in 'Body', with: answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('confirmations.answers.create')
  end

  scenario 'user creates an invalid answer' do
    visit question_path(question)
    click_on I18n.t('questions.show.answer')

    fill_in 'Body', with: invalid_answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content "body can't be blank"
  end
end
