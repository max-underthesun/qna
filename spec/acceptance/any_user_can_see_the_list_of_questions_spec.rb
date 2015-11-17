require 'rails_helper'

feature 'See all questions', %q{
  any user can see the questions index view page
} do
  scenario 'user visit questions index' do
    visit questions_path

    expect(page).to have_content I18n.t('questions.index.header')
  end
end
