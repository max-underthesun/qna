require_relative '../acceptance_helper'

feature 'USER SIGN_IN WITH FACEBOOK', %q(
  user can sign_in with his Facebook account
) do
  scenario 'with invalid credentials sign_in fail' do
    visit new_user_session_path
    mock_auth_hash_invalid('facebook')
    click_on 'Sign in with Facebook'

    expect(page).to have_content I18n.t('errors.epmty_auth')
  end

  scenario 'with valid credentials user successfully sign_in' do
    visit new_user_session_path
    mock_auth_hash('facebook')
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end
end
