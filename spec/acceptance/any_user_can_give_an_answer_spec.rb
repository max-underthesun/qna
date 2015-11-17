require 'rails_helper'

feature 'Create answer', %q{
  I want to be able to give an answer for the question
} do
  given(:question) { create(:question) }

  scenario 'user creates an answer' do
    visit question_path(question)
    click_on I18n.t('questions.show.answer')
    fill_in 'Body', with: 'answer the question'
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('confirmations.answers.create')
  end
end
