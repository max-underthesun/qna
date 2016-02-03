module OmniauthMacros
  def mock_auth_hash(provider)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    email = 'test@test.com' unless provider == 'twitter'

    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '123456',
      info: { email: email }
    )
  end

  def mock_auth_hash_invalid(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
