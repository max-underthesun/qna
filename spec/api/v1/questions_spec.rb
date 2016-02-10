require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        get "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        get "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get "/api/v1/questions", format: :json, access_token: access_token.token }

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(title body id updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it "question object contains short_title" do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json)
          .at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(body id updated_at created_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
              .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

      # %w(password encrypted_password).each do |attr|
      #   it "does not contain #{attr}" do
      #     expect(response.body).to_not have_json_path(attr)
      #   end
      # end
    end
  end

  # describe 'GET /all_except_current' do
  #   context 'unauthorized' do
  #     it "returns 'unauthorized' (401) status if there is no access_token" do
  #       get "/api/v1/profiles/all_except_current", format: :json
  #       expect(response.status).to eq 401
  #     end

  #     it "returns 'unauthorized' (401) status if an access_token is not valid" do
  #       get "/api/v1/profiles/all_except_current", format: :json, access_token: '1234'
  #       expect(response.status).to eq 401
  #     end
  #   end

  #   context 'authorized' do
  #     let!(:all) { create_list(:user, 5) }
  #     let!(:me) { all.sample }
  #     let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  #     before do
  #       get "/api/v1/profiles/all_except_current", format: :json,
  #                                                  access_token: access_token.token
  #     end

  #     it "returns 'success' (200) status with valid access_token" do
  #       expect(response).to be_success
  #     end

  #     it "contains list of all users except current_user" do
  #       expect(response.body).to be_json_eql((all - [me]).to_json)
  #     end
  #   end
  # end
end
