require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"
    # let(:api_path) { "/api/v1/profiles/me" }

    # context 'unauthorized' do
    #   it "returns 'unauthorized' (401) status if there is no access_token" do
    #     get "/api/v1/profiles/me", format: :json
    #     expect(response.status).to eq 401
    #   end

    #   it "returns 'unauthorized' (401) status if an access_token is not valid" do
    #     get "/api/v1/profiles/me", format: :json, access_token: '1234'
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get "/api/v1/profiles/me", format: :json, access_token: access_token.token }

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      %w(email id updated_at created_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles/me", { format: :json }.merge(options)
    end
  end

  describe 'GET /all_except_current' do
    it_behaves_like "API Authenticable"

    # context 'unauthorized' do
    #   it "returns 'unauthorized' (401) status if there is no access_token" do
    #     get "/api/v1/profiles/all_except_current", format: :json
    #     expect(response.status).to eq 401
    #   end

    #   it "returns 'unauthorized' (401) status if an access_token is not valid" do
    #     get "/api/v1/profiles/all_except_current", format: :json, access_token: '1234'
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let!(:all) { create_list(:user, 5) }
      let!(:me) { all.sample }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get "/api/v1/profiles/all_except_current", format: :json,
                                                   access_token: access_token.token
      end

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "contains list of all users except current_user" do
        expect(response.body).to be_json_eql((all - [me]).to_json).at_path('profiles')
      end
    end

    def do_request(options = {})
      get "/api/v1/profiles/all_except_current", { format: :json }.merge(options)
    end
  end
end
