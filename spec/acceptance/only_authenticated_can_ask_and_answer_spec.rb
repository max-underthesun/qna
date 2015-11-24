require 'rails_helper'

feature 'Create question and answer', %q{
  authenticated user has to be able to ask questions and to give answers
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:invalid_question) { build(:invalid_question) }
  given(:invalid_answer) { build(:invalid_answer) }

  scenario 'authenticated user creates a question' do
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

  scenario 'authenticated user try to create invalid question' do
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

  scenario 'unauthenticated user try to create a question' do
    visit questions_path
    click_on I18n.t('questions.index.new')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end

  scenario 'authenticated user creates an answer' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    fill_in I18n.t('activerecord.attributes.answer.body'), with: answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('confirmations.answers.create')
    expect(page).to have_content answer.body
  end

  scenario 'authenticated user try to create invalid answer' do
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

  scenario 'unauthenticated user try to create an answer' do
    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
