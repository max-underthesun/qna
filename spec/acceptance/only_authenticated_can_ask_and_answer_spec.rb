require 'rails_helper'

feature 'Create question', %q{
  in order to get answer as an authenticated user
  I want to be able to ask questions
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

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on I18n.t('questions.form.submit')

    expect(page).to have_content I18n.t('confirmations.questions.create')
  end

  scenario 'authenticated user try to create invalid question' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('questions.index.new')

    fill_in 'Title', with: invalid_question.title
    fill_in 'Body', with: invalid_question.body
    click_on I18n.t('questions.form.submit')

    expect(current_path).to eq questions_path
    expect(page).to have_content "title can't be blank"
    expect(page).to have_content "body can't be blank"
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

    fill_in 'Body', with: answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('confirmations.answers.create')
  end

  scenario 'authenticated user try to create invalid answer' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    fill_in 'Body', with: invalid_answer.body
    click_on I18n.t('answers.new.submit')

    expect(current_path).to eq question_answers_path(question)
    expect(page).to have_content "body can't be blank"
  end

  scenario 'unauthenticated user try to create an answer' do
    visit questions_path
    click_on I18n.t('links.show')

    click_on I18n.t('questions.show.answer')

    fill_in 'Body', with: answer.body
    click_on I18n.t('answers.new.submit')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
