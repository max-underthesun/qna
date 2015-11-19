require 'rails_helper'

feature 'Create question', %q{
  in order to get answer I want to be able to ask questions
} do
  given(:question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  scenario 'user creates a question' do
    visit questions_path
    click_on I18n.t('questions.index.new')
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on I18n.t('questions.form.submit')

    expect(page).to have_content I18n.t('confirmations.questions.create')
  end

  scenario 'user try to create invalid question' do
    visit questions_path
    click_on I18n.t('questions.index.new')
    fill_in 'Title', with: invalid_question.title
    fill_in 'Body', with: invalid_question.body
    click_on I18n.t('questions.form.submit')

    expect(page).to have_content I18n.t('confirmations.questions.create')
  end
end
