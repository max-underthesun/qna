require 'rails_helper'

feature 'Destroy question or answer', %q{
  an author has to be able to destroy his questions or answers,
  but to not be able to destroy others questions or answers
} do
  given(:user) { create(:user) }
  given(:question) { build(:question) }
  given(:answer) { build(:answer) }

  scenario 'author destroying his question' do
    sign_in(user)

    visit questions_path
    click_on I18n.t('questions.index.new')

    fill_in I18n.t('activerecord.attributes.question.title'), with: question.title
    fill_in I18n.t('activerecord.attributes.question.body'), with: question.body
    click_on I18n.t('questions.form.submit')

    click_on I18n.t('links.destroy')

    expect(current_path).to eq questions_path
    expect(page).to have_content I18n.t('confirmations.questions.destroy')
  end
end
