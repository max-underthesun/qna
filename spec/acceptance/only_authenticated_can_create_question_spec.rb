require_relative 'acceptance_helper'

feature 'CREATE QUESTION', %q(
  authenticated user has to be able to ask questions
) do
  given(:user) { create(:user) }
  given(:question) { build(:question) }
  given(:invalid_question) { build(:invalid_question) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('questions.index.new')

    fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
    fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
    click_on I18n.t('questions.form.submit')

    expect(page).to have_content I18n.t('confirmations.questions.create')
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Authenticated user try to create invalid question' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('questions.index.new')

    fill_in I18n.t('activerecord.attributes.question.title'), with: invalid_question.title
    fill_in I18n.t('activerecord.attributes.question.body'), with: invalid_question.body
    click_on I18n.t('questions.form.submit')

    expect(current_path).to eq questions_path
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.question.title')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
    expect(page).to have_content(
      "#{I18n.t('activerecord.attributes.question.body')} "\
      "#{I18n.t('activerecord.errors.messages.blank')}"
    )
  end

  scenario 'Unauthenticated user try to create a question' do
    visit questions_path
    click_on I18n.t('questions.index.new')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
