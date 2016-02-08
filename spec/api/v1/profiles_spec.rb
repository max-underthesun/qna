require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        get "/api/v1/profiles/me", format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        get "/api/v1/profiles/me", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

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

      # it "contains email" do
      #   expect(response.body).to be_json_eql(me.email.to_json).at_path('email')
      # end

      # it "contains id" do
      #   expect(response.body).to be_json_eql(me.id.to_json).at_path('id')
      # end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

      # it "does not contain password" do
      #   expect(response.body).to_not have_json_path('password')
      # end

      # it "does not contain encrypted_password" do
      #   expect(response.body).to_not have_json_path('encrypted_password')
      # end
    end
  end

  describe 'GET /all_except_current' do
    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        get "/api/v1/profiles/all_except_current", format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        get "/api/v1/profiles/all_except_current", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:all) { create_list(:user, 5) }
      let!(:me) { all.sample }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        all.delete(me)
        get "/api/v1/profiles/all_except_current", format: :json,
                                                   access_token: access_token.token
      end

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "contains list of users except current_user" do
        expect(response.body).to be_json_eql(all.to_json)
      end
    end
  end
end
