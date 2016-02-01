require 'rails_helper'

RSpec.describe OauthAuthenticator, type: :model do
  describe ".find_or_create_user" do
    let!(:user) { create(:user) }

    context "user already has authorization" do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      let(:authenticator) { OauthAuthenticator.new(auth) }
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(authenticator.find_or_create_user).to eq user
      end
    end

    context "user has no authorization yet" do
      context "user already exists" do
        let(:auth) do
          user_params = { provider: 'facebook', uid: '123456', info: { email: user.email } }
          OmniAuth::AuthHash.new(user_params)
        end
        let(:authenticator) { OauthAuthenticator.new(auth) }

        it "should not create a new user" do
          expect { authenticator.find_or_create_user }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect { authenticator.find_or_create_user }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid equal to provided" do
          user = authenticator.find_or_create_user
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns user" do
          expect(authenticator.find_or_create_user).to eq user
        end
      end

      context "user does not exist" do
        let(:auth) do
          user_params = { provider: 'facebook', uid: '123456', info: { email: 'new@user.com' } }
          OmniAuth::AuthHash.new(user_params)
        end
        let(:authenticator) { OauthAuthenticator.new(auth) }

        it "creates a new user" do
          expect { authenticator.find_or_create_user }.to change(User, :count).by(1)
        end

        it "returns the user created" do
          expect(authenticator.find_or_create_user).to be_a(User)
        end

        it "fills user email" do
          expect(authenticator.find_or_create_user.email).to eq auth.info.email
        end

        it "creates authorization for user" do
          user = authenticator.find_or_create_user
          expect(user.authorizations).to_not be_empty
        end

        it "creates authorization with provider and uid equal to provided" do
          user = authenticator.find_or_create_user
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
