require 'rails_helper'

feature 'Signing out', %q{
  signed in user can sign out to finish the session
} do
  given(:user) { create(:user) }

  scenario 'registered signing in and signing out' do
    sign_in(user)

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
    expect(current_path).to eq root_path

    click_on I18n.t('links.sign_out')

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
    expect(page).to have_content I18n.t('links.sign_in')
  end
end
