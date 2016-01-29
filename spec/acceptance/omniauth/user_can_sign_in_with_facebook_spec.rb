require_relative '../acceptance_helper'

feature 'USER SIGN_IN WITH FACEBOOK', %q(
  user can sign_in with his Facebook account
) do
  scenario 'with invalid credentials sign_in fail' do
    visit new_user_session_path

    mock_auth_hash_invalid
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook'
  end

  scenario 'with valid credentials user successfully sign_in' do
    visit new_user_session_path

    mock_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end
end
