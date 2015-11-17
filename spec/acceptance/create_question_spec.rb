require 'rails_helper'

feature 'Create question', %q{
  in order to get answer
  as an authenticated user
  I want to be able to ask questions
} do

  scenario 'authenticated user creates a question' do
    User.create(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'
    click_on 'Submit'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'unauthenticated user try to create a question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
