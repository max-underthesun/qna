require 'rails_helper'

feature 'Signing up', %q{
  in order to be able to sign in any user have to be able to sign up
} do
  given(:user) { build(:user) }
  given(:registered_user) { create(:user) }

  scenario 'user sign up successfully with valid data' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'user try to sign up with already registered email' do
    visit new_user_registration_path

    fill_in 'Email', with: registered_user.email
    fill_in 'Password', with: registered_user.password
    fill_in 'Password confirmation', with: registered_user.password_confirmation
    click_on 'Sign up'

    expect(current_path).to eq user_registration_path
    expect(page).to have_content "Email has already been taken"
  end
end
