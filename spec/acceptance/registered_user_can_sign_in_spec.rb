require 'rails_helper'

feature 'SIGNING IN', %q(
  in order to be able to ask questions as a user I want to be able to sign in
) do
  given(:user) { create(:user) }
  given(:unregistered_user) { build(:user) }

  scenario '- registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario '- unregistered user try to sign in' do
    sign_in(unregistered_user)

    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'email')
    expect(current_path).to eq new_user_session_path
  end
end
