module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '123456',
      info: { email: 'test@test.com' },
      credentials: { token: 'token' }
    )
  end

  def mock_auth_hash_invalid
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
