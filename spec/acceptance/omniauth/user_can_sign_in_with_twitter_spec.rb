require_relative '../acceptance_helper'

feature 'USER SIGN_IN WITH TWITTER', %q(
  user can sign_in with his Twitter account
) do
  scenario 'with invalid credentials sign_in fail' do
    visit new_user_session_path
    mock_auth_hash_invalid('twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter'
  end

  scenario 'with valid credentials user successfully sign_in' do
    visit new_user_session_path
    mock_auth_hash('twitter')
    click_on 'Sign in with Twitter'

    # find("input[name='email']").set('twitter@test.com')
    fill_in 'email', with: 'twitter@test.com'
    click_on 'Confirm email'

    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end
end
