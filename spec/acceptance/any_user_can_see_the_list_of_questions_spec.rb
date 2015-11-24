require 'rails_helper'

feature 'See all questions', %q{
  any user can see the questions index view page
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'user visit questions index' do
    visit questions_path

    expect(page).to have_content I18n.t('questions.index.header')
    questions.each { |question| expect(page).to have_content question.title }
  end
end
